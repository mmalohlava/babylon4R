#!/usr/bin/env Rscript

args<-commandArgs(TRUE)
if (length(args) != 1) {
    print("Name of results directory is required (e.g., stego_R) !")
    print("Exiting...")
    q()
}

dataset  <- args[1]
dataset_dir <- paste('../../', dataset, sep='')
results_file <- paste(dataset_dir, '/results/results.csv', sep='')

library(ggplot2)
library(grid) # for unit
# load graph utils
source('graph_utils.r')

m<-read.table(results_file, header=T, sep=',')
m<-na.omit(m)
m$treesstr <- paste(m$trees, ' trees')
m$perc <- paste(m$sample, '% sampling')

min_oobee     <- min(m[m$kind=='out-of-bag error',]$err)
min_class_err <- min(m[m$kind=='classification error',]$err)
min_oobee_row <- m[m$err == min_oobee, ]
min_class_err_row <- m[m$err == min_class_err, ]
mean_oobee     <- mean(m[m$kind=='out-of-bag error',]$err)
mean_class_err <- mean(m[m$kind=='classification error',]$err)

print(sprintf("Min  OOBEE = %f", min_oobee))
print(sprintf("Mean OOBEE = %f", mean_oobee))
print(min_oobee_row)
print(sprintf("Min  class errr = %f", min_class_err))
print(sprintf("Mean class errr = %f", mean_class_err))
print(min_class_err_row)


# load graph utils
source('graph_utils.r')
theme_opts <- get_default_theme_opts()

#pdf('sample_v_trees.pdf', paper='a4', pointsize=1)
pdf_filename <- paste(dataset_dir, '/sample_v_trees.pdf', sep='')
pdf(pdf_filename, pointsize=1)
#postscript('sample_v_trees.eps', horizontal=F, pointsize=1)
# To tune view see http://docs.ggplot2.org/current/theme.html
ggplot(data=m, aes(x=trees, y=err, group=kind, colour=kind)) +
 geom_line(size=0.3) +
 geom_point(colour="red", size=0.5) + scale_color_manual(values=c("red", "blue")) +
 facet_wrap( ~ perc, ncol=2)  +
 ggtitle("R RF accuracy (trees v. sampling rate)") + 
 labs(x='Number of trees', y='Error rate in %') +
 geom_hline(aes(yintercept=min_class_err), size=rel(0.2), colour="#990000", linetype="dashed") +
 theme_opts
 # see http://stackoverflow.com/questions/10836843/ggplot2-plot-area-margins how to move title margins
 # to remove legend title see http://stackoverflow.com/questions/6022898/how-can-i-remove-the-legend-title-in-ggplot2

dev.off()

pdf_filename <- paste(dataset_dir, '/trees_v_sample.pdf', sep='')
pdf(pdf_filename, pointsize=1)
#postscript('sample_v_trees.eps', horizontal=F, pointsize=1)
# To tune view see http://docs.ggplot2.org/current/theme.html
ggplot(data=m, aes(x=sample, y=err, group=kind, colour=kind)) +
 geom_line(size=0.3) +
 geom_point(colour="red", size=0.5) + scale_color_manual(values=c("red", "blue")) +
 facet_wrap( ~ treesstr, ncol=2)  +
 ggtitle("R RF accuracy (sampling rate v. size of forest)") + 
 labs(x='Sampling rate in %', y='Error rate in %') +
 geom_hline(aes(yintercept=min_class_err), colour="#990000", linetype="dashed") +
 theme_opts
 # see http://stackoverflow.com/questions/10836843/ggplot2-plot-area-margins how to move title margins
 # to remove legend title see http://stackoverflow.com/questions/6022898/how-can-i-remove-the-legend-title-in-ggplot2

dev.off()

