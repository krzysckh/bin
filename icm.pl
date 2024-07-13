#!/usr/bin/perl
# pogoda z icmu
#
# krzysckh 2023
# krzysckh.org

use strict;
use warnings;

use HTTP::Tiny;

my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
  localtime(time);

# magiczne numerki, (Kraków, Polska)
# http://meteo.icm.edu.pl/
my ($x, $y) = (466, 232);

$mon  = sprintf("%02d", 1 + $mon);
$mday = sprintf("%02d", $mday);
$year += 1900;

my $c = HTTP::Tiny->new;
my $res = $c->get("http://old.meteo.pl/um/metco/mgram_pict.php"
  . "?ntype=0u&fdate=$year$mon$mday" . "06&row=$x&col=$y&lang=pl");

print $res->{content};
