#!/usr/bin/env perl
use 5.16.1;
use warnings;

use Devel::Dwarn;
use List::Util 'max';
my $MAX = 10;
my @a = ('a'..'i');
sub ringu {
   @a = (@_,
      (@a + @_ <= $MAX
         ? @a
         : @a[0 .. (max(scalar @a, $MAX) - (@_ + 1)) ]
      ));
   Dwarn { scalar @a, \@a }
}

ringu('a', 'b');
