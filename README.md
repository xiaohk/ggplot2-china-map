# China Map with ggplot2
This project demonstrates how to use `ggplot2` to plot a non-built-in map using the shapefile.

## Plot the map
The plot process is fairly straightforward. We can load the shapefile (in `china_shapefile`) using `readOGR()`. Then we fortify it to a normal dataframe. We can modify the dataframe if needed. For this project I ignored islands in the South China Sea, since there are no students on the list from there. Next, we use `geom_polygon` layer to plot the map, and add `coord_map` to make it looks pretty. Finally we can add other standard data layer onto the map, using the geometrical coordinates as aesthetic mapping. 

The process is done in `plot_china.r`.

[<img src="./plot1.svg" width="400">](./plot1.svg)[<img src="./plot2.svg" width="400">](./plot2.svg)

## Data Processing

For this specific project, data are parsed from the [UW-Madison’s Dean’s List of 2017 Spring](https://dataviz.wisc.edu/views/UW-MadisonDeansList/ListDashboard?:iid=1&:isGuestRedirectFromVizportal=y&:embed=y). My data include all students from mainland China, Hong Kong and Taiwan. The cleaned file is stored as `deanlist_2017_fall.csv`, and the cleaning process is in `data_cleaning.ipynb`.

## China city coordinates
To plot the cities on the map, I parsed a simple JSON file of Chinese city coordinates. 

This JSON file includes over 300 major cities in China. The main key is the English name of one, and value is another dictionary containing its Chinese name and coordinates (latitude, longitude). 

```javascript
{
	"kelamayi": {
		"coord": [
			45.5943,
			84.8812
		],
		"hanzi": "克拉玛依市"
	},
	"kezileisu": {
		"coord": [
			39.7503,
			76.1376
		],
		"hanzi": "克孜勒苏柯尔克孜自治州"
	},
	"kunming": {
		"coord": [
			25.0492,
			102.7146
		],
		"hanzi": "昆明市"
	}
}
```

To make the JSON file more generic, I also added some alias of keys. For example, `xianggang` and `hongkong`, `xian` and `xi'an`, `kelamayi` and `karamay`, etc.