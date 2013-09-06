#!/usr/bin/env Rscript

library(ggplot2)

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, cols is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
# Found at http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_%28ggplot2%29/
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use cols to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

require(grid)
## Function for arranging ggplots. use png(); arrange(p1, p2, ncol=1); dev.off() to save.
vp.layout <- function(x, y) viewport(layout.pos.row=x, layout.pos.col=y)
arrange_ggplot2 <- function(..., plotlist=NULL, nrow=NULL, ncol=NULL, as.table=FALSE) {
  dots <- c(list(...), plotlist)
  n <- length(dots)
  if(is.null(nrow) & is.null(ncol)) { nrow = floor(n/2) ; ncol = ceiling(n/nrow)}
  if(is.null(nrow)) { nrow = ceiling(n/ncol)}
  if(is.null(ncol)) { ncol = ceiling(n/nrow)}
  ## NOTE see n2mfrow in grDevices for possible alternative
  ii.p <- 1
  while (ii.p <= n) {
      grid.newpage()
      pushViewport(viewport(layout=grid.layout(nrow,ncol) ) )
      for(ii.row in seq(1, nrow)){
          ii.table.row <- ii.row
          if(as.table) {ii.table.row <- nrow - ii.table.row + 1}
          for(ii.col in seq(1, ncol)){
              ii.table <- ii.p
              if(ii.p > n) break
              print(dots[[ii.table]], vp=vp.layout(ii.table.row, ii.col))
              ii.p <- ii.p + 1
          }
      }
  }
}

#
# Function returning a vector of graphs for each column in train/test data.
# Columns in test/train data has to match.
#

column_graphs <- function(test, train, categor_treshold=20) {
    col_graphs <- vector(mode="list", length=ncol(test))
    graph_theme_settings <- theme(
                                  plot.title=element_text(size=rel(0.7),vjust=2), 
                                  axis.text.x=element_text(size=rel(0.7)),
                                  axis.text.y=element_text(size=rel(0.7)),
                                  panel.grid.major = element_line(size = 0.2), 
                                  panel.grid.minor = element_line(size=0.2, color="grey", linetype='dotted'), 
                                  legend.title = element_blank()) 
    for (i in 1:ncol(test)) {
      colname <- colnames(test)[i]
      if (nrow(unique(test[i])) < categor_treshold) {
          train.factor <- as.factor(train[,i])
          test.factor  <- as.factor(test[,i])
          # append missing factors
          levels(train.factor) <- sort(union(levels(train.factor), setdiff(levels(test.factor),
                                                                      levels(train.factor))))
          levels(test.factor)  <- sort(union(levels(test.factor), setdiff(levels(train.factor),
                                                                     levels(test.factor))))
          train.summary <- summary(train.factor, maxsum=categor_treshold+1)/nrow(train)
          test.summary  <- summary(test.factor, maxsum=categor_treshold+1)/nrow(test)

          train.colf    <- levels(train.factor)
          test.colf     <- levels(test.factor)

          train.dt <- data.frame(ids=train.colf, counts=train.summary, kind='train')
          test.dt  <- data.frame(ids=test.colf, counts=test.summary, kind='test')
          
          dt <- rbind(train.dt, test.dt)
          gpl <- ggplot(data=dt, aes(x=ids, y=counts, fill=kind)) + geom_bar(stat='identity',position='dodge') + ggtitle(colname) + xlab('') + ylab('') + graph_theme_settings + guides(fill=guide_legend(title=NULL))
          if (length(train.colf) > 40) {
            gpl <- gpl + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
          }
          col_graphs[[i]] <-  gpl
      } else {
          dt <- rbind(data.frame(data=train[,i], kind='train'), data.frame(data=test[,i], kind='test'))
          # Help legend: http://www.cookbook-r.com/Graphs/Legends_%28ggplot2%29/
          col_graphs[[i]] <- ggplot(dt, aes(kind, data, fill=kind)) + coord_flip() + geom_boxplot(outlier.size=1, outlier.colour='green', size=0.1) + ggtitle(colname) + xlab('') + ylab('') + graph_theme_settings + guides(fill=F) 
      }
    }
    return( col_graphs )
}

args<-commandArgs(TRUE)
if (length(args) != 1) {
    print("Name of dataset is required!")
    print("Exiting...")
    q()
}

dataset  <- args[1]
dataset_dir <- paste('/Users/michal/Devel/projects/h2o/repos/datasets/bench/', dataset, sep='')

train.ds <- log(read.table(paste(dataset_dir,'/R/', 'train.csv', sep=''), header=T, sep=','))
test.ds  <- log(read.table(paste(dataset_dir,'/R/', 'test.csv', sep=''), header=T, sep=','))

graphs <- column_graphs(test.ds, train.ds)
#multiplot(plotlist=col_graphs, cols=4)
output_dir <- paste("../figures/", dataset, sep='')
output_pdf_file <- paste(output_dir, '/', dataset, '_%03d.pdf',sep='')
pdf(output_pdf_file, onefile=F, pointsize=1)
arrange_ggplot2(plotlist=graphs, ncol=1, nrow=5)
dev.off()

