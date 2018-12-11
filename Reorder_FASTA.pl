#!/usr/bin/perl
#ARGV[0] = file with fasta sequences
#ARGV[1] = file with order list (1 id per line)
#ARGV[2] = output file
use Bio::SeqIO;
use Bio::DB::Fasta;

$file = $ARGV[0];
$multifasta = Bio::DB::Fasta->new($file);
$ordered_seqio = Bio::SeqIO-> new(-file => ">$ARGV[2]",-format => "fasta");

open(ORDER, $ARGV[1]);

while ($row=<ORDER>) {
	chomp($row);
	print "Moving sequence $row\n";
	$sequence=$multifasta->get_Seq_by_id($row);
	$ordered_seqio->write_seq($sequence);
}
