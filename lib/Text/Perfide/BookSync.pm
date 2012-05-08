package Text::Perfide::BookSync;

use 5.006;
use strict;
use warnings;
use Data::Dumper;
use List::Util qw/min/;
use HTML::Auto qw/matrix h v/;
use File::Basename;
use utf8::all;
use feature qw/say/;


=head1 NAME

Text::Perfide::BookSync - Synchronize books in plain text format.

=head1 VERSION

Version 0.01_05

=cut

use base 'Exporter';
our @EXPORT = (qw/	htmlmatrix
					marksync
					splitchunks
					calchunks
					populate
					moreinfosecs
					moreinfochunks
				/);

our $VERSION = '0.01_05';

=head1 SYNOPSIS

Text::Perfide::BookSync performs a structural alignment at section level of books in plain text format.
The books have to be previously annotated by Text::Perfide::BookCleaner.

=head1 EXPORT

=head1 SUBROUTINES/METHODS
=cut

our($split,$mark,$noclean,$html,$rm,$num,$pfile,$dump);
$rm //= 0;

=head2 htmlmatrix

Generates an HTML file containing a matrix showing the matches between sections of two books.

=cut

sub htmlmatrix{
	my ($chunks,$tabsec,$options) = @_;
	my (@lines,@cols);
	my ($l,$c)=(0,0);
	my $h = scalar  @{$tabsec->{left}{secs}};
	my $w = scalar  @{$tabsec->{right}{secs}};

	my $data = [ map { [(undef)x$w] } (undef)x$h ];
	my $more_info = { left => [], right => [] };

	my $ccount = 0;
	for my $chun (@$chunks){
		my $ls = scalar @{$chun->{left}{secs}};
		my $rs = scalar @{$chun->{right}{secs}};
		for(my $i=0; $i<$ls; $i++){
			push @lines, $tabsec->{left}{secs}[$l+$i]{id};
			push @{$more_info->{left}},$tabsec->{left}{secs}[$l+$i]{title};
		}
		for(my $j=0; $j<$rs; $j++){
			push @cols, $tabsec->{right}{secs}[$c+$j]{id};
			push @{$more_info->{right}},$tabsec->{right}{secs}[$c+$j]{title};
		}
		my $style;
		my $wcmp = _numcmp($chun->{left}{wc},$chun->{right}{wc});
		if ($wcmp < 1.1 && $wcmp > 0.9){              						$style = 'background: green';		}
		elsif ($wcmp > 1.1 && $wcmp < 1.5 or $wcmp < 0.9 && $wcmp > 0.5){	$style = 'background: yellow'; 		}
		else															{	$style = 'background: red'; 		}

		for(my $i=0; $i<$ls; $i++){
			for(my $j=0; $j<$rs; $j++){
				my $more_info = '<span>
									<table class="more_info">
									<tr>
										<th class="more_info">'.$lines[$l+$i].'</th>
										<td class="large">'.$more_info->{left}[$l+$i].'</td>
									</tr>
									<tr>
										<th class="more_info">'.$cols[$c+$j].'</th>
										<td class="large">'.$more_info->{right}[$c+$j].'</td>
									</tr>
									</table>
								</span>';

				$data->[$l+$i][$c+$j] = { 
					v => "$ccount $more_info", 
					a => { 
						style => $style, 
						class => 'more_info'} 
				};
			}
		}
		$l+=$ls;
		$c+=$rs;
		$ccount++;
	}	
	my ($fileL,$fileR) = (basename($tabsec->{left}{file}),basename($tabsec->{right}{file}));

	my $dir = $options->{dir};
	if(defined($dir))	{ $dir.= "/"; }
	else				{ $dir = "";  }

	open my $html,'>',"$dir$fileL"."_$fileR.html" or die "Could not open file '$dir${fileL}_$fileR.html' for writing!";
	my $m = matrix(\@cols,\@lines,$data);
	print $html v(h($m));
}

=head2 marksync

Given two files FILEL and FILER, creates new versions of these files (FILEL.sync and FILER.sync) with synchronization tags <sync id="x"> marking the points where the texts synchronize.

=cut

sub marksync{
	my ($chunks,$tabsec,$fileL,$fileR,$options) = @_;
	my ($dirL,$dirR);
	my $dir = $options->{dir};
	my ($fL,$fR);
	if(defined($dir)){
		$fL = "$dir/".basename($fileL);
		$fR = "$dir/".basename($fileR);
	}
	else {
		$fL = $fileL;
		$fR = $fileR;
	}

	open my $syncl,'>',"$fL.sync" or die "Could not open file '$fileL.sync'";
	open my $syncr,'>',"$fR.sync" or die "Could not open file '$fileR.sync'";

	push @{$options->{outlist}},"$fL.sync\t$fR.sync" if defined($options->{outfile});

	# Print first section mark
	my $rm = $options->{rm} // 0;
	print $syncl qq/<sync id="0">\n/ unless $rm>0;
	print $syncr qq/<sync id="0">\n/ unless $rm>0;


	open my $fhL, '<', $fL or die;
	open my $fhR, '<', $fR or die;
	my $t;

	# For each chunk 
	for(my $i=$rm; $i < @$chunks; $i++){

		my ($ltext,$rtext);

		# Get the chunk's start offset and end offset (LEFT)
		my $l_start  = $chunks->[$i]{left}{start};
		my $l_length = $chunks->[$i]{left}{end} - $chunks->[$i]{left}{start};
		# Get the chunk's text (LEFT)
		seek($fhL,0,0);
		read($fhL,$ltext,$l_start);
		read($fhL,$ltext,$l_length);

		# Get the chunk's start offset and end offset (RIGHT)
		my $r_start  = $chunks->[$i]{right}{start};
		my $r_length = $chunks->[$i]{right}{end} - $chunks->[$i]{right}{start};
		# Get the chunk's text (REFT)
		seek($fhR,0,0);
		read($fhR,$rtext,$r_start);
		read($fhR,$rtext,$r_length);

		# if both sides start with section mark, put sync mark
		if ($ltext =~ /^\s*_sec[^:]*:([^_]+)_/ and $rtext =~ /^\s*_sec[^:]*:([^_]+)_/){
			$ltext =~ s/^\s*_sec[^:]*:([^_]+)_\n?/<sync id="$i">\n/;
			$rtext =~ s/^\s*_sec[^:]*:([^_]+)_\n?/<sync id="$i">\n/;
		}
		
		# Clean section marks left (unless $noclean is defined)
		$ltext =~ s/_sec[^:]*:([^_]+)_//g unless $options->{noclean};
		$rtext =~ s/_sec[^:]*:([^_]+)_//g unless $options->{noclean};

		# Print to .sync file
		print $syncl $ltext;
		print $syncr $rtext;
	}

	print $syncl qq{</sync>\n};
	print $syncr qq{</sync>\n};

	close $syncl;
	close $syncr;
}

=head2 splitchunks

Given two files FILEL and FILER, splits them by their synchronization points, storing each chunk in a file, where each FILEL.cXX matches FILER.cXX.

=cut

sub splitchunks{
	my ($chunks,$fileL,$fileR) = @_;
	my $ch=1;
	open my $fhL, '<', $fileL or die;
	open my $fhR, '<', $fileR or die;
	for my $c (@$chunks){
		my $id = sprintf("%.3d",int($ch));
		my ($t,$fout);

		my $l_start  = $c->{left}{start};
		my $l_length = $c->{left}{end} - $c->{left}{start};
		seek($fhL,0,0);
		read($fhL,$t,$l_start); # because seek only works in bytes
		read($fhL,$t,$l_length);
		open $fout, '>', "$fileL.c$id" or die;
		print $fout $t;
		close $fout;

		my $r_start  = $c->{right}{start};
		my $r_length = $c->{right}{end} - $c->{right}{start};
		seek($fhR,0,0);
		read($fhR,$t,$r_start); # because seek only works in bytes
		read($fhR,$t,$r_length);
		open $fout, '>', "$fileR.c$id" or die;
		print $fout $t;
		close $fout;

		$ch++;	
	}
}

=head2 calchunks

Calculates chunks for a given pair of files. A chunk is a set of consecutive sections, which are grouped in order to match the corresponding chunk.

=cut

sub calchunks{
	my ($tabsec,$fileL,$fileR,$options) = @_;
	my $fL = basename($fileL);
	my $fR = basename($fileR);

	my $dir = $options->{dir};
	if(defined($dir))	{ $dir.= "/"; }
	else				{ $dir = "";  }

	open my $secsL,'>',"$dir$fL.secs" or die "Can't open file '$dir$fL.secs' for writing!";
	open my $secsR,'>',"$dir$fR.secs" or die "Can't open file '$dir$fR.secs' for writing!";
	if ($options->{num}){ ## Compare only section numbers
		map {my $x = $_->{id}; $x =~ s/.*=//; print $secsL $x,"\n"} @{$tabsec->{left}{secs}};
		map {my $x = $_->{id}; $x =~ s/.*=//; print $secsR $x,"\n"} @{$tabsec->{right}{secs}};
	}
	else{
		map {print $secsL $_->{id},"\n"} @{$tabsec->{left}{secs}};
		map {print $secsR $_->{id},"\n"} @{$tabsec->{right}{secs}};
	}
	
	my ($l,$r) = (-1,-1);
	my $diff_file = "$dir${fL}_$fR.diff";
	qx{diff -y "$dir$fL.secs" "$dir$fR.secs" > '$diff_file'};
	open my $diff,"<", "$diff_file";
	my $chunks = [];

	while(<$diff>){
		chomp;
		my @a = split /\t+/;	
		if    ($a[1] =~ /^\s*<$/)   {
			$l++;
			push @{$chunks->[-1]{left}{secs}}, $l;
		}
		elsif ($a[1] =~ /^\s*>$/)   {
			$r++;
			push @{$chunks->[-1]{right}{secs}}, $r;
		}
		elsif ($a[1] =~ /^\s*[|]$/) {
			$l++;
			$r++;
			push @{$chunks->[-1]{left}{secs}}, $l;
			push @{$chunks->[-1]{right}{secs}}, $r;
		}
		else{
			$l++; $r++;
			if($chunks->[-1]){
				$chunks->[-1]{left}{end} = $tabsec->{left}{secs}[$l]{start};
				$chunks->[-1]{right}{end} = $tabsec->{right}{secs}[$r]{start};
			}
			push @$chunks, {
		 		left => {
		 			start => $tabsec->{left}{secs}[$l]{start},
		 			secs => [] },
		 		right => {
		 			start => $tabsec->{right}{secs}[$r]{start}, 
		 			secs => [] }
		 	};
			push @{$chunks->[-1]{left}{secs}}, $l;
			push @{$chunks->[-1]{right}{secs}}, $r;
		}
	}

	unlink("$fL.secs","$fR.secs",$diff_file) unless defined($options->{dump});
		
	$chunks->[-1]{left}{end} = $tabsec->{left}{secs}[-1]{end};
	$chunks->[-1]{right}{end} = $tabsec->{right}{secs}[-1]{end};
#	if(defined($options->{dump})){
#		open my $cf, '>', "$dir${fL}_$fR.chunks";
#		print $cf Dumper($chunks);
#		close $cf;
#	}
	return $chunks;
}

=head2 populate

From a given file in which sections have been delimited with Text::Perfide::BookCleaner, creates and returns a list containing information about the sections of this file: id, start offset and end offset.

=cut

sub populate{
	my ($file) = shift;
	my (@idlist,$text);
	open my $fh, '<', $file or die "Could not open file '$file'";
	$text = join '',<$fh>;
	
	push @idlist, { 'id' => 'begin', 'start' => 0, title => 'begin' };
	while($text =~ /(_sec.*:)(.*?_)/g){
		$idlist[-1]{end} = $-[0]-1;
		push @idlist,{
			'id' => $2, 
			'start' => $-[0],
		};

		# Get title
		my $subs = substr($text,$-[0],200);
		# if ($subs =~ /.*\n*(.|\n){5,100}?(?=\n)/pg) 	{ $idlist[-1]->{title} = ${^MATCH}; }
		if ($subs =~ /.*\s+([^\n]{1,100})/g) 				{ $idlist[-1]->{title} = ${^MATCH}; }
		else											{ $idlist[-1]->{title} = '' 		}
	}
	$idlist[-1]{end} = length $text;
	return \@idlist;
}

=head2 moreinfosecs

Calculates metrics on each pair of sections (length in words, ...)

=cut

sub moreinfosecs{
	my ($tabsec,$options) = @_;
	my ($fileL,$fileR) = ($tabsec->{left}{file},$tabsec->{right}{file});
	open my $fhL, '<', $fileL;
	open my $fhR, '<', $fileR;
	my $t;

	for my $sec (@{$tabsec->{left}{secs}}){
		my $start  = $sec->{start};
		my $length = $sec->{end} - $sec->{start};
		seek($fhL,0,0);
		read($fhL,$t,$start); # because seek only works in bytes
		read($fhL,$t,$length);
		$sec->{wc} = split /\s+/,$t;
	}

	for my $sec (@{$tabsec->{right}{secs}}){
		my $start  = $sec->{start};
		my $length = $sec->{end} - $sec->{start};
		seek($fhL,0,0);
		read($fhL,$t,$start); # because seek only works in bytes
		read($fhL,$t,$length);
		$sec->{wc} = split /\s+/,$t;
	}

	my $dir = $options->{dir};
	if(defined($dir))   { $dir.= "/"; }
	else                { $dir = "";  }
	my ($fL,$fR) = (basename($tabsec->{left}{file}), basename($tabsec->{right}{file}));

	_dump2file($tabsec,"$dir${fL}_$fR.tabsec") if ($options->{dump});
}

=head2 moreinfochunks

Calculates metrics on each pair of chunks (length in words, ...)

=cut

sub moreinfochunks{
	my ($chunks,$tabsec,$options) = @_;
	for my $chun (@$chunks){
		my $sum;	
		map { $sum+= $tabsec->{left}{secs}[$_]{wc} } @{$chun->{left}{secs}};
		$chun->{left}{wc} = $sum; 
		$sum=0;	
		map { $sum+= $tabsec->{right}{secs}[$_]{wc} } @{$chun->{right}{secs}};
		$chun->{right}{wc} = $sum; 
	}
	my $dir = $options->{dir};
	if(defined($dir))   { $dir.= "/"; }
	else                { $dir = "";  }
	my ($fL,$fR) = (basename($tabsec->{left}{file}), basename($tabsec->{right}{file}));

	_dump2file($chunks,"$dir${fL}_$fR.chunks") if ($options->{dump});
}

=head2 load_localrc
=cut

sub load_localrc {
	my $localrc = shift;
	die "Could not find configuration file '$localrc'" unless -e $localrc;
	return do $localrc;
}

sub _dump2file {
	my ($ref,$filename) = @_;
	open my $fn, '>', $filename or die "Could not open file '$filename' for writing.";
	print $fn Dumper($ref);
	close $fn;
}
		
sub _numcmp{
	my ($a,$b) = @_;
	return _numcmp($b,$a) if ($a>$b);
	return $a/$b;
}

=head1 AUTHOR

Andre Santos, C<< <andrefs at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-text-perfide-booksync at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Perfide-BookSync>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::Perfide::BookSync


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Perfide-BookSync>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Text-Perfide-BookSync>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Text-Perfide-BookSync>

=item * Search CPAN

L<http://search.cpan.org/dist/Text-Perfide-BookSync/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Andre Santos.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Text::Perfide::BookSync
