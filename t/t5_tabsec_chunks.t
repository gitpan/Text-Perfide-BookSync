#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Text::Perfide::BookSync;

my $fileL = 't/t5.fileL';
my $fileR = 't/t5.fileR';

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
	             file => "t/t5.fileL",
	             secs => [
	                       { end => 1150, id => "begin", start => 0, wc => 173 },
	                       { end => 11826, id => "PREF\xC1CIO_", start => 1151, wc => 1696 },
	                       { end => 52696, id => "1_", start => 11827, wc => 6759 },
	                       { end => 113135, id => "2_", start => 52697, wc => 10132 },
	                       { end => 148416, id => "4_", start => 113136, wc => 5785 },
	                       { end => 177937, id => "5_", start => 148417, wc => 4756 },
	                       { end => 211436, id => "6_", start => 177938, wc => 5488 },
	                       { end => 255347, id => "7_", start => 211437, wc => 7390 },
	                       { end => 288025, id => "8_", start => 255348, wc => 5524 },
	                       { end => 313946, id => "9_", start => 288026, wc => 4245 },
	                       { end => 348372, id => "10_", start => 313947, wc => 5749 },
	                       { end => 374042, id => "11_", start => 348373, wc => 4273 },
	                       { end => 418991, id => "12_", start => 374043, wc => 7500 },
	                       { end => 419004, id => "FIM_", start => 418992, wc => 1 },
	                     ],
	           },
	  right => {
	             file => "t/t5.fileR",
	             secs => [
	                       { end => 12596, id => "begin", start => 0, wc => 1995 },
	                       { end => 15037, id => "cap=1_", start => 12597, wc => 399 },
	                       { end => 21394, id => "2_", start => 15038, wc => 1046 },
	                       { end => 27349, id => "3_", start => 21395, wc => 1000 },
	                       { end => 33395, id => "4_", start => 27350, wc => 984 },
	                       { end => 37085, id => "5_", start => 33396, wc => 600 },
	                       { end => 38788, id => "6_", start => 37086, wc => 275 },
	                       { end => 39847, id => "7_", start => 38789, wc => 173 },
	                       { end => 50767, id => "8_", start => 39848, wc => 1857 },
	                       { end => 53783, id => "9_", start => 50768, wc => 496 },
	                       { end => 54716, id => "10_", start => 53784, wc => 161 },
	                       { end => 55435, id => "11_", start => 54717, wc => 127 },
	                       { end => 65001, id => "cap=2_", start => 55436, wc => 1602 },
	                       { end => 70876, id => "2_", start => 65002, wc => 990 },
	                       { end => 76264, id => "3_", start => 70877, wc => 909 },
	                       { end => 81467, id => "4_", start => 76265, wc => 876 },
	                       { end => 84852, id => "5_", start => 81468, wc => 573 },
	                       { end => 91021, id => "6_", start => 84853, wc => 1023 },
	                       { end => 95886, id => "7_", start => 91022, wc => 830 },
	                       { end => 108087, id => "cap=3_", start => 95887, wc => 2017 },
	                       { end => 110365, id => "2_", start => 108088, wc => 370 },
	                       { end => 111844, id => "3_", start => 110366, wc => 256 },
	                       { end => 114650, id => "4_", start => 111845, wc => 459 },
	                       { end => 115828, id => "5_", start => 114651, wc => 189 },
	                       { end => 117627, id => "6_", start => 115829, wc => 296 },
	                       { end => 119688, id => "7_", start => 117628, wc => 333 },
	                       { end => 125815, id => "8_", start => 119689, wc => 1014 },
	                       { end => 133660, id => "cap=4_", start => 125816, wc => 1287 },
	                       { end => 138146, id => "2_", start => 133661, wc => 733 },
	                       { end => 146070, id => "3_", start => 138147, wc => 1302 },
	                       { end => 149364, id => "4_", start => 146071, wc => 536 },
	                       { end => 157371, id => "5_", start => 149365, wc => 1246 },
	                       { end => 159536, id => "6_", start => 157372, wc => 354 },
	                       { end => 162981, id => "7_", start => 159537, wc => 564 },
	                       { end => 174729, id => "cap=5_", start => 162982, wc => 1929 },
	                       { end => 177098, id => "2_", start => 174730, wc => 386 },
	                       { end => 180192, id => "3_", start => 177099, wc => 503 },
	                       { end => 181442, id => "4_", start => 180193, wc => 194 },
	                       { end => 182591, id => "5_", start => 181443, wc => 187 },
	                       { end => 183135, id => "6_", start => 182592, wc => 91 },
	                       { end => 183673, id => "7_", start => 183136, wc => 89 },
	                       { end => 184285, id => "8_", start => 183674, wc => 104 },
	                       { end => 185621, id => "9_", start => 184286, wc => 214 },
	                       { end => 190372, id => "10_", start => 185622, wc => 782 },
	                       { end => 193738, id => "11_", start => 190373, wc => 567 },
	                       { end => 199655, id => "cap=6_", start => 193739, wc => 966 },
	                       { end => 201169, id => "2_", start => 199656, wc => 255 },
	                       { end => 205667, id => "3_", start => 201170, wc => 726 },
	                       { end => 209765, id => "4_", start => 205668, wc => 663 },
	                       { end => 215529, id => "5_", start => 209766, wc => 974 },
	                       { end => 217415, id => "6_", start => 215530, wc => 316 },
	                       { end => 220864, id => "7_", start => 217416, wc => 601 },
	                       { end => 224112, id => "8_", start => 220865, wc => 544 },
	                       { end => 227881, id => "9_", start => 224113, wc => 640 },
	                       { end => 234879, id => "cap=7_", start => 227882, wc => 1195 },
	                       { end => 244697, id => "2_", start => 234880, wc => 1659 },
	                       { end => 248545, id => "3_", start => 244698, wc => 616 },
	                       { end => 255506, id => "4_", start => 248546, wc => 1164 },
	                       { end => 261220, id => "5_", start => 255507, wc => 948 },
	                       { end => 264865, id => "6_", start => 261221, wc => 613 },
	                       { end => 272090, id => "7_", start => 264866, wc => 1222 },
	                       { end => 273135, id => "cap=8_", start => 272091, wc => 182 },
	                       { end => 282259, id => "2_", start => 273136, wc => 1555 },
	                       { end => 288870, id => "3_", start => 282260, wc => 1117 },
	                       { end => 294813, id => "4_", start => 288871, wc => 991 },
	                       { end => 299704, id => "5_", start => 294814, wc => 804 },
	                       { end => 301849, id => "6_", start => 299705, wc => 346 },
	                       { end => 304114, id => "7_", start => 301850, wc => 349 },
	                       { end => 313001, id => "cap=9_", start => 304115, wc => 1463 },
	                       { end => 313719, id => "2_", start => 313002, wc => 125 },
	                       { end => 318657, id => "3_", start => 313720, wc => 829 },
	                       { end => 330255, id => "4_", start => 318658, wc => 1972 },
	                       { end => 330833, id => "5_", start => 330256, wc => 96 },
	                       { end => 341099, id => "cap=10_", start => 330834, wc => 1700 },
	                       { end => 343250, id => "2_", start => 341100, wc => 356 },
	                       { end => 350337, id => "3_", start => 343251, wc => 1158 },
	                       { end => 353012, id => "4_", start => 350338, wc => 441 },
	                       { end => 356953, id => "5_", start => 353013, wc => 657 },
	                       { end => 358776, id => "6_", start => 356954, wc => 301 },
	                       { end => 360149, id => "7_", start => 358777, wc => 233 },
	                       { end => 365508, id => "8_", start => 360150, wc => 890 },
	                       { end => 375178, id => "cap=11_", start => 365509, wc => 1618 },
	                       { end => 378498, id => "2_", start => 375179, wc => 519 },
	                       { end => 380539, id => "3_", start => 378499, wc => 320 },
	                       { end => 383912, id => "4_", start => 380540, wc => 569 },
	                       { end => 385276, id => "5_", start => 383913, wc => 230 },
	                       { end => 386411, id => "6_", start => 385277, wc => 183 },
	                       { end => 387269, id => "7_", start => 386412, wc => 135 },
	                       { end => 391870, id => "8_", start => 387270, wc => 775 },
	                       { end => 392383, id => "9_", start => 391871, wc => 94 },
	                       { end => 413874, id => "cap=12_", start => 392384, wc => 3630 },
	                       { end => 419297, id => "2_", start => 413875, wc => 871 },
	                       { end => 423302, id => "3_", start => 419298, wc => 0 },
	                       { end => 429430, id => "4_", start => 423303, wc => 0 },
	                       { end => 440054, id => "5_", start => 429431, wc => 0 },
	                       { end => 441108, id => "6_", start => 440055, wc => 0 },
	                     ],
	           },
	};
}

sub chunks {
	return  [
	  {
	    left  => { end => 52697, secs => [0, 1, 2], start => 0, wc => 8628 },
	    right => { end => 15038, secs => [0, 1], start => 0, wc => 2394 },
	  },
	  {
	    left  => { end => 113136, secs => [3], start => 52697, wc => 10132 },
	    right => { end => 27350, secs => [2, 3], start => 15038, wc => 2046 },
	  },
	  {
	    left  => { end => 148417, secs => [4], start => 113136, wc => 5785 },
	    right => { end => 33396, secs => [4], start => 27350, wc => 984 },
	  },
	  {
	    left  => { end => 177938, secs => [5], start => 148417, wc => 4756 },
	    right => { end => 37086, secs => [5], start => 33396, wc => 600 },
	  },
	  {
	    left  => { end => 211437, secs => [6], start => 177938, wc => 5488 },
	    right => { end => 38789, secs => [6], start => 37086, wc => 275 },
	  },
	  {
	    left  => { end => 255348, secs => [7], start => 211437, wc => 7390 },
	    right => { end => 39848, secs => [7], start => 38789, wc => 173 },
	  },
	  {
	    left  => { end => 288026, secs => [8], start => 255348, wc => 5524 },
	    right => { end => 50768, secs => [8], start => 39848, wc => 1857 },
	  },
	  {
	    left  => { end => 313947, secs => [9], start => 288026, wc => 4245 },
	    right => { end => 53784, secs => [9], start => 50768, wc => 496 },
	  },
	  {
	    left  => { end => 348373, secs => [10], start => 313947, wc => 5749 },
	    right => { end => 54717, secs => [10], start => 53784, wc => 161 },
	  },
	  {
	    left  => { end => 419004, secs => [11, 12, 13], start => 348373, wc => 11774 },
	    right => { end => 441108, secs => [11 .. 95], start => 54717, wc => 60543 },
	  },
	];
}
