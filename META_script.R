#args1 = results of linear/logistic plink association
#args2 = bim file
#args3 = directory (with final slash) containing info files from imputation filtered (.filt files)
#       .filt files have 2 columns (SNP and Rsq) and they are generated from info files using: awk '$7 >= 0.5 {print $1,$7}' 
#args4 = optional ouput file name (default: input.META)

start_time <- Sys.time()

#check arguments and set default output if not provided
args = commandArgs(trailingOnly=TRUE)
if (length(args)<2) {
  stop("At least two arguments must be supplied (association file, bim file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[3] = paste0(args[1],".META")
}

#Read association table and bim file
message("loading association results...")
assoc <- read.table(args[1], header=T, as.is=T)
assoc <- assoc[assoc$TEST == "ADD",] #remove eventual covariates test lines
message("loading bim file...")
bim <- read.table(args[2], as.is=T)
bim$ID <- paste0(bim$V1,":",bim$V4)
bim$INFO <- 0
bim$V1 <- paste0("chr",bim$V1)

#Read info files bychr
files <- dir(args[3], pattern=".filt")
info.data <- list()
for (f in files) {
  message(paste0("load info file: ",f))
  chr.id <- gsub("\\.info\\.filt", "", f)
  myfile <- paste0(args[3], f) 
  info.data[[chr.id]] <- read.table(myfile, header=T, as.is=T)                            
}

#Retrieve Rsq value for each SNP in bim file
message("annotating rsq information...")
pb <- txtProgressBar(min=1, max=nrow(bim), initial=0)

for (n in 1:nrow(bim)) {
  setTxtProgressBar(pb, n)
  bim$INFO[n] <- info.data[[bim$V1[n]]][info.data[[bim$V1[n]]]$SNP == bim$ID[n],2]
}
close(pb)

#Create and save META input file
message(paste0("save meta input file to ", args[3],"\n"))
meta.file <- data.frame(chr=assoc$CHR, rsid=assoc$SNP, pos=assoc$BP, allele_A=bim$V6, allele_B=assoc$A1, P_value=assoc$P, info=bim$INFO, beta=assoc$BETA, se=assoc$SE)
write.table(meta.file, args[3], row.names=F, quote=F)

end_time <- Sys.time()
elapsed_time <- end_time - start_time

message(paste0("All done! Elapsed time: ",elapsed_time,"\n")
