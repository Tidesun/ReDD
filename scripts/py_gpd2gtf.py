import sys

if len(sys.argv) != 3:
	print "Function: convert gpd format file to gtf format file with only exon feature."
	print "Usage: python py_gpd2gtf.py input.gpd output.gtf"
	sys.exit()

gpd_file = open(sys.argv[1],"r")
gtf_file = open(sys.argv[2],"w")

for line in gpd_file:
	gene_id,isoform_id,chr,strand,tss,tts,cds_start,cds_end,exon_number,exon_start,exon_end = line.strip().split("\t")[:11]
	if strand == "+":
		for i in range(0,int(exon_number)):
			info = "gene_id \"" + gene_id + "\"; transcript_id \"" + isoform_id + "\"; exon_number \"" + str(i+1) + "\"; gene_name \"" + gene_id + "\";"
			print >>gtf_file, chr + "\t.\texon\t" + str(int(exon_start.split(",")[i])+1) + "\t" + exon_end.split(",")[i] + "\t.\t" + strand + "\t.\t" + info
	else:
		for i in range(0,int(exon_number)):
			info = "gene_id \"" + gene_id + "\"; transcript_id \"" + isoform_id + "\"; exon_number \"" + str(int(exon_number)-i) + "\"; gene_name \"" + gene_id + "\";"
			print >>gtf_file, chr + "\t.\texon\t" + str(int(exon_start.split(",")[i])+1) + "\t" + exon_end.split(",")[i] + "\t.\t" + strand + "\t.\t" + info

gpd_file.close()
gtf_file.close()
