#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Text::Perfide::BookSync;

my $fileL = 't/t4.fileL';
my $fileR = 't/t4.fileR';

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
map { delete($_->{title}) } @{$expected_tabsec->{left}{secs}};
map { delete($_->{title}) } @{$expected_tabsec->{right}{secs}};
map { delete($_->{title}) } @{$got_tabsec->{left}{secs}};
map { delete($_->{title}) } @{$got_tabsec->{right}{secs}};
moreinfochunks($got_chunks,$got_tabsec);

is_deeply($got_tabsec, $expected_tabsec, "Comparing tabsecs" );
is_deeply($got_chunks, $expected_chunks, "Comparing chunks" );

sub tabsec {
	return {
	  left  => {
	             file => "t/t4.fileL",
	             secs => [
	                       { end => 343, id => "begin", start => 0, wc => 52 },
	                       { end => 4562, id => "PR\xD3LOGO_", start => 344, wc => 669 },
	                       { end => 4593, id => "part=1_", start => 4563, wc => 3 },
	                       { end => 15920, id => "1_", start => 4594, wc => 2014 },
	                       { end => 21177, id => "2_", start => 15921, wc => 931 },
	                       { end => 27560, id => "3_", start => 21178, wc => 1136 },
	                       { end => 37144, id => "cap=2_", start => 27561, wc => 1689 },
	                       { end => 48860, id => "3_", start => 37145, wc => 2016 },
	                       { end => 50796, id => "6_", start => 48861, wc => 343 },
	                       { end => 52877, id => "1_", start => 50797, wc => 337 },
	                       { end => 62210, id => "3_", start => 52878, wc => 1580 },
	                       { end => 66149, id => "cap=4_", start => 62211, wc => 693 },
	                       { end => 66907, id => "3_", start => 66150, wc => 118 },
	                       { end => 73836, id => "4_", start => 66908, wc => 1221 },
	                       { end => 80681, id => "cap=5_", start => 73837, wc => 1199 },
	                       { end => 84742, id => "3_", start => 80682, wc => 711 },
	                       { end => 92162, id => "4_", start => 84743, wc => 1335 },
	                       { end => 93084, id => "6_", start => 92163, wc => 153 },
	                       { end => 102920, id => "cap=6_", start => 93085, wc => 1731 },
	                       { end => 102950, id => "cap=7_", start => 102921, wc => 3 },
	                       { end => 112405, id => "1_", start => 102951, wc => 1616 },
	                       { end => 123319, id => "3_", start => 112406, wc => 1926 },
	                       { end => 127304, id => "4_", start => 123320, wc => 688 },
	                       { end => 127334, id => "part=2_", start => 127305, wc => 3 },
	                       { end => 143274, id => "cap=1_", start => 127335, wc => 2789 },
	                       { end => 151893, id => "cap=2_", start => 143275, wc => 1495 },
	                       { end => 161996, id => "cap=3_", start => 151894, wc => 1781 },
	                       { end => 173132, id => "cap=4_", start => 161997, wc => 1936 },
	                       { end => 180651, id => "cap=5_", start => 173133, wc => 1309 },
	                       { end => 196010, id => "cap=6_", start => 180652, wc => 2640 },
	                       { end => 199287, id => "cap=7_", start => 196011, wc => 554 },
	                       { end => 201075, id => "cap=8_", start => 199288, wc => 302 },
	                       { end => 207477, id => "cap=9_", start => 201076, wc => 1134 },
	                       { end => 214325, id => "cap=10_", start => 207478, wc => 1252 },
	                       { end => 223124, id => "cap=11_", start => 214326, wc => 1565 },
	                       { end => 238818, id => "Cap\xEDtulo_", start => 223125, wc => 2760 },
	                       { end => 247436, id => "Cap\xEDtulo_", start => 238819, wc => 1560 },
	                       { end => 247467, id => "part=3_", start => 247437, wc => 3 },
	                       { end => 257080, id => "cap=1_", start => 247468, wc => 1643 },
	                       { end => 264508, id => "cap=2_", start => 257081, wc => 1335 },
	                       { end => 266938, id => "2_", start => 264509, wc => 438 },
	                       { end => 276050, id => "3_", start => 266939, wc => 1560 },
	                       { end => 277717, id => "3_", start => 276051, wc => 258 },
	                       { end => 281516, id => "4_", start => 277718, wc => 681 },
	                       { end => 283735, id => "6_", start => 281517, wc => 375 },
	                       { end => 285205, id => "7_", start => 283736, wc => 262 },
	                       { end => 285753, id => "8_", start => 285206, wc => 92 },
	                       { end => 286197, id => "9_", start => 285754, wc => 74 },
	                       { end => 286228, id => "cap=4_", start => 286198, wc => 3 },
	                       { end => 291351, id => "1_", start => 286229, wc => 846 },
	                       { end => 291599, id => "3_", start => 291352, wc => 44 },
	                       { end => 295789, id => "cap=5_", start => 291600, wc => 736 },
	                       { end => 309928, id => "cap=6_", start => 295790, wc => 2419 },
	                     ],
	           },
	  right => {
	             file => "t/t4.fileR",
	             secs => [
	                       { end => 300, id => "begin", start => 0, wc => 46 },
	                       { end => 4367, id => "Prologue_", start => 301, wc => 646 },
	                       { end => 27492, id => "cap=1_", start => 4368, wc => 4105 },
	                       { end => 50773, id => "cap=2_", start => 27493, wc => 4054 },
	                       { end => 61885, id => "cap=3_", start => 50774, wc => 1868 },
	                       { end => 73693, id => "cap=4_", start => 61886, wc => 2062 },
	                       { end => 93507, id => "cap=5_", start => 73694, wc => 3491 },
	                       { end => 102745, id => "cap=6_", start => 93508, wc => 1636 },
	                       { end => 126994, id => "cap=7_", start => 102746, wc => 4211 },
	                       { end => 142961, id => "cap=8_", start => 126995, wc => 2787 },
	                       { end => 151840, id => "cap=9_", start => 142962, wc => 1543 },
	                       { end => 161593, id => "cap=10_", start => 151841, wc => 1718 },
	                       { end => 172281, id => "cap=11_", start => 161594, wc => 1863 },
	                       { end => 179907, id => "cap=12_", start => 172282, wc => 1326 },
	                       { end => 195632, id => "cap=13_", start => 179908, wc => 2705 },
	                       { end => 198925, id => "cap=14_", start => 195633, wc => 556 },
	                       { end => 200579, id => "cap=15_", start => 198926, wc => 282 },
	                       { end => 207264, id => "cap=16_", start => 200580, wc => 1184 },
	                       { end => 214360, id => "cap=17_", start => 207265, wc => 1292 },
	                       { end => 223469, id => "cap=18_", start => 214361, wc => 1615 },
	                       { end => 239427, id => "cap=19_", start => 223470, wc => 2806 },
	                       { end => 248339, id => "cap=20_", start => 239428, wc => 1610 },
	                       { end => 257715, id => "cap=21_", start => 248340, wc => 1612 },
	                       { end => 267600, id => "cap=22_", start => 257716, wc => 1760 },
	                       { end => 286678, id => "cap=23_", start => 267601, wc => 3274 },
	                       { end => 292346, id => "cap=24_", start => 286679, wc => 945 },
	                       { end => 296685, id => "cap=25_", start => 292347, wc => 774 },
	                       { end => 311003, id => "cap=26_", start => 296686, wc => 2260 },
	                     ],
	           },
	};
}

sub chunks {
	return	[
	  {
	    left  => { end => 127335, secs => [0 .. 23], start => 0, wc => 22167 },
	    right => { end => 4368, secs => [0, 1], start => 0, wc => 692 },
	  },
	  {
	    left  => { end => 143275, secs => [24], start => 127335, wc => 2789 },
	    right => { end => 27493, secs => [2], start => 4368, wc => 4105 },
	  },
	  {
	    left  => { end => 151894, secs => [25], start => 143275, wc => 1495 },
	    right => { end => 50774, secs => [3], start => 27493, wc => 4054 },
	  },
	  {
	    left  => { end => 161997, secs => [26], start => 151894, wc => 1781 },
	    right => { end => 61886, secs => [4], start => 50774, wc => 1868 },
	  },
	  {
	    left  => { end => 173133, secs => [27], start => 161997, wc => 1936 },
	    right => { end => 73694, secs => [5], start => 61886, wc => 2062 },
	  },
	  {
	    left  => { end => 180652, secs => [28], start => 173133, wc => 1309 },
	    right => { end => 93508, secs => [6], start => 73694, wc => 3491 },
	  },
	  {
	    left  => { end => 196011, secs => [29], start => 180652, wc => 2640 },
	    right => { end => 102746, secs => [7], start => 93508, wc => 1636 },
	  },
	  {
	    left  => { end => 199288, secs => [30], start => 196011, wc => 554 },
	    right => { end => 126995, secs => [8], start => 102746, wc => 4211 },
	  },
	  {
	    left  => { end => 201076, secs => [31], start => 199288, wc => 302 },
	    right => { end => 142962, secs => [9], start => 126995, wc => 2787 },
	  },
	  {
	    left  => { end => 207478, secs => [32], start => 201076, wc => 1134 },
	    right => { end => 151841, secs => [10], start => 142962, wc => 1543 },
	  },
	  {
	    left  => { end => 214326, secs => [33], start => 207478, wc => 1252 },
	    right => { end => 161594, secs => [11], start => 151841, wc => 1718 },
	  },
	  {
	    left  => { end => 309928, secs => [34 .. 52], start => 214326, wc => 16654 },
	    right => { end => 311003, secs => [12 .. 27], start => 161594, wc => 25864 },
	  },
	];
}
