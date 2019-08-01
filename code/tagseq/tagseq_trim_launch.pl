#!/usr/bin/perl

my $usage= "

tagseq_trim_launch.pl :

Prints out a series of commands to trim Illumina tag-seq reads, one for each reads file
(tagseq_clipper.pl | fasx_clipper | fastx_quality_filter )

prints to STDOUT

Arguments:
1: glob to fastq files
2: optional, the position of name-deriving string in the file name
	if separated by underscores, 
	such as: input file Sample_RNA_2DVH_L002_R1.cat.fastq
	specifying arg2 as '3' would create output file with a name '2DVH.fastq'	

Example: 
tagseq_trim_launch.pl '\.fq$' > clean

NOTE: use this script if your qualities in the fastq files are 33-based;
if not, use tagseq_trim_launch_bgi.pl instead

";

if (!$ARGV[0]) { die $usage;}
my $glob=$ARGV[0];

opendir THIS, ".";
my @fqs=grep /$glob/,readdir THIS;
my $outname="";

foreach $fqf (@fqs) {
	if ($ARGV[1]) {
		my @parts=split('_',$fqf);
		$outname=$parts[$ARGV[1]-1].".trim";
	}
	else { $outname=$fqf.".trim";}
	print "tagseq_clipper.pl $fqf '[ATGC]?[ATGC][AC][AT]GGG+|[ATGC]?[ATGC]TGC[AC][AT]GGG+|[ATGC]?[ATGC]GC[AT]TC[ACT][AC][AT]GGG+' keep | fastx_clipper -a AAAAAAAA -l 20 -Q33 | fastx_clipper -a AGATCGGAAG -l 20 -Q33 | fastq_quality_filter -Q33 -q 20 -p 80 >$outname\n";
}

