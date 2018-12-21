$inputfile = $ARGV[0]; #Prefix of input plink bim/bed/fam dataset
$plink = "/data0/opt/plink-1.9/plink"; #plink program
$dosagescript = "/data0/ourtools/create_dosage.pl";

#run plink to calculate MAF for all SNPs, split by chr
system("cut -f1 $inputfile.bim | sort -u | xargs -P25 -I input -d'\n' sh -c '$plink --bfile $inputfile --freq --allow-no-sex --chr input --out TEMP.chrinput'");

#run plink to convert to 0/1/2 dosage format
system("cut -f1 $inputfile.bim | sort -u | xargs -P25 -I input -d'\n' sh -c '$plink --bfile $inputfile --allow-no-sex --recode A-transpose --chr input --out TEMP.chrinput'");

#make .frq file tab delimited
$cmd = "ls *.frq | xargs -P25 -I input -d'\\n' sh -c 'cat input | tr -s \"\\t\" \"\\n\" | sed \"s/^\\t//g\" > input.tab'";
system($cmd);

#Run create_dosage.pl to create predixcan dosage files
system("ls *.traw | xargs -P25 -I input -d'\n' sh -c 'perl $dosagescript input'");

#gzip files and clean TEMP files
system("ls *.txt | xargs -P25 -I input -d'\n' sh -c 'gzip input'");

#create samples.txt which lists samples in the same order as dosage files
@files = <*.traw>;
open(IN, $files[1]);
open(OUT, ">>samples.txt");
$header=<IN>;
chomp($header);
@line = split("\t", $header);
print OUT join("\n", @line[6..$#line]);

#Clean temp files
system("rm TEMP.*");
