jp_pos <- read.table("log/jp_pos.csv", header=TRUE, sep=",")
jp_gps <- read.table("log/jp_gps.csv", header=TRUE, sep=",")
jp_telemetry <- read.table("log/jp_telemetry.csv", header=TRUE, sep=",")

pr_pos <- read.table("log/pr_pos.csv", header=TRUE, sep=",")
pr_gps <- read.table("log/pr_gps.csv", header=TRUE, sep=",")
pr_telemetry <- read.table("log/pr_telemetry.csv", header=TRUE, sep=",")
pr_telemetry <- na.omit(pr_telemetry)

# number of pictures per page
par(mfrow=c(2,2),pch=20)

xlimits <- c(min(jp_pos$X, pr_pos$X), max(jp_pos$X, pr_pos$X))
ylimits <- c(min(jp_pos$Y, pr_pos$Y), max(jp_pos$Y, pr_pos$Y))
plot(jp_pos, main="JP: Airplane position", xlim=xlimits, ylim=ylimits)
abline(h=0,v=0, col="red")
plot(pr_pos, main="PR: Airplane position", xlim=xlimits, ylim=ylimits)
abline(h=0,v=0, col="red")

# telemetry
for(i in 1:length(jp_telemetry)) {
    ylimits <- c(min(jp_telemetry[i], pr_telemetry[i]), max(jp_telemetry[i], pr_telemetry[i]))
    print(ylimits)
    heading <- paste("JP: ", names(jp_telemetry[i]))
    plot(jp_telemetry[[i]],main=heading, xlab="time",ylab=names(jp_telemetry[i]),ylim=ylimits);
    abline(h=0,v=0, col="red")

    heading <- paste("PR: ", names(pr_telemetry[i]))
    plot(pr_telemetry[[i]],main=heading, xlab="time",ylab=names(pr_telemetry[i]),ylim=ylimits);
    abline(h=0,v=0, col="red")
}

# gps - put all the data on one page
ydim <- length(jp_gps)/2
par(mfrow=c(ydim,2))
for(i in 1:length(jp_gps)) {
    heading <- paste("JP: GPS ", names(jp_gps[i]))
    plot(jp_gps[[i]],main=heading, xlab="time",ylab=names(jp_gps[i]));
    abline(h=0,v=0, col="red")

    heading <- paste("PR: GPS ", names(pr_gps[i]))
    plot(pr_gps[[i]],main=heading, xlab="time",ylab=names(pr_gps[i]));
    abline(h=0,v=0, col="red")
}
