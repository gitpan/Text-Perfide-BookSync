#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Text::Perfide::BookSync;

my $fileL = 't/t3.fileL';
my $fileR = 't/t3.fileR';

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

sub tabsec {
	return {
	  left  => {
	             file => "t/t3.fileL",
	             secs => [
	                       { end => 496, id => "begin", start => 0, wc => 76 },
	                       { end => 41221, id => "1_", start => 497, wc => 6874 },
	                       { end => 76586, id => "4_", start => 41222, wc => 5905 },
	                       { end => 96257, id => "6_", start => 76587, wc => 3332 },
	                       { end => 111162, id => "7_", start => 96258, wc => 2530 },
	                       { end => 123462, id => "8_", start => 111163, wc => 2023 },
	                       { end => 155331, id => "9_", start => 123463, wc => 5418 },
	                       { end => 169529, id => "parte_", start => 155332, wc => 2431 },
	                       { end => 183804, id => "11_", start => 169530, wc => 2380 },
	                       { end => 194130, id => "12_", start => 183805, wc => 1780 },
	                       { end => 211348, id => "13_", start => 194131, wc => 2920 },
	                       { end => 234571, id => "14_", start => 211349, wc => 3923 },
	                       { end => 251008, id => "15_", start => 234572, wc => 2733 },
	                       { end => 272842, id => "16_", start => 251009, wc => 3812 },
	                       { end => 284221, id => "17_", start => 272843, wc => 1946 },
	                       { end => 290003, id => "18_", start => 284222, wc => 984 },
	                       { end => 296633, id => "19_", start => 290004, wc => 1080 },
	                       { end => 303224, id => "20_", start => 296634, wc => 1116 },
	                       { end => 315087, id => "21_", start => 303225, wc => 1988 },
	                       { end => 317737, id => "22_", start => 315088, wc => 446 },
	                       { end => 321339, id => "23_", start => 317738, wc => 619 },
	                       { end => 321352, id => "FIM_", start => 321340, wc => 1 },
	                     ],
	           },
	  right => {
	             file => "t/t3.fileR",
	             secs => [
	                       { end => 46, id => "begin", start => 0, wc => 8 },
	                       { end => 9534, id => "cap=1_", start => 47, wc => 1581 },
	                       { end => 24247, id => "cap=2_", start => 9535, wc => 2477 },
	                       { end => 40541, id => "cap=3_", start => 24248, wc => 2771 },
	                       { end => 55648, id => "cap=4_", start => 40542, wc => 2529 },
	                       { end => 75326, id => "cap=5_", start => 55649, wc => 3283 },
	                       { end => 93823, id => "cap=6_", start => 75327, wc => 3121 },
	                       { end => 108595, id => "cap=7_", start => 93824, wc => 2510 },
	                       { end => 120333, id => "cap=8_", start => 108596, wc => 1951 },
	                       { end => 143401, id => "cap=9_", start => 120334, wc => 3900 },
	                       { end => 165853, id => "cap=10_", start => 143402, wc => 3823 },
	                       { end => 180239, id => "cap=11_", start => 165854, wc => 2454 },
	                       { end => 183999, id => "cap=12_", start => 180240, wc => 602 },
	                       { end => 186782, id => "2_", start => 184000, wc => 481 },
	                       { end => 191501, id => "3_", start => 186783, wc => 802 },
	                       { end => 210227, id => "cap=13_", start => 191502, wc => 3198 },
	                       { end => 216370, id => "cap=14_", start => 210228, wc => 1031 },
	                       { end => 235739, id => "2_", start => 216371, wc => 3273 },
	                       { end => 251289, id => "cap=15_", start => 235740, wc => 2591 },
	                       { end => 255314, id => "cap=16_", start => 251290, wc => 681 },
	                       { end => 257463, id => "2_", start => 255315, wc => 382 },
	                       { end => 262469, id => "3_", start => 257464, wc => 875 },
	                       { end => 267172, id => "4_", start => 262470, wc => 832 },
	                       { end => 272412, id => "5_", start => 267173, wc => 926 },
	                       { end => 273980, id => "6_", start => 272413, wc => 269 },
	                       { end => 278487, id => "cap=17_", start => 273981, wc => 779 },
	                       { end => 280675, id => "2_", start => 278488, wc => 366 },
	                       { end => 285608, id => "3_", start => 280676, wc => 823 },
	                       { end => 291662, id => "cap=18_", start => 285609, wc => 1036 },
	                       { end => 292826, id => "cap=19_", start => 291663, wc => 194 },
	                       { end => 297958, id => "2_", start => 292827, wc => 827 },
	                       { end => 304526, id => "cap=20_", start => 297959, wc => 1130 },
	                       { end => 316399, id => "cap=21_", start => 304527, wc => 1989 },
	                       { end => 319019, id => "cap=22_", start => 316400, wc => 433 },
	                       { end => 321983, id => "cap=23_", start => 319020, wc => 413 },
	                       { end => 322714, id => "2_", start => 321984, wc => 0 },
	                     ],
	           },
	};              
}

sub chunks {
	return [
	  {
	    left  => { end => 41222, secs => [0, 1], start => 0, wc => 6950 },
	    right => { end => 262470, secs => [0 .. 21], start => 0, wc => 44324 },
	  },
	  {
	    left  => { end => 76587, secs => [2], start => 41222, wc => 5905 },
	    right => { end => 272413, secs => [22, 23], start => 262470, wc => 1758 },
	  },
	  {
	    left  => { end => 321352, secs => [3 .. 21], start => 76587, wc => 41462 },
	    right => { end => 322714, secs => [24 .. 35], start => 272413, wc => 8259 },
	  },
	]; 
}
