library(rgdal)  
library(ggplot2)
require(maptools)
require(plyr)
library(svglite)

# First read in the shapefile
china = readOGR(dsn=("./china_shapefile/"), layer="bou2_4p")

# Clean the data, then fortify to a df
china@data$id = rownames(china@data)
china.points = fortify(china, region="id")
china.df = join(china.points, china@data, by="id")

# Dont draw the islands in south china sea
china.df = subset(china.df, AREA > 0.005)

map = ggplot(china.df, aes(x=long, y=lat, group=group)) + 
             geom_polygon(fill="white") +
             geom_path(color="gray", size=0.2) +
             coord_map()

# Load the student info
raw_df = read.csv("deanlist_2017_fall.csv", header=TRUE)

# Count the frequency of each city, remove duplicates
city_df = raw_df[c("city", "lat", "long")]
city_df = unique(ddply(city_df,.(city, lat, long),nrow))
colnames(city_df) = c("city", "lat", "long", "count")
head(city_df)

# Standard plot the map, then save to a svg file
plot1 = map + geom_point(data = city_df, aes(x=long, y=lat, size=count), 
                         inherit.aes=FALSE, shape=21, stroke=0, 
                         colour="white", fill="red", alpha=0.3) +
              scale_size_continuous(name = "Counts", range = c(1, 25)) + 
              labs(title = "Chinese students on Dean's List") +
              xlab("Longitude") + ylab("Latitude") + 
              theme(plot.title = element_text(size=22),
                    axis.title = element_text(size=18),
                    legend.title = element_text(size=18))
ggsave("plot1.svg", plot = plot1, device = "svg",
        scale = 1, width = 9, height = 9, units = "in")
ggsave("plot1.png", plot = plot1, device = "png",
        scale = 1, width = 9, height = 9, units = "in", dpi = 300)

# Plot without background and legends, etc.
plot2 = ggplot(china.df, aes(x=long, y=lat, group=group)) + 
        geom_polygon(fill="white") +
        geom_path(color="gray", size=0.3) +
        coord_map() +
        geom_point(data = city_df, aes(x=long, y=lat, size=count), 
                         inherit.aes=FALSE, shape=21, stroke=0, 
                         colour="white", fill="red", alpha=0.3) +
        scale_size_continuous(name = "Counts", range = c(1, 25)) +
        theme(axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              legend.position="none",
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              plot.background=element_blank())
ggsave("plot2.svg", plot = plot2, device = "svg",
        scale = 1, width = 9, height = 9, units = "in")
