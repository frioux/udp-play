package Z::Role::DoesEvents;

use Module::Runtime 'use_module';
use Moo::Role;

has _loop => (
   is => 'ro',
   lazy => 1,
   builder => '_build_loop',
   handles => {
      add => '_add_to_loop',
   },
);

sub _build_loop { use_module('IO::Async::Loop')->new }

1;
