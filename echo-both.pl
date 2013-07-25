use strict;
use warnings;
use 5.16.1;

use Socket;
use IO::Async::Socket;
use IO::Async::Loop;
use IO::Async::Connector;

my $loop = IO::Async::Loop->new;

my $s = IO::Socket::INET->new(
   Proto => 'udp',
   ReuseAddr => 1,
   Type => SOCK_DGRAM,
   LocalPort => 8001,
) or die "No bind: $@\n";

my $sock = IO::Async::Socket->new(
   handle => $s,
   on_recv => sub {
      my ( $self, $dgram, $addr ) = @_;

      say "Received reply: $dgram";
      $self->send($dgram, $addr);
   },
   on_recv_error => sub {
      my ( $self, $errno ) = @_;
      die "Cannot recv - $errno\n";
   },
);
$loop->add($sock);
$loop->connect(
   host => 'localhost',
   service => 8001,
   socktype => 'dgram',
   on_socket => sub {
      my $sock = shift;
      say "->connect done ($sock)";
      $sock->configure(
         on_recv => sub {
            my ( $self, $dgram, $addr ) = @_;

            say "Client sees reply: $dgram";
         },
         on_recv_error => sub {
            my ( $self, $errno ) = @_;
            die "Cannot recv - $errno\n";
         },
      );
      $loop->add($sock);
      $sock->send("test message");
   },
   on_connect_error => sub { die "@_" },
   on_resolve_error => sub { die "@_" },
);
$loop->run;
