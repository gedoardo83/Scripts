#args1 = results of linear/logistic plink association
#args2 = bim file
#args3 = directory (with final slash) containing info files from imputation filtered: 2 columns SNP and Rsq (.filt files)
#args4 = optional ouput file name (default: input.META)


#check arguments and set default output if not provided
args = commandArgs(trailingOnly=TRUE)
if (length(args)<2) {
  stop("At least two arguments must be supplied (association file, bim file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[3] = paste0(args[1],".META")
}

#Read association table and bim file
assoc <- read.table(args[1], header=T, as.is=T)
bim <- read.table(args[2], as.is=T)
bim$ID <- paste0(bim$V1,":",bim$V4)
bim$INFO <- 0
bim$V1 <- paste0("chr",bim$V1)

#Read info files bychr
files <- dir(args[3], pattern=".filt")
for (f in files) {
  chr.id <- gsub("\\.info\\.filt", "", f)
  myfile <- paste0(args[3], f) 
  info.data[[chr.id]] <- read.table(myfile, header=T, row.names=1, as.is=T)                            
}

#Create and save META input file
meta.file <- data.frame(chr=assoc$CHR, rsid=assoc$SNP, pos=assoc$BP, allele_A=bim$V6, allele_B=assoc$A1, P_value=assoc$P, info=##, beta=assoc$BETA, se=assoc$SE)
write.table(meta.file, args[3], row.names=F, quote=F)
