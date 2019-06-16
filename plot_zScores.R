library(ggplot2)

currentDir <- getwd()

# load and name data
setwd(currentDir)
out_100_25 <- read.table('100_25.txt', sep = '\t')
colnames(out_100_25) <- c("cat", "windowLength", "overlap", "fileIndex", "start_stop" ,"zScore")

out_100_75 <- read.table('100_75.txt', sep = '\t')
colnames(out_100_75) <- c("cat", "windowLength", "overlap", "fileIndex", "start_stop" ,"zScore")

out_200_100 <- read.table('200_100.txt', sep = '\t')
colnames(out_200_100) <- c("cat", "windowLength", "overlap", "fileIndex", "start_stop" ,"zScore")

out_200_75 <- read.table('200_75.txt', sep = '\t')
colnames(out_200_75) <- c("cat", "windowLength", "overlap", "fileIndex", "start_stop" ,"zScore")

out_300_150 <- read.table('300_150.txt', sep = '\t')
colnames(out_300_150) <- c("cat", "windowLength", "overlap", "fileIndex", "start_stop" ,"zScore")

out_300_75 <- read.table('300_75.txt', sep = '\t')
colnames(out_300_75) <- c("cat", "windowLength", "overlap", "fileIndex", "start_stop" ,"zScore")

# plotting function
zScorePlot <- function (df, mainTitle){
  ggplot(df, aes(x=df$start_stop, y= df$zScore)) + geom_line() +
    labs(title=mainTitle,  x="Postion in alignment", y="z-score") + theme_bw() +
    geom_hline(yintercept=-2, linetype="dashed", color = "blue") + 
    geom_hline(yintercept=-4, linetype="dashed", color = "red") + 
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(breaks = c(0, -2 , -4))
}

zScorePlot(out_100_25, "Window length: 100 25")
zScorePlot(out_100_75, "Window length: 100, Overlap: 75")
zScorePlot(out_200_75, "Window length: 200, Overlap: 75")
zScorePlot(out_200_100, "Window length: 200, Overlap: 100")
zScorePlot(out_300_75, "Window length: 300, Overlap: 75")
zScorePlot(out_300_150, "Window length: 300, Overlap: 150")




       
       