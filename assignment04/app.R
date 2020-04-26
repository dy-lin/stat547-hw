# author: Diana Lin
# date: 2020-03-15

"This script is the main file that creates a Dash app.

Usage: app.R
"

# Libraries

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(scales)
library(purrr)

app <- Dash$new()

# Load the diamond dataset
library(tidyverse)
diamonds <- diamonds

# create an options list based on clarity
clarity <- levels(diamonds$clarity)
dropdown <- map(seq_along(clarity), function(i) list(label=clarity[i], value=clarity[i]))

# create a named list of the cuts, where name is the number level, and values are the string
cut <- levels(diamonds$cut)
slider <- seq_along(cut)

slider_labels <- map(cut, function(x) x)
names(slider_labels) <- slider

# create the ggplots
histogram <- diamonds %>%
  ggplot(aes(x = price)) +
  geom_histogram() +
  labs(y = "Number of Diamonds", x = "Price") +
  scale_x_continuous(labels = dollar)

histogram <- ggplotly(histogram)

trend <- diamonds %>%
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot() +
  labs(x = "Cut", y = "log(Price)") +
  scale_y_continuous(labels = dollar, trans = 'log10')

trend <- ggplotly(trend)

# assign components
heading1 <- htmlH1("Hello")
heading3 <- htmlH3("This is a subheading.")
bold_link <- dccMarkdown("These are **all** the [dogs](https://dy-lin.github.io/dogs/) in my life.")
italics <- dccMarkdown("Here is a photo of _my_ dog:")
static_photo <- dccMarkdown("![](https://github.com/dy-lin/dogs/raw/master/dogs/cropped/Dumpling-small.png)")
dropdown_menu <- dccDropdown(options = dropdown)
quality_slider <- dccSlider(
  min = min(slider),
  max= max(slider),
  marks = slider_labels,
  value = 3
)
plot1 <- dccGraph(id = 'hist', figure = histogram)
plot2 <- dccGraph(id = 'trend', figure = trend)

app$layout(
	htmlDiv(
		list(
		  heading1,
		  
			heading3,
			
			bold_link,
			
			italics,
			
			static_photo,
			
			dropdown_menu,
			
			quality_slider,
			
			plot1,

			plot2
		)
	)
)

app$run_server(debug=TRUE)