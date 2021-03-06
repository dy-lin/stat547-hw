### THERE IS A BUG HERE
### START

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(dplyr)
library(readr)
library(stringr)
library(plotly)
library(mapproj)
library(lubridate)

  ## BUG: mapproj and lubridate was not loaded
  ## FIX: load the two packages using library(mapproj) and library(lubridate)

### END

# LOAD IN DATASETS
# read in data frames
df <- read_csv("data/crime_cleaned.csv", col_types = cols())
gdf <- read_csv("data/geo_fortified.csv", col_types = cols())

## FUNCTIONS
plot_filter <- function(df, year = NULL, neighbourhood = NULL, crime = NULL) {
  #' Filters the given database in order to wrange the database into the proper dataframe 
  #' required the graphs to display relevant information. Default value of NULL will allow 
  #' the maps to display every single data point. Given specific information will filter the 
  #' database
  #' 
  #' @param df Dataframe of crime data
  #' @param year Year or list of years of crime committed
  #' @param neighbourhood Neighbourhood or list of neighbourhoods where crime occurs 
  #' @param crime Crime or list of crimes commited
  #' @return  A filtered data frame of relevant information 
    filtered_df <- df
    if (!is.null(year)) {
        if (typeof(year) == 'list') {
            filtered_df <- filter(filtered_df, YEAR %in% seq(year[[1]], year[[2]]))
        }
        else {
            filtered_df <- filter(filtered_df, YEAR == year)
        }
    }
    if (!is.null(neighbourhood)) {
        if (length(neighbourhood) == 0) {
            neighbourhood = NULL
        }
        else if (typeof(neighbourhood) == 'list') {
            filtered_df <- filter(filtered_df, DISTRICT %in% neighbourhood)
        }
        else {
            filtered_df <- filter(filtered_df, DISTRICT == neighbourhood)
        }
    }
    if (!is.null(crime)) {
        if (length(crime) == 0) {
            crime = NULL
        }
        else if (typeof(crime) == 'list') {
            filtered_df <- filter(filtered_df, OFFENSE_CODE_GROUP %in% crime)
        }
        else {
            filtered_df <- filter(filtered_df, OFFENSE_CODE_GROUP == crime)
        }
    }
    return(filtered_df)
}

# mapping function based on all of the above
# CHOROPLETH FUNCTION
choro <- function(merged_df){
  #' Generates Boston neighbourhoods choropleth map
  #' 
  #' @param merged_df Wrangled dataframe to produce plot
  #' @return  Choropleth map
    merged_df <- merged_df %>% rename(Neighbourhood = DISTRICT)
    choro <- merged_df %>%
            ggplot(aes(label = Neighbourhood, text = paste('Neighbourhood: ', Neighbourhood, '<br> Count: ', Count))) +
             scale_fill_distiller(palette = "GnBu", direction  = 1) +
             geom_polygon(data = merged_df, aes(fill = Count, x = long, y = lat, group = group)) +
             theme_minimal() +
             labs(title = 'Crime Count by Neighbourhood', x = NULL, y = NULL, fill = "Crime Count") +
             theme(text = element_text(size = 14), plot.title = element_text(hjust = 0.5)) + 
             coord_map()
    choro <- ggplotly(choro, tooltip = 'text') %>% config(displayModeBar = FALSE)
    return(choro)

}

# HEATMAP FUNCTION
heatmap <- function(df) {
  #' Generates heatmap
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @return  Heatmap
  heatmap <- df %>%
              mutate(Day = factor(DAY_OF_WEEK, levels = c("Sunday", "Saturday", "Friday", "Thursday", "Wednesday", "Tuesday", "Monday"))) %>%
              mutate(Hour = factor(HOUR)) %>%
              ggplot(aes(x = Hour, y = Day, text = paste('Count: ', ..count..))) +
                geom_bin2d() +
                scale_fill_distiller(palette="GnBu", direction=1) +
                theme_minimal() +
                labs(title = 'Occurence of Crime by Hour and Day', x = "Hour of Day", y = "Day of Week", fill = "Crime Count") +
                theme(text = element_text(size = 14), plot.title = element_text(hjust = 0.5)) + 
                theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    heatmap <- ggplotly(heatmap, tooltip = c('y', 'x', 'text')) %>% config(displayModeBar = FALSE)
    return(heatmap)
}

# TREND PLOT FUNCTION
trendplot <- function(df){
  #' Generates line graph
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @return  Line graph

### THERE IS A BUG HERE
### START    
    trend <- df %>%
        mutate(Year = factor(YEAR)) %>%
        group_by(Year, MONTH) %>%
        summarise(Count = n()) %>%
        mutate(Month = make_date(year=0, month=MONTH)) %>%
        ggplot(aes(x = Month, y = Count)) +
          geom_line(aes(color = Year)) +
          scale_color_brewer(palette="Paired") +
          labs(title = 'Crime Trend', x = "Month", y = "Crime Count") +
          scale_x_date(date_labels = "%b") +
          theme_minimal()+
          theme(text = element_text(size = 14), plot.title = element_text(hjust = 0.5))       
      trend <- ggplotly(trend) %>% config(displayModeBar = FALSE)
      return(trend)
      
      ## BUG: in order to be interactive, it must be a ggplotly object returned
      ## FIX: change trend %>% config(...) to ggplotly(trend) %>% config
### END
}

# MAKE BAR PLOT 
crime_bar_plot <- function(df) {
  #' Generates bar chart
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @return  bar chart
    p <- df %>% 
        rename(
          CrimeType = OFFENSE_CODE_GROUP,
          Count = n
        ) %>%
        ggplot() + 
        geom_bar(aes(x = reorder(CrimeType, Count), y = Count, text = paste('Crime Type: ', CrimeType, '<br> Count: ', Count)), stat = "identity", fill = "#4682B4") +
        coord_flip() +
        xlab("Crime") + 
        ylab("Crime Count") +
        ggtitle("Crime Count by Type") +
        theme_minimal() +
        theme(text = element_text(size = 14), plot.title = element_text(hjust = 0.5))

    gp <- ggplotly(p, tooltip = 'text') %>% config(displayModeBar = FALSE)
    
    return(gp)
}

# MAKE CHOROPLETH FUNCTION
make_choropleth <- function(df, gdf, year = NULL, neighbourhood = NULL, crime = NULL) {
  #'  Wrapper function to filter data and make choropleth map
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @param gdf Geodataframe to produce plot
  #' @param year Year or list of years of crime committed
  #' @param neighbourhood Neighbourhood or list of neighbourhoods where crime occurs 
  #' @param crime Crime or list of crimes commited
  #' @return  Choropleth map
    inner_df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime) %>%
            group_by(DISTRICT) %>%
            summarize(Count = n()) %>%
            mutate(DISTRICT = str_replace(DISTRICT, "Downtown5", "Charlestown")) 
    # merge with geo data
    merged_df <- inner_join(gdf, inner_df, by = "DISTRICT")
    return(choro(merged_df))
}

# MAKE BAR DATAFRAME
make_bar_dataframe <- function(df, year = NULL, neighbourhood = NULL, crime = NULL){
  #'  Wrapper function to filter data and make bar chart
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @param year Year or list of years of crime committed
  #' @param neighbourhood Neighbourhood or list of neighbourhoods where crime occurs 
  #' @param crime Crime or list of crimes commited
  #' @return  Bar chart
  df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime) %>%
      group_by(OFFENSE_CODE_GROUP) %>%
      tally(sort = TRUE)
  top_ten <- df %>% head(10)
  return(crime_bar_plot(top_ten))
}

# MAKE HEATMAP FUNCTION
make_heatmap_plot <- function(df, year = NULL, neighbourhood = NULL, crime = NULL) {
  #'  Wrapper function to filter data and make heatmap
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @param year Year or list of years of crime committed
  #' @param neighbourhood Neighbourhood or list of neighbourhoods where crime occurs 
  #' @param crime Crime or list of crimes commited
  #' @return  Heatmap
    df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime)
    return(heatmap(df))
}
# MAKE TRENDPLOT FUNCTION
make_trend_plot <- function(df, year = NULL, neighbourhood = NULL, crime = NULL) {
  #'  Wrapper function to filter data and make line graph
  #' 
  #' @param df Wrangled dataframe to produce plot
  #' @param year Year or list of years of crime committed
  #' @param neighbourhood Neighbourhood or list of neighbourhoods where crime occurs 
  #' @param crime Crime or list of crimes commited
  #' @return  Line graph
    df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime)
    return(trendplot(df))
}

# YEAR RANGE SLIDER
yearMarks <- lapply(unique(df$YEAR), as.character)
names(yearMarks) <- unique(df$YEAR)

yearSlider <- dccRangeSlider(
  id = "year",
  marks = yearMarks,
  min = 2015,
  max = 2018,
  step = 4,
  value = list(2015, 2018)
)

# CRIME DROPDOWN
crime_key <- tibble(label = sort(unique(as.character(df$OFFENSE_CODE_GROUP))),
                   value = sort(as.character(unique(df$OFFENSE_CODE_GROUP))))

crimeDropdown <- dccDropdown(
  id = "crime",
  options = lapply(
    1:nrow(crime_key), function(i){
      list(label=crime_key$label[i], value=crime_key$value[i])
    }),
  value = sort(unique(df$OFFENSE_CODE_GROUP)),
  style=list(width='95%'),
  multi = TRUE
)

# NEIGHBOURHOOD DROPDOWN

neigbourhood_key <- tibble(label = sort(unique(as.character(df$DISTRICT))),
                   value = sort(as.character(unique(df$DISTRICT))))

neighbourhoodDropdown <- dccDropdown(
  id = "neighbourhood",
  options = lapply(
    1:nrow(neigbourhood_key), function(i){
      list(label=neigbourhood_key$label[i], value=neigbourhood_key$value[i])
    }),
  value = sort(unique(df$DISTRICT)),
  style=list(width='95%'),
  multi = TRUE
)

graph <- dccGraph(
  id = 'choro-map',
  figure = make_choropleth(df, gdf)
)
graph2 <- dccGraph(
  id = 'line-graph',
  figure = make_trend_plot(df)
)
graph3 <- dccGraph(
  id = 'heat-map',
  figure = make_heatmap_plot(df)
)
graph4 <- dccGraph(
  id = 'bar-graph',
  figure = make_bar_dataframe(df)
)

external_stylesheets = 'https://codepen.io/chriddyp/pen/bWLwgP.css'

app <- Dash$new(external_stylesheets = external_stylesheets) 


# colour dictionary
colors <- list(
  white = '#ffffff',
  light_grey = '#d2d7df',
  ubc_blue = "#082145"
)

app$layout(
  htmlDiv(
    list(
      htmlH2('Boston Crime Dashboard', 
             style = list( color = colors$white)),
      htmlP("This Dash app will allow users to explore crime in Boston across time and space. The data set consists of over 300,000 Boston crime records between 2015 and 2018. Simply drag the sliders to select your desired year range. Select one or multiple values from the drop down menus to select which neighbourhoods or crimes you would like to explore. These options will filter all the graphs in the dashboard.", 
      style = list( color = colors$white))), style = list(backgroundColor = colors$ubc_blue, 'padding' =  10)),
 htmlDiv(
 list(
   #  htmlP("This is a thing", style = list( color = colors$white)),
     htmlP("Filter by year", style = list(textAlign = 'center')),
     yearSlider, 
     htmlBr(),
     htmlBr(),
     htmlP("Filter by neighbourhood", style = list(textAlign = 'center')),
     neighbourhoodDropdown,
     htmlBr(),
     htmlP("Filter by crime", style = list(textAlign = 'center')),
     crimeDropdown,
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr()
     ), className = "two columns", style = list(backgroundColor = colors$light_grey, "margin-left"= "0px",
                                                "margin-top"= "0px", 'padding' =  20)),
 htmlDiv(
 list(
      graph, 
      graph2), className = "five columns")
,

htmlDiv(
 list(
      graph3, 
      graph4), className = "five columns"),

# FOOTER
htmlDiv(
  list(
    htmlP("This dashboard was made collaboratively by the DSCI 532 Group 202 in 2019."),
    dccLink('Data Source ', href='https://www.kaggle.com/ankkur13/boston-crime-data'),
    htmlBr(),
    dccLink('Github Repo', href='https://github.com/UBC-MDS/DSCI-532_gr202_r_dashboard')), 
      className =  "twelve columns", style = list(color = colors$ubc_blue, backgroundColor = colors$light_grey, padding  = 4))
      )
    
# add callback

app$callback(
  #update data of choropleth map
  output=list(id = 'choro-map', property='figure'),
  params=list(input(id = 'year', property='value'),
              input(id = 'neighbourhood', property='value'),
              input(id = 'crime', property='value')),
  function(year_value, neighbourhood_value, crime_value) {
    make_choropleth(df, gdf, year_value, neighbourhood_value, crime_value)
  })

app$callback(
  #update data of line graph
  output=list(id = 'line-graph', property='figure'),
  params=list(input(id = 'year', property='value'),
              input(id = 'neighbourhood', property='value'),
              input(id = 'crime', property='value')),
### THERE IS A BUG HERE
### START    
  function(year_value, neighbourhood_value, crime_value) {
    make_trend_plot(df, year_value, neighbourhood_value, crime_value)
  })

  ## BUG: The make_trend_plot() function takes its first argument the dataframe, which is missing
  ## FIX: change make_trend_plot(year_value, neighbourhood_value, crime_value) to make_trend_plot(df, year_value, neighbourhood_value, crime_value)
### END 

app$callback(
  #update data of heat map
  output=list(id = 'heat-map', property='figure'),
  params=list(input(id = 'year', property='value'),
              input(id = 'neighbourhood', property='value'),
              input(id = 'crime', property='value')),
  function(year_value, neighbourhood_value, crime_value) {
    make_heatmap_plot(df, year_value, neighbourhood_value, crime_value)
  })

app$callback(
  #update data of bar chart

### THERE IS A BUG HERE
### START    
  output=list(id = 'bar-graph', property='figure'),
  
  ## BUG: this callback is to update the bar chart, and not the heat map
  ## FIX: change the id = 'heat-map' to id = 'bar-graph'
### END
  params=list(input(id = 'year', property='value'),
              input(id = 'neighbourhood', property='value'),
              input(id = 'crime', property='value')),
  function(year_value, neighbourhood_value, crime_value) {
    make_bar_dataframe(df, year_value, neighbourhood_value, crime_value)
  })

### THERE IS A BUG HERE
### START 
app$run_server(host = "0.0.0.0", port = Sys.getenv('PORT', 8050))
  ## BUG: ports should be port
  ## FIX: change ports = to port = 
### END:
