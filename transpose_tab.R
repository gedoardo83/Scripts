#args1 = file to be transposed (with header and row ids in first column)
#args2 = output file
args=commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least 1 argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = paste0(args[1],".tr")
}

mydata <- read.table(args[1], header=TRUE, row.names=1)
transposed <- t(mydata)
message(paste0("Saving to ",args[2],"\n"))
write.table(transposed,file=args[2],quote=FALSE, sep="\t")
