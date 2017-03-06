library(xlsx)
library(stringr)
library(ggplot2)
library(maps)
library(tools)
# Minumum Wage Workers in the United States from https://www.graphiq.com/search/search?cid=1&query=crime
# Data from BLS Report Characteristics of Minimum Wage Workers, 2014, 
#       https://www.bls.gov/opub/reports/minimum-wage/archive/characteristics-of-minimum-wage-workers-2014.pdf

# downloaded pdf, converted to excel spreadsheet with Adobe

#bringing in spreadsheet

min_wage<-read.xlsx("laborminwage.xlsx", sheetName="Table 1", startRow=2, endRow=53, check.names=FALSE, stringsAsFactors = FALSE)
head(min_wage)


#create new data frame with data I want
percent_min_wage<-as.data.frame(cbind(min_wage$`State
Total, 16 years and olderâ€¦`, min_wage$`Percent At or be
Total
3.9`))

#clean up the data
#rename columns
colnames(percent_min_wage)<-c("region", "Percent At or Below")

#convert percentage column to numeric from factor
percent_min_wage$`Percent At or Below`<-as.character.numeric_version(percent_min_wage$`Percent At or Below`)
#clean up special characters in state column
percent_min_wage$region<- gsub("â€¦","", percent_min_wage$region)
percent_min_wage$region<-  str_replace_all(percent_min_wage$region, "[[:punct:]]", " ")
percent_min_wage$region<- trimws(percent_min_wage$region)

all_states <- map_data("state")
all_states$region<-toTitleCase(all_states$region)
head(all_states)
unique(all_states$region)

Total <- merge(all_states, percent_min_wage, by="region")
head(Total)

unique(Total$region)
pdf("min_wage.pdf", width=12, height=5)


p <- ggplot()
p <- p + geom_polygon(data=Total, aes(x=long, y=lat, group = group, fill=Total$`Percent At or Below`),colour="white"
) + scale_fill_continuous(low = "lightgreen", high = "darkgreen", guide="colorbar")
P1 <- p + theme_bw()  + labs(fill = "Minimum Wage Workers in the United States" 
                             ,title = "Hourly Workers Paid Federal Minum Wage or Below", x="", y="")
P1 + scale_y_continuous(breaks=c()) + scale_x_continuous(breaks=c()) + theme(panel.border =  element_blank())

dev.off()
