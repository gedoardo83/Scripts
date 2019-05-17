library(bioMart)
ensembl <- useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", GRCh=37)
gene_ensembl <- getBM(attributes=c('ensembl_gene_id','hgnc_symbol'), filters='hgnc_symbol', values=[list ids], mart=ensembl
