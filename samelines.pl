#!/usr/bin/perl

use strict;
use warnings;

my @l;
my $i = 0;
my $maxlen = 0;

while (<>) {
  s/\n//g;
  $l[$i] = $_;
  $i++;
}

foreach (@l) {
  $maxlen = length if length > $maxlen;
}

print $_, " " x ($maxlen - length), "\n" foreach (@l);

