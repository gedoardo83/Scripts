############################################################################
###  Read VCF file and return 2 hashes containing INFO tags and GT tags  ###
############################################################################
sub read_VCF {
	my ($inputfile) = @_;
	open(IN, $inputfile);
	while ($row = <IN>) {
		chomp($row);
		if ($row =~ /^##/) {next}
		if ($row =~ /^#CHROM/) {
			@line = split("\t", $row);
			@samplesid=@line[9..$#line];
			next;
		}
		@line = split("\t", $row);
		
		$varid = $line[0]."_".$line[1]."_".$line[3]."_".$line[4];
		
		#read info tags and their values and store in infos hash
		@infotags = split(";", $line[7]);
		foreach (@infotags) {
			$_ =~ /(.+)=(.+)/;
			$infos{$varid}{$1}=$2;
		}

		#read format tags and values for each sample and store in gtinfo hash
		@format=split(":", $line[8]);
		$i=9;
		foreach $mysample(@samplesid) {
			@column=split(":", $line[$i]);
			for ($n=0; $n<=$#format; $n++) {
		    	$gtinfo{$varid}{$mysample}{$format[$n]}=$column[$n];
			}
		$i++;
		}
	}
	close(IN);
	return (\%infos, \%gtinfo);
}
