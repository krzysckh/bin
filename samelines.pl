#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

my @l;

push @l, $_ while <>;
chomp for @l;
my $maxl = max map length, @l;
print $_, " " x ($maxl - length), "\n" for @l;
