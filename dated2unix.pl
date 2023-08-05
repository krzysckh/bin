#!/usr/bin/perl
#
# prints the unix timestamp for images saved by my phone
# mainly for img.krzysckh.org
#
# :^)
#
# krzysckh 2022
# krzysckh.org

use strict;
use warnings;

use File::Basename;
use Time::Piece;

my $fname;
my $t;

die "usage: $0 /path/to/IMG_...." if not defined $ARGV[0];

$fname = $ARGV[0];

die "$fname is not a file" if not -f $fname;

$fname = basename($fname);

die "basename not in right format" if not
  $fname =~ /IMG_[0-9]{8}_[0-9]{9}(_MFNR)?\..*/;

$fname =~ s/...(_MFNR)?\..*//;
$fname =~ s/IMG//;
$fname =~ s/_//;

$t = Time::Piece->strptime($fname, "%Y%m%d_%H%M%S");
print $t->epoch, "\n";
