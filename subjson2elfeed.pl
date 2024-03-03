#!/usr/bin/perl
# -*- mode: perl; perl-indent-level: 2 -*-

# this script extracts ids of youtube channels exported from a piped.video instance
# and writes ~/.elfeed-yt file that can then be loaded to use with elfeed
#
# krzysckh 2024
# krzysckh.org

use strict;
use warnings;

use feature 'say';

use JSON qw(decode_json);
use File::Slurp qw(read_file);

exit 1 if not defined $ARGV[0];

my $target = $ENV{HOME} . "/.elfeed-yt";
my @jdata = @{decode_json("".read_file($ARGV[0]))->{subscriptions}};
my @ids = map { [split '/', $_->{url}]->[-1] } @jdata;

open my $f, '>', $target;

printf $f qq{;; -*- mode: emacs-lisp -*-\n};
printf $f qq{(setq elfeed-youtube-rss-feeds '(\n};

for (@ids) {
  print $f qq(  ("https://www.youtube.com/feeds/videos.xml?channel_id=$_" yt)\n);
}

printf $f q{))};

close $f;
say "written $target";
