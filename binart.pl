#!/usr/bin/perl
#
# draws one-bit patterns by given f(x,y)
# yet something seems off, because it doesn't work well with
# @bitartbot@botsin.space 's functions
#
# krzysckh 2023
# krzysckh.org

use strict;
use warnings;

use Getopt::Std;

my ($sz, $fv, $o, %opts) = (undef, undef, undef, (o => "/dev/stdout",
  s => "256x256"));
my ($max_x, $max_y, @vals);

sub help() {
  print STDERR "usage: $0 [-h] [-o file] [-s size (e.g. 256x256)] " .
    "'f(x,y) = ...'\n";
  exit 0;
}

getopts("ho:s:", \%opts);
($o, $sz) = ($opts{o}, $opts{s});
$fv = shift @ARGV;

help if $opts{h} or not $fv or not $fv =~ /^f\(x,y\) = .*$/ or not
  $sz =~ /^([0-9]+)x([0-9]+)$/;

($max_x, $max_y) = ($1, $2);
$fv =~ s/^f\(x,y\) = //;
$fv =~ s/(x|y)/(0 + \$$1)/g;

print "P3\n$max_x $max_y\n255\n";


for (0..$max_y - 1) {
  my $y = $_;
  for (0..$max_x - 1) {
    my $x = $_;
    my $v = eval $fv;

    print(($@?0:$v)?"255 ":"0 ") for 1..3;
  }
}



