sample_labeller <- function(var, value) {
    value <- as.character(value)
    if (var == "sample") {
        value <- paste(value, "%")
    }
    return (value)
}

get_default_theme_opts <- function() {
    theme_opts <- theme_bw() + theme(
           panel.margin=unit(2, "mm"), 
           legend.position = "bottom", 
           legend.direction='vertical', 
           axis.text.x=element_text(size=rel(0.7)), 
           axis.text.y=element_text(size=rel(0.6)), 
           panel.grid.major = element_line(size = rel(0.3)), 
           panel.grid.minor = element_line(size = rel(0.2), color="grey", linetype='dotted'), 
           plot.title=element_text(size=12,vjust=2), 
           axis.title.x=element_text(vjust=-0.5, size=8), 
           axis.title.y=element_text(vjust=-0.001, size=8, angle=90), 
           plot.margin=unit(c(5,5,5,5),'mm'), 
           legend.key=element_rect(color='white'), 
           legend.text = element_text(size = 8), 
           legend.title = element_blank()) 
     
    return(theme_opts)
}

print_results <- function(m) {
    min_oobee     <- min(m$OOB)
    min_class_err <- min(m$ClassError)
    min_oobee_row <- m[m$OOB == min_oobee, ]
    min_class_err_row <- m[m$ClassError == min_class_err, ]
    mean_oobee     <- mean(m$OOB)
    mean_class_err <- mean(m$ClassError)

    print(sprintf("Min  OOBEE = %f %%", 100*min_oobee))
    print(sprintf("Mean OOBEE = %f %%", 100*mean_oobee))
    print(sprintf(" Class err = %f %%", 100*(min_oobee_row$ClassError)))
    print(min_oobee_row)
    print(sprintf("Min  class errr = %f %%", 100*min_class_err))
    print(sprintf("Mean class errr = %f %%", 100*mean_class_err))
    print(sprintf("          OOBEE = %f %%", 100*(min_class_err_row$OOB)))
    print(min_class_err_row)
}


get_heatmap_visual_theme <- function() {
    theme_opts <- get_default_theme_opts()
    visual_opts <- theme_opts +
      theme(axis.ticks=element_blank(), 
           axis.line=element_blank(), 
           panel.border=element_blank(),
           legend.position="right"
           )

    return(visual_opts)
}

get_heatmap_graph <- function(m, error_type) {
    visual_opts <- get_heatmap_visual_theme()
    g<-ggplot(data=m, aes(x=as.factor(Trees), y=as.factor(Sample))) +
           geom_tile(aes_string(fill=error_type), colour='white') + 
           scale_x_discrete(expand = c(0, 0)) +
           scale_y_discrete(expand = c(0, 0)) +
           coord_fixed(4/5) +
           labs(x='Number of trees', y='Sample rate in %') +
           #scale_fill_gradient(low='steelblue', high='lightcyan1') +
           #scale_fill_gradient(low='steelblue', high='dodgerblue4') +
           scale_fill_gradient(low='red', high='green') +
           visual_opts

    return (g)
}
