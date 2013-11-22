#!/usr/bin/Rscript

library(ggplot2)
r50t_5d  <- read.table("GBM_covtype_50trees_5depth.csv", header=T, sep=",")
r50t_10d <- read.table("GBM_covtype_50trees_10depth.csv", header=T, sep=",")
r100t_5d <- read.table("GBM_covtype_100trees_5depth.csv", header=T, sep=",")
r100t_10d <- read.table("GBM_covtype_100trees_10depth.csv", header=T, sep=",")

fgdata <- data.frame(iter=r50t_5d$iter,
                    r50t_5d=r50t_5d$time_per_row_tree,
                    r50t_10d=r50t_10d$time_per_row_tree, 
                    r100t_5d=r100t_5d$time_per_row_tree,
                    r100t_10d=r100t_10d$time_per_row_tree)
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

ds <- mkdf(r50t_5d)
plot_g (ds, "red", 0, 1500, 1000, "GBM: 50 trees, 5 depth\nIteration: scoring on 100 rows") 

ds <- mkdf(r100t_5d)
plot_g (ds, "red", 0, 1500, 1000, "GBM: 100 trees, 5 depth\nIteration: scoring on 100 rows") 

ds <- mkdf(r50t_10d)
plot_g (ds, "red", 1000, 3500, 1000, "GBM: 50 trees, 10 depth\nIteration: scoring on 100 rows") 

ds <- mkdf(r100t_10d)
plot_g (ds, "red", 1000, 3500, 1000, "GBM: 100 trees, 10 depth\nIteration: scoring on 100 rows") 


 #geom_point(aes(y=r50t_10d),colour="blue", size=1, shape=21, fill="red") + 
  #geom_point(aes(y=r100t_5d),colour="green", size=1, shape=21, fill="red") +
  #geom_point(aes(y=r100t_10d),colour="yellow", size=1, shape=21, fill="red") + 
#ggplot(data=r50t_5d, aes(x=iter, y=time_per_row_tree)) + geom_boxplot(outlier.shape=NA) + scale_y_continuous(limits = quantile(r50t_5d$time_per_row_tree, c(0.1, 0.9)))


#summary(r50t_5d$time_per_row_inter_tree)
#ggplot(data=r50t_5d, aes(x=iter, y=time_per_row_inter_tree)) + geom_point(colour="red", size=1, shape=21, fill="red") + xlab("iterations") + ylab("scoring time per internal tree and row (nanosecond)")
#ggplot(data=r50t_5d, aes(x=iter, y=time_per_row_inter_tree)) + geom_boxplot(outlier.shape=NA) + scale_y_continuous(limits = quantile(r50t_5d$time_per_row_inter_tree, c(0.1, 0.9)))
