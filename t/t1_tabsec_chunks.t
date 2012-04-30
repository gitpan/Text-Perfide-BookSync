#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Text::Perfide::BookSync;
use Data::Dumper;

my $fileL = 't/t1.fileL';
my $fileR = 't/t1.fileR';

my $expected_tabsec = tabsec();
my $got_tabsec 		= {  
		left  => {  file => $fileL,
        			secs => populate($fileL) },
        right => {  file => $fileR,
                    secs => populate($fileR) }
};  
map { delete($_->{title}) } @{$expected_tabsec->{left}{secs}};
map { delete($_->{title}) } @{$expected_tabsec->{right}{secs}};
map { delete($_->{title}) } @{$got_tabsec->{left}{secs}};
map { delete($_->{title}) } @{$got_tabsec->{right}{secs}};
moreinfosecs($got_tabsec);


my $expected_chunks = chunks();
my $got_chunks = calchunks($got_tabsec,$fileL,$fileR);
moreinfochunks($got_chunks,$got_tabsec);

is_deeply($got_tabsec, $expected_tabsec, "Comparing tabsecs" );
is_deeply($got_chunks, $expected_chunks, "Comparing chunks" );

sub chunks {
	return [
	  {
	    left  => { end => 1, secs => [0], start => 0, wc => 0 },
	    right => { end => 1, secs => [0], start => 0, wc => 0 },
	  },
	  {
	    left  => { end => 28, secs => [1], start => 1, wc => 3 },
	    right => { end => 26, secs => [1], start => 1, wc => 3 },
	  },
	  {
	    left  => { end => 57, secs => [2], start => 28, wc => 3 },
	    right => { end => 51, secs => [2], start => 26, wc => 3 },
	  },
	  {
	    left  => { end => 86, secs => [3], start => 57, wc => 3 },
	    right => { end => 76, secs => [3], start => 51, wc => 3 },
	  },
	  {
	    left  => { end => 117, secs => [4], start => 86, wc => 3 },
	    right => { end => 101, secs => [4], start => 76, wc => 3 },
	  },
	  {
	    left  => { end => 147, secs => [5], start => 117, wc => 3 },
	    right => { end => 126, secs => [5], start => 101, wc => 3 },
	  },
	  {
	    left  => { end => 176, secs => [6], start => 147, wc => 3 },
	    right => { end => 151, secs => [6], start => 126, wc => 4 },
	  },
	  {
	    left  => { end => 205, secs => [7], start => 176, wc => 3 },
	    right => { end => 176, secs => [7], start => 151, wc => 3 },
	  },
	  {
	    left  => { end => 234, secs => [8], start => 205, wc => 3 },
	    right => { end => 201, secs => [8], start => 176, wc => 3 },
	  },
	  {
	    left  => { end => 263, secs => [9], start => 234, wc => 3 },
	    right => { end => 226, secs => [9], start => 201, wc => 3 },
	  },
	  {
	    left  => { end => 292, secs => [10], start => 263, wc => 3 },
	    right => { end => 253, secs => [10], start => 226, wc => 4 },
	  },
	  {
	    left  => { end => 322, secs => [11], start => 292, wc => 3 },
	    right => { end => 280, secs => [11], start => 253, wc => 4 },
	  },
	  {
	    left  => { end => 352, secs => [12], start => 322, wc => 3 },
	    right => { end => 307, secs => [12], start => 280, wc => 3 },
	  },
	  {
	    left  => { end => 382, secs => [13], start => 352, wc => 3 },
	    right => { end => 333, secs => [13], start => 307, wc => 3 },
	  },
	]; 
}


sub tabsec {
	return {
	  left  => {
	             file => "t/t1.fileL",
	             secs => [
	                       { end => 0, id => "begin", start => 0, wc => 0 },
	                       { end => 27, id => "cap=1_", start => 1, wc => 3 },
	                       { end => 56, id => "cap=2_", start => 28, wc => 3 },
	                       { end => 85, id => "cap=3_", start => 57, wc => 3 },
	                       { end => 116, id => "cap=4_", start => 86, wc => 3 },
	                       { end => 146, id => "cap=5_", start => 117, wc => 3 },
	                       { end => 175, id => "cap=6_", start => 147, wc => 3 },
	                       { end => 204, id => "cap=7_", start => 176, wc => 3 },
	                       { end => 233, id => "cap=8_", start => 205, wc => 3 },
	                       { end => 262, id => "cap=9_", start => 234, wc => 3 },
	                       { end => 291, id => "cap=10_", start => 263, wc => 3 },
	                       { end => 321, id => "cap=11_", start => 292, wc => 3 },
	                       { end => 351, id => "cap=12_", start => 322, wc => 3 },
	                       { end => 382, id => "cap=13_", start => 352, wc => 3 },
	                     ],
	           },
	  right => {
	             file => "t/t1.fileR",
	             secs => [
	                       { end => 0, id => "begin", start => 0, wc => 0 },
	                       { end => 25, id => "cap=1_", start => 1, wc => 3 },
	                       { end => 50, id => "cap=2_", start => 26, wc => 3 },
	                       { end => 75, id => "cap=3_", start => 51, wc => 3 },
	                       { end => 100, id => "cap=4_", start => 76, wc => 3 },
	                       { end => 125, id => "cap=5_", start => 101, wc => 3 },
	                       { end => 150, id => "cap=6_", start => 126, wc => 4 },
	                       { end => 175, id => "cap=7_", start => 151, wc => 3 },
	                       { end => 200, id => "cap=8_", start => 176, wc => 3 },
	                       { end => 225, id => "cap=9_", start => 201, wc => 3 },
	                       { end => 252, id => "cap=10_", start => 226, wc => 4 },
	                       { end => 279, id => "cap=11_", start => 253, wc => 4 },
	                       { end => 306, id => "cap=12_", start => 280, wc => 3 },
	                       { end => 333, id => "cap=13_", start => 307, wc => 3 },
	                     ],
	           },
	}; 
}


__END__
t1.fileL:

_sec+O:cap=1_ CAPÍTULO UM
_sec+O:cap=2_ CAPÍTULO DOIS
_sec+O:cap=3_ CAPÍTULO TRÊS
_sec+O:cap=4_ CAPÍTULO QUATRO
_sec+O:cap=5_ CAPÍTULO CINCO
_sec+O:cap=6_ CAPÍTULO SEIS
_sec+O:cap=7_ CAPÍTULO SETE
_sec+O:cap=8_ CAPÍTULO OITO
_sec+O:cap=9_ CAPÍTULO NOVE
_sec+O:cap=10_ CAPÍTULO DEZ
_sec+O:cap=11_ CAPÍTULO ONZE
_sec+O:cap=12_ CAPÍTULO DOZE
_sec+O:cap=13_ CAPÍTULO TREZE

t1.fileR:

_sec+N:cap=1_ Chapter 1
_sec+N:cap=2_ Chapter 2
_sec+N:cap=3_ Chapter 3
_sec+N:cap=4_ Chapter 4
_sec+N:cap=5_ Chapter 5
_sec+N:cap=6_ Chapter 6
_sec+N:cap=7_ Chapter 7
_sec+N:cap=8_ Chapter 8
_sec+N:cap=9_ Chapter 9
_sec+N:cap=10_ Chapter 10
_sec+N:cap=11_ Chapter 11
_sec+N:cap=12_ Chapter 12
_sec+N:cap=13_ Chapter 13
