#!/usr/bin/env perl

use strict;
use warnings;

use threads;
use threads::shared;
use Thread::Semaphore;

require Test::More;
Test::More->import();
plan('tests' => 10);

# Decrement a semaphore's count with timeout
# ->down_timed(timeout)
# ->down_timed(timeout, number)
# Returns true if semaphore acquired; false if timed out
sub Thread::Semaphore::down_timed {
    my $sema = shift;
    my $timeout = shift;
    my $dec = @_ ? shift : 1;

    lock($$sema);
    my $abs = time() + $timeout;
    until ($$sema >= $dec) {
        return if !cond_timedwait($$sema, $abs);
    }
    $$sema -= $dec;
    return 1;
}

### Test ###

my $sm = Thread::Semaphore->new();
my $st = Thread::Semaphore->new(0);
ok($sm, 'New Semaphore');
ok($st, 'New Semaphore');

my $token :shared = 0;

threads->create(sub {
    $st->down_timed(3);
    is($token++, 1, 'Thread 1 got semaphore');
    $st->up();
    $sm->up();

    if ($st->down_timed(3, 4)) {
        is($token, 5, 'Thread 1 done');
    } else {
        ok($st, 'Thread 1 timed out');
    }
    $sm->up();
})->detach();

threads->create(sub {
    $st->down_timed(3, 2);
    is($token++, 3, 'Thread 2 got semaphore');
    $st->up();
    $sm->up();

    if ($st->down_timed(0, 4)) {
        is($token, 5, 'Thread 2 done');
    } else {
        ok($st, 'Thread 2 timed out');
    }
    $sm->up();
})->detach();

$sm->down();
is($token++, 0, 'Main has semaphore');
$st->up();

$sm->down();
is($token++, 2, 'Main got semaphore');
$st->up(2);

$sm->down();
is($token++, 4, 'Main re-got semaphore');
$st->up(5);

$sm->down(2);
$st->down();
ok(1, 'Main done');
threads::yield();

exit(0);

# EOF
