use strict;
use warnings;

use Test::More;
use Config;
if ($Config{'useithreads'}) {
    plan 'tests' => 1;
} else {
    plan 'skip_all' => q/Perl not compiled with 'useithreads'/;
}

use_ok('Thread::Semaphore');
if ($Thread::Semaphore::VERSION) {
    diag('Testing Thread::Semaphore ' . $Thread::Semaphore::VERSION);
}

# EOF
