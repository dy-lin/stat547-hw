# Layout example for DashR
# This layout includes two basic plots next to each other, two dropdown boxes, a title bar, and a sidebar
# Author: Matthew Connell
# Date: February 2020

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(scales))
library(glue)

clarity <- levels(diamonds$clarity)
dropdown <- map(seq_along(clarity), function(i) list(label=clarity[i], value=clarity[i]))
cut <- levels(diamonds$cut)
slider <- seq_along(cut)

slider_labels <- map(cut, function(x) x)
names(slider_labels) <- slider

# Define Plot functions
make_histogram <- function(choice = 'None', yaxis = 'linear') {
  if (!choice %in% clarity) {
    filtered <- diamonds
  } else {
    filtered <- diamonds %>%
      filter(clarity == choice)
  }
  
  p1 <- filtered %>%
    ggplot(aes(x = price)) +
    geom_histogram() +
    labs(y = "Number of Diamonds", x = "Price") +
    scale_x_continuous(labels = dollar) +
    theme_bw()
  
  if (!choice %in% clarity) {
    p1 <- p1 + ggtitle(glue("Histogram: Price Distribution of All Diamonds"))
  } else {
    p1 <- p1 + ggtitle(glue("Histogram: Price Distribution of {choice} Clarity Diamonds"))
  }
  
  if (yaxis == 'log') {
    p1 <- p1 + scale_y_continuous(trans = 'log10') +
      ylab("Number of Diamonds (log)") 
  }
  
  ggplotly(p1)
  
}

make_boxplot <- function(choice = 1) {
  p2 <- diamonds %>%
    filter(cut %in% slider_labels[1:choice]) %>%
    ggplot(aes(x = clarity, y = price)) +
    geom_boxplot(alpha = 0.01) +
    labs(x = "Clarity", y = "Price") +
    scale_y_continuous(labels = dollar) +
    theme_bw()
  
  if (choice == 1) {
    p2 <- p2 + ggtitle(glue("Boxplot: Pricing of Clarity for {slider_labels[1]} Cut Diamonds"))
  } else {
    p2 <- p2 + ggtitle(glue("Boxplot: Pricing of Clarity for {slider_labels[1]} to {slider_labels[choice]} Cut Diamonds"))
  }
  
  ggplotly(p2)
  
}

make_scatterplot <- function(choice = 1) {
  
  p3 <- diamonds %>%
    filter(cut %in% slider_labels[1:choice]) %>%
    ggplot(aes(x = carat, y = price, color = cut)) +
    geom_point(alpha = 0.1) +
    labs(x = "Number of Carats", y = "Price") +
    scale_y_continuous(label = dollar) +
    theme_bw()
  
  if (choice == 1) {
    p3 <- p3 + ggtitle(glue("Scatterplot: Pricing of Carats for {slider_labels[1]} Cut Diamonds"))
  } else {
    p3 <- p3 + ggtitle(glue("Scatterplot: Pricing of Carats for {slider_labels[1]} to {slider_labels[choice]} Cut Diamonds"))
  }
  
  ggplotly(p3)
}
# Assign components

title <- htmlH1("Diamonds")
authors <- htmlH3("By Diana Lin")
intro <- dccMarkdown("The `diamonds` dataset contains the prices and other attributes of almost 54,000 diamonds. This data frame has 53,940 rows and 10 variables. The variables are as follows:")
table <- dccMarkdown("
                     Variable | Description
                     ---------|-----------------
                     price | price in US dollars ($326 - $18,823)
                     carat | weight of the diamond (0.2 - 5.01)
                     cut | quality of the cut (Fair, Good, Very Good, Premium, Ideal
                     colour | diamond colour, from D (best) to J (worst)
                     clarity | a measurement of how clear the diamond is, from I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, to IF (best)
                     x | length in mm (0 - 10.74)
                     y | width in mm (0 - 58.9)
                     z | depth in mm (0 - 31.8)
                     depth | total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43 - 79)
                     table | width of top of diamond relative to widest point (43 - 95)")

dropdown_menu <- dccDropdown(id = 'dropdown', options = dropdown, value = 'None')
quality_slider <- dccSlider(id = 'slider',
  min = min(slider),
  max= max(slider),
  marks = slider_labels,
  value = 1
)
histogram <- dccGraph(id = 'histogram', figure = make_histogram())
boxplot <- dccGraph(id = 'boxplot', figure = make_boxplot())
scatterplot <- dccGraph(id = 'scatterplot', figure = make_scatterplot())

radio_buttons <- dccRadioItems(id = 'radio',
                               options = list(
                                 list(label = 'Linear', value = 'linear'),
                                 list(label = 'Log', value = 'log')
                               ), value = 'linear')

# Set an external stylesheet for CSS
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")


header <- htmlDiv(
  list(
    title
  ), style = list('columnCount'=1, 
                  'background-color'= '#AF33FF', 
                  'color'='white',
                  'text-align' = 'center'
                  )
)

intro <- htmlDiv(
  list(
    authors,
    intro,
    htmlDiv(
      list(
        table
      ), style = list('display' = 'flex', 'justify-content' = 'center')
    ),
    htmlBr()
  ), style = list('text-align' = 'center')
)

dropdown_wlabels <- htmlDiv(
  list(
    htmlLabel("Select the clarity of diamonds for the histogram:"),
    dropdown_menu
  ), style = list('margin' = 10)
)

radio_wlabels <- htmlDiv(
  list(
    htmlLabel("Select the y-axis scale for the histogram:"),
    radio_buttons
  ), style = list('margin' = 10)
)

slider_wlabels <- htmlDiv(
  list(
    htmlLabel("Use the slider to select the cuts of the diamonds for the boxplot and scatter plot:"),
    quality_slider,
    htmlBr(),
    dccMarkdown("**Note**: The colour additions in the scatterplot take a few seconds to load due to the large dataset being shown.")
  ), style = list('margin' = 10)
)
sidebar_title <- htmlDiv(
  list(
    htmlH3("Sidebar")
  ), style = list('text-align' = 'center')
)

slider_table <- htmlDiv(
  list(
    dccMarkdown("
                Slider Value | Cuts Shown
                -------------|-------------------
                Fair | **Fair**
                Good | Fair, **Good**
                Very Good | Fair, Good, **Very Good**
                Premium | Fair, Good, Very Good, **Premium**
                Ideal | Fair, Good, Very Good, Premium, **Ideal**")
  ), style = list('display' = 'flex', 'justify-content' = 'center')
)

sidebar <- htmlDiv(
  list(
    dropdown_wlabels,
    radio_wlabels,
    slider_wlabels,
    slider_table
  ), style = list('display' = 'flex',
                  'flex-direction' = 'column',
                  'height' = '100%',
                  'margin' = 10,
                  'justify-content' = 'space-around')
)

sidebar_total <- htmlDiv(
  list(
    sidebar_title,
    sidebar
  ), style = list('display' = 'flex', 'flex-direction' = 'column', 'background-color' = '#F1EFF1', 'width = 30%')
)

plots <- htmlDiv(
  list(
    histogram,
    boxplot,
    scatterplot
  ), style = list('width' = '100%')
)

bottom_half <- htmlDiv(
  list(
    sidebar_total,
    plots
  ), style = list('display' = 'flex', 'justify-content' = 'space-around')
)

# Start the layout
app$layout(
  header,
  intro,
  bottom_half
)


app$callback(
  output = list(id = 'histogram', property='figure'),
  params = list(input(id = 'dropdown', property = 'value'),
                input(id = 'radio', property = 'value')),
  function(clarity,yaxis) {
    make_histogram(clarity,yaxis)
  }
)


app$callback(
  output = list(id = 'scatterplot', property = 'figure'),
  params = list(input(id = 'slider', property='value')),
  function(cut) {
    make_scatterplot(cut)
  }
)

app$callback(
  output = list(id = 'boxplot', property='figure'),
  params = list(input(id = 'slider', property='value')),
  function(cut) {
    make_boxplot(cut)
  }
)


app$run_server(debug = TRUE)