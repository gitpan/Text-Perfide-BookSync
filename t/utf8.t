#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Text::Perfide::BookSync;

my $fileL = 't/utf8_1.bc_out';
my $fileR = 't/utf8_2.bc_out';

my $expected_tabsec = tabsec();
my $got_tabsec 		= {  
		left  => {  file => $fileL,
        			secs => populate($fileL) },
        right => {  file => $fileR,
                    secs => populate($fileR) }
};  
moreinfosecs($got_tabsec);

my $expected_chunks = chunks();
my $got_chunks = calchunks($got_tabsec,$fileL,$fileR);
moreinfochunks($got_chunks,$got_tabsec);

is_deeply($got_tabsec, $expected_tabsec, "Comparing tabsecs" );
is_deeply($got_chunks, $expected_chunks, "Comparing chunks" );

sub chunks {
	return [
	  {
	    left  => { end => 17, secs => [0], start => 0, wc => 3 },
	    right => { end => 17, secs => [0], start => 0, wc => 3 },
	  },
	  {
	    left  => { end => 53, secs => [1], start => 17, wc => 3 },
	    right => { end => 53, secs => [1], start => 17, wc => 3 },
	  },
	];
}


sub tabsec {
	return {
	  left  => {
	             file => "t/utf8_1.bc_out",
	             secs => [
	                       { end => 16, id => "begin", start => 0, title => "begin", wc => 3 },
	                       {
	                         end => 53,
	                         id => "cap=1_",
	                         start => 17,
	                         title => "_sec+N:cap=1_\n\nc\xE2r\xE1t\x{1EBD}r\xE8s ac\x{1EBD}nt\xFA\xE0d\xF4s",
	                         wc => 3,
	                       },
	                     ],
	           },
	  right => {
	             file => "t/utf8_2.bc_out",
	             secs => [
	                       { end => 16, id => "begin", start => 0, title => "begin", wc => 3 },
	                       {
	                         end => 53,
	                         id => "cap=1_",
	                         start => 17,
	                         title => "_sec+N:cap=1_\n\nc\xE2r\xE1t\x{1EBD}r\xE8s ac\x{1EBD}nt\xFA\xE0d\xF4s",
	                         wc => 3,
	                       },
	                     ],
	           },
	};
}

