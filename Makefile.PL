# Module makefile for Thread::Semaphore (using ExtUtils::MakeMaker)

use Config;
BEGIN {
    if (! $Config{'useithreads'} || ($] < 5.008)) {
        die("ERROR:  This Perl not built to support threads\n");
    }
}

use ExtUtils::MakeMaker;

# Construct make file
WriteMakefile(
    'NAME'          => 'Thread::Semaphore',
    'AUTHOR'        => 'Jerry D. Hedden <jdhedden AT cpan DOT org>',
    'VERSION_FROM'  => 'lib/Thread/Semaphore.pm',
    'ABSTRACT_FROM' => 'lib/Thread/Semaphore.pm',
    'PREREQ_PM'     => {
        'threads'         => 0,
        'threads::shared' => 0,
        'Scalar::Util'    => 1.10,
        'Test::More'      => 0.50,
    },
    'INSTALLDIRS'   => 'perl',

    ((ExtUtils::MakeMaker->VERSION() lt '6.25') ?
        ('PL_FILES' => { })            : ()),
    ((ExtUtils::MakeMaker->VERSION() gt '6.30') ?
        ('LICENSE'  => 'perl')         : ()),
);

# EOF
