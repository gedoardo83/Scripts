#args1 = results of linear/logistic plink association
#args2 = bim file
#args3 = directory (with final slash) containing info files from imputation filtered (.filt files)
#       .filt files have 2 columns (SNP and Rsq) and they are generated from info files using: awk '$7 >= 0.5 {print $1,$7}' 
#args4 = optional ouput file name (default: input.META)

start_time <- Sys.time()

#check arguments and set default output if not provided
args = commandArgs(trailingOnly=TRUE)
if (length(args)<3) {
  stop("At least 3 arguments must be supplied (association file, bim file, info files directory).n", call.=FALSE)
} else if (length(args)==3) {
  # default output file
  args[4] = paste0(args[1],".META")
}

#Print arguments
message("Arguents as interpreted:")
message(paste0("\tinput assoc: ",args[1]))
message(paste0("\tinput bim: ",args[2]))
message(paste0("\tinput info_dir: ",args[3]))
message(paste0("\toutput file: ",args[4]))

#Read association table and bim file
message("loading association results...")
assoc <- read.table(args[1], header=T, as.is=T)
assoc <- assoc[assoc$TEST == "ADD",] #remove eventual covariates test lines
message("loading bim file...")
bim <- read.table(args[2], as.is=T)
bim$ID <- paste0(bim$V1,":",bim$V4)

#Read info files bychr
files <- dir(args[3], pattern=".filt")
myfile <- paste0(args[3], files[1])
info.data <- read.table(myfile, header=T, as.is=T) 
for (f in files) {
  message(paste0("load info file: ",f))
  chr.id <- gsub("\\.info\\.filt", "", f)
  myfile <- paste0(args[3], f) 
  info.data <- rbind(info.data,read.table(myfile, header=T, as.is=T))                            
}

#Retrieve Rsq value for each SNP in bim file
message("annotating rsq information...")
bim <- merge(bim, info.data, by.x="ID", by.y="SNP", all.x=T)
bim <- bim[match(assoc$SNP, bim$V2),]

#Create and save META input file
message("generating meta input file...")
meta.file <- data.frame(chr=assoc$CHR, rsid=assoc$SNP, pos=assoc$BP, allele_A=bim$V6, allele_B=assoc$A1, P_value=assoc$P, info=bim$Rsq, beta=assoc$BETA, se=assoc$SE)
message(paste0("save file to ", args[4]))
write.table(meta.file, args[4], row.names=F, quote=F)

end_time <- Sys.time()
elapsed_time <- end_time - start_time

message(paste0("All done! Elapsed time: ",elapsed_time,"\n"))
