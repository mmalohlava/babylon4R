#!/usr/bin/env Rscript 

library(ggplot2)

t <- read.table('err_v_nodes.csv', header=T, sep=',')
tp <- data.frame(Nodes=t$Nodes, Err=t$Oobee, Kind="Out-of-bag error") 
tp <- rbind(tp, data.frame(Nodes=t$Nodes, Err=t$Error, Kind="Test error"))
tp

pdf("err_v_nodes.pdf")
ggplot() + 
      geom_point(data = tp, aes(x = Nodes, y = Err, group=Kind, color=Kind)) +
      geom_line(data = tp, aes(x = Nodes, y = Err, group=Kind, color=Kind), linetype='dotted') +
      labs(x='Number of nodes', y="Error in %", color="Error\nestimation")
      #geom_point(data=t, aes(x=Nodes, y=log(Leaves), group='Error'), color='green')
dev.off()
