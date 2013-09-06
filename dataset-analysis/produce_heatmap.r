#!/usr/bin/env Rscript

args<-commandArgs(TRUE)
if (length(args) != 1) {
    print("Name of results directory is required (e.g., stego_h2o) !")
    print("Exiting...")
    q()
}

dataset  <- args[1]
dataset_dir <- paste('../../', dataset, sep='')
results_file <- paste(dataset_dir, '/results.csv', sep='')

library(ggplot2)
library(grid) # for unit
# load graph utils
source('graph_utils.r')

m<-read.table(results_file, header=T, sep=',')
print_results(m)

# load graph utils
source('graph_utils.r')

pdf_filename <- paste(dataset_dir, '/heatmap_class_error.pdf', sep='')
pdf(pdf_filename, pointsize=1)
g_class_err<-get_heatmap_graph(m, 'ClassError')
print(g_class_err)
dev.off()

pdf_filename <- paste(dataset_dir, '/heatmap_oobee.pdf', sep='')
pdf(pdf_filename, pointsize=1)
g_oobee <- get_heatmap_graph(m, 'OOB')
print(g_oobee)
dev.off()


