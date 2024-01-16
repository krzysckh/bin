#!/usr/bin/perl
#
# troche getto sposób na https://log.krzysckh.org
# no cóż

use strict;
use warnings;

use feature qw(say);

use Getopt::Std qw(getopts);
use JSON qw(decode_json);
use Class::Struct;
use File::Slurp qw(read_file write_file);
use POSIX qw(strftime);
use File::Basename qw(fileparse);

use Pandoc;

use Data::Printer;

my $editor = defined $ENV{EDITOR} ? $ENV{EDITOR} : "vi";
my $cfg_location = $ENV{HOME} . "/.log.cfg";
my $cfg;

sub fparse {
  return 0 + [split /\./, scalar [fileparse(shift)]->[0]]->[0];
}

sub getcfg {
  if (-f $cfg_location) {
    $cfg = decode_json("" . read_file($cfg_location));
  } else {
    my $s;
    $s .= $_ while <DATA>;
    $cfg = decode_json($s);
  }

  my $home = $ENV{HOME};
  $cfg->{repo} =~ s/~/$home/g;
}

sub git {
  my $cmd = join " ", @_;
  my $v = `git $cmd`;
  chomp $v;

  $v = "OK $cmd" if $v eq "";

  say "GIT: $v";
}

sub init {
  my $repo = $cfg->{repo};

  die "no \"repo\" in schema" if not defined $repo;
  die "no \"remote\" in schema" if not defined $cfg->{remote};
  die $repo . " already initialized" if -e File::Spec->canonpath($repo . "/.git");

  git "init", $repo;
  chdir $repo or die $!;

  git "remote", "add", "origin", $cfg->{remote};

  exit 0;
}

sub help {
  print <<_;
log.pl [-hipP]

-h    help
-i    init repo
-p    pull updates and push to remote
-P    force push to remote
_
  exit 0;
}

sub add {
  my $repo = $cfg->{repo};
  my $fname = strftime "$repo/%Y%m%d.md", localtime;

  if (not -f $fname) {
    write_file($fname, strftime("# %A, %d %B %Y\n\n", localtime));
  }

  system("$editor $fname");
  exit 0
}

sub render {
  my $html;
  my $md;
  for (reverse sort { fparse($a) <=> fparse($b) } glob $cfg->{repo} . "/*.md") {
    $md .= read_file($_) . "\n\n";
  }

  pandoc -f => 'gfm', -t => 'html', "--self-contained", { in => \$md, out => \$html };
  write_file($cfg->{repo} . "/index.html", $html);
}

sub gpush {
  my ($force) = @_;

  render;
  chdir $cfg->{repo};
  git "pull", "origin", "master";
  git "add", "--all";
  git "commit", "-m", "" . time;
  if ($force) {
    git "push", "--force", "-u", "origin", "master";
  } else {
    git "push", "-u", "origin", "master";
  }

  system $cfg->{afterpush} if defined $cfg->{afterpush};
  exit 0
}

sub main {
  my %args;
  getopts('iPph', \%args);

  getcfg;
  help if $args{h};
  init if $args{i};
  gpush if $args{p};
  gpush 1 if $args{P};

  add
}

main
__DATA__
{
  "repo": "~/.log/"
}
