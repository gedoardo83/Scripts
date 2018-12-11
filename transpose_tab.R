#args1 = file to be transposed (with header and row ids in first column)
#args2 = output file

args=commandArgs(trailingOnly=TRUE)
mydata <- read.table(args[1], header=TRUE, row.names=1)
transposed <- t(mydata)
write.table(transposed,file=args[2],quote=FALSE, sep="\t")
