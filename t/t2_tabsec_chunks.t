#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Text::Perfide::BookSync;
use Data::Dumper;

my $fileL = 't/t2.fileL';
my $fileR = 't/t2.fileR';

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
	    left  => { end => 110, secs => [0], start => 0, wc => 16 },
	    right => { end => 96, secs => [0], start => 0, wc => 15 },
	  },
	  {
	    left  => { end => 27453, secs => [1], start => 110, wc => 4588 },
	    right => { end => 24368, secs => [1], start => 96, wc => 4053 },
	  },
	  {
	    left  => { end => 51233, secs => [2], start => 27453, wc => 3843 },
	    right => { end => 46093, secs => [2], start => 24368, wc => 3544 },
	  },
	  {
	    left  => { end => 75220, secs => [3], start => 51233, wc => 4018 },
	    right => { end => 67007, secs => [3], start => 46093, wc => 3497 },
	  },
	  {
	    left  => { end => 98501, secs => [4], start => 75220, wc => 3857 },
	    right => { end => 88039, secs => [4], start => 67007, wc => 3487 },
	  },
	  {
	    left  => { end => 133512, secs => [5], start => 98501, wc => 5749 },
	    right => { end => 118821, secs => [5], start => 88039, wc => 5035 },
	  },
	  {
	    left  => { end => 167722, secs => [6], start => 133512, wc => 5565 },
	    right => { end => 149529, secs => [6], start => 118821, wc => 5040 },
	  },
	  {
	    left  => { end => 196311, secs => [7], start => 167722, wc => 4816 },
	    right => { end => 175540, secs => [7], start => 149529, wc => 4283 },
	  },
	  {
	    left  => { end => 232559, secs => [8], start => 196311, wc => 6069 },
	    right => { end => 208320, secs => [8], start => 175540, wc => 5480 },
	  },
	  {
	    left  => { end => 250314, secs => [9], start => 232559, wc => 2979 },
	    right => { end => 224755, secs => [9], start => 208320, wc => 2790 },
	  },
	  {
	    left  => { end => 281090, secs => [10], start => 250314, wc => 5075 },
	    right => { end => 251935, secs => [10], start => 224755, wc => 4527 },
	  },
	  {
	    left  => { end => 302428, secs => [11], start => 281090, wc => 3554 },
	    right => { end => 271422, secs => [11], start => 251935, wc => 3237 },
	  },
	  {
	    left  => { end => 327759, secs => [12], start => 302428, wc => 4113 },
	    right => { end => 294119, secs => [12], start => 271422, wc => 3759 },
	  },
	  {
	    left  => { end => 360094, secs => [13], start => 327759, wc => 5360 },
	    right => { end => 323969, secs => [13], start => 294119, wc => 4879 },
	  },
	];
}

sub tabsec {
	return {
	  left  => {
	             file => "t/t2.fileL",
	             secs => [
	                       { end => 109, id => "begin", start => 0, wc => 16 },
	                       { end => 27452, id => "cap=1_", start => 110, wc => 4588 },
	                       { end => 51232, id => "cap=2_", start => 27453, wc => 3843 },
	                       { end => 75219, id => "cap=3_", start => 51233, wc => 4018 },
	                       { end => 98500, id => "cap=4_", start => 75220, wc => 3857 },
	                       { end => 133511, id => "cap=5_", start => 98501, wc => 5749 },
	                       { end => 167721, id => "cap=6_", start => 133512, wc => 5565 },
	                       { end => 196310, id => "cap=7_", start => 167722, wc => 4816 },
	                       { end => 232558, id => "cap=8_", start => 196311, wc => 6069 },
	                       { end => 250313, id => "cap=9_", start => 232559, wc => 2979 },
	                       { end => 281089, id => "cap=10_", start => 250314, wc => 5075 },
	                       { end => 302427, id => "cap=11_", start => 281090, wc => 3554 },
	                       { end => 327758, id => "cap=12_", start => 302428, wc => 4113 },
	                       { end => 360094, id => "cap=13_", start => 327759, wc => 5360 },
	                     ],
	           },
	  right => {
	             file => "t/t2.fileR",
	             secs => [
	                       { end => 95, id => "begin", start => 0, wc => 15 },
	                       { end => 24367, id => "cap=1_", start => 96, wc => 4053 },
	                       { end => 46092, id => "cap=2_", start => 24368, wc => 3544 },
	                       { end => 67006, id => "cap=3_", start => 46093, wc => 3497 },
	                       { end => 88038, id => "cap=4_", start => 67007, wc => 3487 },
	                       { end => 118820, id => "cap=5_", start => 88039, wc => 5035 },
	                       { end => 149528, id => "cap=6_", start => 118821, wc => 5040 },
	                       { end => 175539, id => "cap=7_", start => 149529, wc => 4283 },
	                       { end => 208319, id => "cap=8_", start => 175540, wc => 5480 },
	                       { end => 224754, id => "cap=9_", start => 208320, wc => 2790 },
	                       { end => 251934, id => "cap=10_", start => 224755, wc => 4527 },
	                       { end => 271421, id => "cap=11_", start => 251935, wc => 3237 },
	                       { end => 294118, id => "cap=12_", start => 271422, wc => 3759 },
	                       { end => 323969, id => "cap=13_", start => 294119, wc => 4879 },
	                     ],
	           },
	};
}
