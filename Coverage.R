# Get a list of the bedtools output files (contain all section of the output from bedtools coverage -hist)
files <- list.files(pattern="cov.all.txt$")

# Create short sample names from the filenames
# Sample filenames might look like this: Sample.cov.all.txt
labs <- gsub("\\.cov\\.all\\.txt", "", files, perl=TRUE)

# Create lists to hold coverage and cumulative coverage for each alignment,
# and read the data into these lists.
cov <- list()
cov_cumul <- list()
for (i in 1:length(files)) {
    cov[[i]] <- read.table(files[i])
    cov_cumul[[i]] <- 1-cumsum(cov[[i]][,5])
}

# Pick some colors
cols <- rainbow(length(cov))

# Save the graph to a file
png("coverage-plots.png", h=1000, w=1000, pointsize=20)

# Create plot area, add gridlines and axis labels.
plot(cov[[1]][2:501, 2], cov_cumul[[1]][1:500], type='n', xlab="Depth", ylab="Fraction of capture target bases \u2265 depth", ylim=c(0,1.0), main="Target Region Coverage")
abline(v = 20, col = "gray60")
abline(v = 50, col = "gray60")
abline(v = 100, col = "gray60")
abline(h = 0.50, col = "gray60")
abline(h = 0.90, col = "gray60")
axis(1, at=c(20,50,100), labels=c(20,50,100))
axis(2, at=c(0.90), labels=c(0.90))
axis(2, at=c(0.50), labels=c(0.50))

# Plot the data for each of the sample alignments
for (i in 1:length(cov)) points(cov[[i]][2:501, 2], cov_cumul[[i]][1:500], type='l', lwd=3, col=cols[i])

# Add a legend using sample labeles
legend("topright", legend=labs, col=cols, lty=1, lwd=4)

dev.off()

#Create table with coverage metrics
cov_table <- data.frame(coverage=c("0","10","20","50","100","mean"), stringsAsFactors=F)
for (n in 1:length(cov)) {
  cov_table[1,n+1] <- cov[[n]][1,5]
  cov_table[2,n+1] <- cov_cumul[[n]][11]
  cov_table[3,n+1] <- cov_cumul[[n]][21]
  cov_table[4,n+1] <- cov_cumul[[n]][51]
  cov_table[5,n+1] <- cov_cumul[[n]][101]
  cov_table[6,n+1] <- sum(cov[[n]][,2]*cov[[n]][,3])/cov[[n]][1,4]
}
colnames(cov_table) <- c("coverage", labs)
write.table(cov_table, file="coverage_table.txt", sep="\t", row.names=F, quote=F)
