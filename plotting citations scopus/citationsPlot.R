require(ggplot2)
require(lattice)

setwd("C:/Users/Lewan/Documents/MATLAB/Modeling/Replication market/plotting citations scopus")
#Downloaded first 2,000 (i.e. most recent first) for each journal on 11/4/2018  
scopusdata<-rbind(cbind(read.csv("scopusPS.csv"),journal="Psychological Science"),
                  cbind(read.csv("scopusPR.csv"),journal="Psychological Review"),
                  cbind(read.csv("scopusJEPGEN.csv"),journal="JEP:General"),
                  cbind(read.csv("scopusLMC.csv"),journal="JEP:LMC"))

#this is 2,000 from 2014 only
scopuspsych <- read.csv("scopusPsych.csv")


x11()
histogram(~Cited.by,data=subset(scopuspsych,Cited.by<150))
forclip <- subset(scopuspsych, Cited.by<500)$Cited.by
write.table(forclip[!is.na(forclip)], "clipboard",row.names=FALSE, col.names = FALSE)

x11()
histogram(~Cited.by|journal,data=subset(scopusdata,Cited.by<500))

aggregate(Cited.by~journal,data=scopusdata,FUN=mean)

forclip <- subset(scopusdata,journal=="Psychological Science" & Cited.by<500)$Cited.by
 
write.table(forclip[!is.na(forclip)], "clipboard",row.names=FALSE, col.names = FALSE)

plot1<-ggplot(scopusdata, aes(x=Cited.by))  + 
  geom_histogram(colour="#535353", fill="#84D5F0", binwidth=2) +
  xlab("Number of Citations") + ylab("Number of Articles")  + 
  ggtitle("Citation Data for Psychological Science 2011-2015") +
  coord_cartesian(xlim = c(-5, 250))
plot1

#Plot by year
plot1 + facet_grid(Year ~ .)

#Calculate median citation rate per year
aggregate((scopusdata$Cited.by), by=list(Category=scopusdata$Year), FUN=median, na.rm=TRUE)
#Calculate mean citation rate per year
aggregate((scopusdata$Cited.by), by=list(Category=scopusdata$Year), FUN=mean, na.rm=TRUE)

#Sum never cited journal articles per year (Scopus codes 0 citations as NA)
aggregate((is.na(scopusdata$Cited.by)), by=list(Category=scopusdata$Year), FUN=sum)