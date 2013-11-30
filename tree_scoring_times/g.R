#!/usr/bin/Rscript

library(ggplot2)
r50t_5d  <- read.table("GBM_50t_5d.csv", header=T, sep=",")
r50t_10d <- read.table("GBM_50t_10d.csv", header=T, sep=",")
r100t_5d <- read.table("GBM_100t_5d.csv", header=T, sep=",")
r100t_10d <- read.table("GBM_100t_10d.csv", header=T, sep=",")
r1000t_5d <- read.table("GBM_1000t_5d.csv", header=T, sep=",")

fgdata <- data.frame(iter=r50t_5d$iter,
                    r50t_5d=r50t_5d$time_per_row_tree,
                    r50t_10d=r50t_10d$time_per_row_tree, 
                    r100t_5d=r100t_5d$time_per_row_tree,
                    r100t_10d=r100t_10d$time_per_row_tree,
                    r1000t_5d=r1000t_5d$time_per_row_tree)
summary(fgdata)

mkdf  <- function(dataset) {
  return(data.frame(iter=dataset$iter, time_per_tree=dataset$time_per_row_tree))
}
plot_g <- function(df, color, min, max, warmup,title) {
  maw <- mean(df[df$iter>warmup,2])
  print(maw)
  ggplot(data=df, aes(iter)) + 
  geom_point(aes(y=time_per_tree),colour=color, size=.7, fill="red") +
  stat_smooth(aes(y=time_per_tree)) +
  scale_y_continuous(limits = c(min, max)) +
  geom_hline(yintercept=maw, color="blue", size=0.1) +
  geom_vline(xintercept=warmup, color="green", size=0.1) +
  xlab("iterations") + ylab("scoring time per tree and row (nanosecond)") + ggtitle(title)
}

mktitle <- function(trees, depth, features) {
  return( sprintf("GBM: %d trees, %d depth, %d features\nOne iteration: scoring 193672 rows",trees, depth, features) )
}

ds <- mkdf(r50t_5d)
plot_g (ds, "red", 200, 400, 50, mktitle(50,5,7)) #"GBM: 50 trees, 5 depth, 7 features\nIteration: scoring on 193672 rows") 

ds <- mkdf(r100t_5d)
plot_g (ds, "red", 200, 400, 50, mktitle(100,5,7)) # "GBM: 100 trees, 5 depth, 7 features\nIteration: scoring on 193672 rows") 

ds <- mkdf(r1000t_5d)
plot_g (ds, "red", 1000, 1400, 50, mktitle(1000,5,7)) #"GBM: 1000 trees, 5 depth, 7 features \nIteration: scoring on 193672 rows") 

ds <- mkdf(r50t_10d)
plot_g (ds, "red", 1500, 2500, 50, mktitle(50,10,7)) #"GBM: 50 trees, 10 depth, 7 features\nIteration: scoring on 193672 rows") 

ds <- mkdf(r100t_10d)
plot_g (ds, "red", 1500, 2500, 50, mktitle(100,10,7)) #"GBM: 100 trees, 10 depth\nIteration: scoring on 193672 rows") 

#summary(r50t_5d$time_per_row_inter_tree)
#ggplot(data=r50t_5d, aes(x=iter, y=time_per_row_inter_tree)) + geom_point(colour="red", size=1, shape=21, fill="red") + xlab("iterations") + ylab("scoring time per internal tree and row (nanosecond)")
#ggplot(data=r50t_5d, aes(x=iter, y=time_per_row_inter_tree)) + geom_boxplot(outlier.shape=NA) + scale_y_continuous(limits = quantile(r50t_5d$time_per_row_inter_tree, c(0.1, 0.9)))
