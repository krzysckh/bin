#!/usr/bin/perl
#
# evaluate @ARGV or stdin in current emacs session

use strict;
use warnings;

use IO::Socket::UNIX;
use List::Util qw(reduce);

my $emac = IO::Socket::UNIX->new(Type => SOCK_STREAM(), Peer => glob "~/.emacs-evaluator");

if (@ARGV) {
  print $emac reduce {$a . $b} @ARGV;
} else {
  print $emac $_ while <>;
}

close $emac
