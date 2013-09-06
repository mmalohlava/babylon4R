#!/usr/bin/env Rscript

args<-commandArgs(TRUE)
if (length(args) != 1) {
    print("Name of results directory is required (e.g., stego_R) !")
    print("Exiting...")
    q()
}

dataset  <- args[1]
dataset_dir <- paste('../../', dataset, sep='')
results_file <- paste(dataset_dir, '/results/results_per_class.csv', sep='')

library(ggplot2)
library(grid) # for unit


m<-read.table(results_file, header=T, sep=',')
m$treesstr <- paste(m$trees, ' trees')

# load graph utils
source('graph_utils.r')
theme_opts <- get_default_theme_opts()

#pdf('sample_v_trees.pdf', paper='a4', pointsize=1)
pdf_filename <- paste(dataset_dir, '/results_per_class.pdf', sep='')
pdf(pdf_filename, pointsize=1)
#postscript('sample_v_trees.eps', horizontal=F, pointsize=1)
# To tune view see http://docs.ggplot2.org/current/theme.html
ggplot(data=m, aes(x=trees, y=err, colour=predict, group=predict)) +
 geom_line(size=0.3) +
 geom_point(aes(colour=predict), size=0.5) + # scale_color_manual(values=c("red", "blue")) +
 facet_grid(sample ~ kind, labeller=sample_labeller)  +
 ggtitle("Error rate for individual predictor classes") + 
 labs(x='Number of trees', y='Error rate in %') +
 theme_opts +
 theme(strip.text.x=element_text(size=6), strip.text.y=element_text(size=6), legend.direction="horizontal")
 # see http://stackoverflow.com/questions/10836843/ggplot2-plot-area-margins how to move title margins
 # to remove legend title see http://stackoverflow.com/questions/6022898/how-can-i-remove-the-legend-title-in-ggplot2
 #geom_hline(aes(yintercept=min_class_err), size=rel(0.2), colour="#990000", linetype="dashed") +

dev.off()

