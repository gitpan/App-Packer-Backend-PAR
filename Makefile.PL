#!/usr/bin/perl -w

use strict;
use ExtUtils::MakeMaker;

WriteMakefile( NAME          => 'App::Packer::Backend::PAR',
               ABSTRACT_FROM => 'PAR.pm',
               VERSION_FROM  => 'PAR.pm',
               AUTHOR        => 'Mattia Barbon <mbarbon@dsi.unive.it>',
               PREREQ_PM     => { 'File::Temp'   => 0.01,
                                  'Archive::Zip' => 1.00,
                                  'PAR'          => 0.41,
                                  'App::Packer'  => 0.07,
                                },
             );

# local variables:
# mode: cperl
# end;
