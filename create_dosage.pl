#This script is part of Plink_to_dosage.pl pipeline.
#It take .traw file as input and create predixcan dosage file
#It expectd TEMP.chr#.frq.tab and TEMP.chr#.traw files in the same folder
$file = $ARGV[0];

$file =~ /TEMP.(chr\d+).traw/;
$outfile = "$1.txt";
$frqfile = "TEMP.$1.frq.tab";

#Read MAF from .frq file
open(IN, $frqfile);
  while($row=<IN>) {
    chomp($row);
    @line = split("\t", $row);
    $snps{$line[1]} = join(" ", @line[2..4]);
    $maf{$line[1]} = $line[4];
  }
close(IN);

#Read dosages from .traw files and create predixcan inputs files
open(IN, $file);
open(OUT, ">>$outfile");
$header = <IN>; #skip header line
  while($row=<IN>) {
    chomp($row);
    @line = split("\t", $row);
    for ($n=6; $n<=$#line; $n++) {
      if ($line[$n] eq "NA") {$line[$n] = 2*$maf{$line[1]}}; # Impute missing data as 2*MAF
    }
    print OUT "$line[0] $line[1] $line[3] $snps{$line[1]} ".join(" ", @line[6..$#line])."\n";
  }
close(IN);
close(OUT);
