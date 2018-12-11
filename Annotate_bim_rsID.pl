#ARGV[0] = dbSNP vcf.gz indexed files
#ARGV[1] = bim file to be annoated

open(IN, $ARGV[1]);
open(OUT, ">>$ARGV[1]_new");
while($row=<IN>) {
	#$totalvars++;
	#print "$totalvars\r";
	chomp($row);
	@line=split("\t", $row);
	$id= $line[0]."_".$line[3]."_".$line[4]."_".$line[5];
	$mysnp = `tabix $ARGV[0] $line[0]:$line[3]-$line[3]`;
	if ($mysnp != "") {
		@fields = split("\t", $mysnp);
		@alts = split(",", $fields[4]);
		foreach $alt(@alts) {
			$totalvars++;
			$dbsnpid1 = $fields[0]."_".$field[1]."_".$fields[3]."_".$alt;
			$dbsnpid2 = $fields[0]."_".$fields[1]."_".$alt."_".$fields[3];
			if ($id == $dbsnpid1 || $id == $dbsnpid2) {
				$line[1]=$fields[2];
				$converted++;
			}
		}
	} else {$totalvars++}
	print OUT join("\t", @line)."\n";
}
close(IN);
print "Annotation done: ".($converted/$totalvars)." of vars annotated\n";
