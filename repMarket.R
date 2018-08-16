# analyze replication market results
library(plyr)
library(dplyr)

setwd("C:/Users/Lewan/Documents/MATLAB/Modeling/Replication market")
rm <- read.table("resultsSimfake.dat")
names(rm) <- c('phack','gain','typeI','power','nTotExptsPrivRep','nPrivRealInterestEffs','nPrivRealInterestTrueEffs',
               'nTotExptsPubRep','nPubRealInterestEffs','nPubRealInterestTrueEffs')

#first plot error rates in initial exploration (before replication)
#this shows effects of p-hacking
g5 <- filter(rm,gain==5) #identical for all levels of gain (no decision being made about replication)
x11()
plot(g5$phack,g5$typeI,ylim=c(0,.3),xlab="p-Hacking (batch size)", ylab="Type I/II error rate",las=1,type="l")
points(g5$phack,g5$typeI,pch=21,bg="red",cex=2)
lines(g5$phack,1-g5$power)
points(g5$phack,1-g5$power,pch=21,bg="black",cex=2)
abline(h=.05,lty="dashed")
legend (5,.25,c("Type I","Type II"),pch=21,pt.cex=2,pt.bg=c("red","black"),lty="solid")

for (g in c(0,1,10)) {
  g5 <- filter(rm,gain==g)
  x11()
  ul <- max(g5$nTotExptsPrivRep+2)
  ll <- min(95, g5$nTotExptsPubRep-2)
  plot(g5$phack,g5$nTotExptsPrivRep,ylim=c(ll,ul),xlab="p-Hacking (batch size)", ylab="Number of experiments conducted",
       las=1,type="l")
  points(g5$phack,g5$nTotExptsPrivRep,pch=21,bg="red",cex=2)
  lines(g5$phack,g5$nTotExptsPubRep)
  points(g5$phack,g5$nTotExptsPubRep,pch=21,bg="blue",cex=2)
  abline(h=100,lty="dashed")
  #text(5,ul-2,paste("g=",as.character(g),sep=""),cex=2)
  title(main=paste("g=",as.character(g),sep=""),cex=2)
  legend(4,ul-10,c("Private replication","Public replication"),pch=21,pt.bg=c("red","blue"),lty="solid",pt.cex=2)
  
  x11()
  ul2 <- max(10, max(g5$nPrivRealInterestEffs,g5$nPubRealInterestEffs))
  plot(g5$phack,g5$nPrivRealInterestTrueEffs,ylim=c(0,ul2),xlab="p-Hacking (batch size)", 
       ylab="Number of interesting (true) effects revealed",
       las=1,type="l")
  points(g5$phack,g5$nPrivRealInterestTrueEffs,pch=21,bg="red",cex=2)
  lines(g5$phack,g5$nPubRealInterestTrueEffs)
  points(g5$phack,g5$nPubRealInterestTrueEffs,pch=21,bg="blue",cex=2)
  
  lines(g5$phack,g5$nPrivRealInterestEffs,lty="dashed")
  points(g5$phack,g5$nPrivRealInterestEffs,pch=22,bg="red",cex=1.5)
  lines(g5$phack,g5$nPubRealInterestEffs,lty="dashed")
  points(g5$phack,g5$nPubRealInterestEffs,pch=22,bg="blue",cex=1.5)
  #text(5,ul2,paste("g=",as.character(g),sep=""),cex=2)
  title(main=paste("g=",as.character(g),sep=""),cex=2)
  abline(h=9,lty="dashed")
  legend(3,7,c("True effects private replication","True effects public replication",
               "Interesting effects private replication","Interesting effects public replication"),
         pch=c(21,21,22,22),pt.bg=c("red","blue","red","blue"),lty=c("solid","solid","dashed","dashed"),pt.cex=2)
}