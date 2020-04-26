# Assignment 4

## Task 1: Run the app (40%)
- [x] Open a Terminal window (RStudio or system)
- [x] Navigate to the appropriate folder using: `cd path/to/your/file/app.R`
- [x] Type `Rscript app.R`
- [x] You will see a message similar to:
  ```
  Fire started at 127.0.0.1:8050
  start: 127.0.0.1:8050
  ```
- [x] Copy the address (numbers after start) and paste them into a browser window.
- [x] Make sure the app works as you expect and displays the “Hello ” header.

### Grading for Task 1
- [x] 30 points: TA was able to run the app without errors.
- [x] 15 points: TA was able to run the app with a few minor fixes to the code.
- [x] 0 points: TA was not able to run the app, or major fixes were required.

## Task 2: Add components (50%)

### Task 2.1 - Add a heading and a subheading component (5 points)
- [x] Add an HTML H1-level header
- [x] Add an HTML H3-level header

### Task 2.2 - Add a Markdown component (you can still fill it with random text [from here](https://www.lipsum.com/)) (5 points)
- [x] Add a markdown component that includes the following things:
  - [x] Add a link
  - [x] Add some **bolded** text
  - [x] Add some _italic_ text
  - [x] Add a static image referencing an image in your repo or a URL (make sure you have permission to use the image).
  
### Task 2.3 - Add a dropdown component (10 points)
- [x] Add a dropdown component that corresponds to the `clarity` column of the `diamonds` dataframe
- [x] There should be no repeats in the dropdown options
- [x] It is not required to link your dropdown to the graph component in Task 2.5 (you will do this in assignment 5 next week).
  
### Task 2.4 - Add a slider component with labels at each point (10 points)
- [x] Add a slider component that corresponds to the `cut` column of the `diamonds` dataframe
- [x] The labels on the slider should correspond to the quality of the cut (Fair, Good, Very Good, Premium, Ideal).
- [x] There should be no repeats in the slider options.
- [x] It is not required to link your slider to the graph component in Task 2.5 (you will do this in assignment 5 next week)

### Task 2.5 - Add two graph components using ggplot and ggplotly (20 points)
- [x] Using `ggplot`, create a histogram of the diamond price on the x-axis and number of diamonds on the y-axis
- [x] Using `ggplot`, create a second plot (of your choice)
- [x] Create a `ggplotly` object by passing the `ggplot` object into the `ggplotly` function (from the `plotly` library)
- [x] Add two graph components using the ggplotly objects you created

### General 
- [x] After you have included all the components, run the app again and make sure it runs! If it does not, you will lose marks not just in this task, but also in Task 1!

## Task 3: Complete project reflection document (10%)
- [x] Complete the [teamwork reflection document](https://stat545.stat.ubc.ca/evaluation/teamwork/) for your project project so far
- [x] You will find the `Rmd` [file](teamwork.Rmd) that you need to fill out in your assignment repo
- [x] DO NOT FORGET to also rate yourself for each question