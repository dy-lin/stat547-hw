# Assignment 3

## Submission

- [x] Submit a link to the issue providing feedback you created on GitHub
- [x] In your README for assignment03, please include a link to the issue you created.
- [x] For your canvas submission, you should submit a link to the issue you created on GitHub.com (and not this repository)

## Task 1: Set Up

- [x] Locally, clone the repository for the project you are reviewing
2In the repo README, find the instructions on how to reproduce all the analysis and a draft of the final report 
- [x] Try to reproduce the analysis and a draft of the final report from start to finish (look for the `USAGE` section)
- [x] Actually *run* the scripts on your computer using the commands they suggest and ensure the plots, data files, and final reports are correctly generated

## Task 2: Read through the EDA Rmd and the draft final report and provide feedback

> - [x] suggest things that you think are good/interesting/relevant about their project

- As a suggestion, I would recommend you use `suppressMessages(library(tidyverse))` to suppress these messages so that they are not printed to the console:
  ```
    ── Attaching packages ────────────────────────────── tidyverse 1.3.0 ──
  ✓ ggplot2 3.3.0     ✓ purrr  0.3.3
  ✓ tibble  2.1.3     ✓ dplyr  0.8.5
  ✓ tidyr   1.0.2     ✓ stringr 1.4.0
  ✓ readr   1.3.1     ✓ forcats 0.5.0
  ── Conflicts ───────────────────────────────── tidyverse_conflicts() ──
  x dplyr::filter() masks stats::filter()
  x dplyr::lag()    masks stats::lag()
  ```

- Additionally, I believe you use the package `readxl` in `scripts/load.R`  but it is not listed on the required packages:
  ```
  2. Ensure the following packages are installed:
    - ggplot2
    - dplyr
    - tidyverse
    - stringr
    - purrr
    - here
    - janitor
    - docopt
  ```

- You can use `dir.exists()` function 'test check' before using `create.dir()` in `scripts/load.R` so that no warning message is printed to console:
  
  ```
  Warning message:
  In dir.create("images") : 'images' already exists
  ```

- since you have loaded the entire `tidyverse` package, I would recommend that you use `read_csv()` and `write_csv()` instead of the baseR options `read.csv()` and `write.csv()`
  - with either option you choose, remember to be consistent
  - currently, only `read.csv()` is used in `scripts/clean.r` and `scripts/EDA.r`, while `scripts/load.R` uses `write_csv()` but `scripts/clean.r` uses `write.csv()`
  - I personally prefer `read_csv()` and `write_csv()` as they have more intuitive defaults, such as `read_csv(col_names = TRUE)`, etc. 
---
> - [x] Is the repository organized in a useful and sensible way?

- Yes, the repository is organized in the conventional structure of `scripts`, `images`, `docs` and `data`

---
> - [x] Is there a `Usage` section in the README?

- Yes, there is a `Usage` section in the `README.md`
- However, you need to make sure that the names of your scripts are correct-- your file names are actually `scripts/EDA.R` and `scripts/clean.R` where the file extension is a captial `.R` instead of a lowercase `.r`
- I would also suggest that you take advantage of the markdown syntax of a `README` file, where you can put code in a code block like below, by using enclosing the whole code snippet in [three backticks](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#code):
    ```
    Rscript scripts/clean.r
    ```
- The same goes for using inline code. Your required package list could look more clear as packages if you employ inline code. I think it is good practice to use inline code for filenames, packages, etc. to distinguish from regular text:

> 2. Ensure the following packages are installed:
  > - `ggplot2`
  > - `dplyr`
  > - `tidyverse`
  > - `stringr`   
  > - `purrr`
  > - `here`
  > - `janitor`
  > - `docopt`

---
> - [x] Do the scripts run to completion as described in the README?

- The scripts run to completion as described in the README, but even though it runs on my machine with mismatching script file names (see above), I would recommend that you be consistent-- on my Mac it runs fine as most of the commands are not case-sensitive, but there may be issues if running on a Windows or Linux machine that you may be unaware of
- Running `scripts/load.R`:

  ```
  [ dianalin@dlin: ~/STAT547/group05 ] $ Rscript scripts/load.R   'https://ndownloader.figshare.com/files/18543320?private_link=74a5ea79d76ad66a8af8'
  ── Attaching packages ────────────────────────────── tidyverse 1.3.0 ──
  ✓ ggplot2 3.3.0     ✓ purrr  0.3.3
  ✓ tibble  2.1.3     ✓ dplyr  0.8.5
  ✓ tidyr   1.0.2     ✓ stringr 1.4.0
  ✓ readr   1.3.1     ✓ forcats 0.5.0
  ── Conflicts ───────────────────────────────── tidyverse_conflicts() ──
  x dplyr::filter() masks stats::filter()
  x dplyr::lag()    masks stats::lag()
  here() starts at /Users/dianalin/STAT547/group05
  Warning message:
  In dir.create("data") : 'data' already exists
  trying URL 'https://ndownloader.figshare.com/files/18543320? private_link=74a5ea79d76ad66a8af8'
  Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 5485394 bytes (5.2 MB)
  ==================================================
  downloaded 5.2 MB

  [1] "This script works!"
  ```

- Running `scripts/clean.r`:

  ```
  [ dianalin@dlin: ~/STAT547/group05 ] $ Rscript scripts/clean.r
  ── Attaching packages ────────────────────────────── tidyverse 1.3.0 ──
  ✓ ggplot2 3.3.0     ✓ purrr  0.3.3
  ✓ tibble  2.1.3     ✓ dplyr  0.8.5
  ✓ tidyr   1.0.2     ✓ stringr 1.4.0
  ✓ readr   1.3.1     ✓ forcats 0.5.0
  ── Conflicts ───────────────────────────────── tidyverse_conflicts() ──
  x dplyr::filter() masks stats::filter()
  x dplyr::lag()    masks stats::lag()

  Attaching package: ‘janitor’

  The following objects are masked from ‘package:stats’:

      chisq.test, fisher.test

  here() starts at /Users/dianalin/STAT547/group05
  Warning message:
  funs() is soft deprecated as of dplyr 0.8.0
  Please use a list of eitherfunctions or lambdas:

    # Simple named list:
    list(mean = mean, median = median)

    # Auto named with `tibble::lst()`:
    tibble::lst(mean, median)

    # Using lambdas
    list(~ mean(., trim = .2), ~ median(., na.rm = TRUE))
  This warning is displayed once per session.
  [1] "Data cleaning is complete!"
  ```

- Running `scripts/EDA.r`:

  ```
  [ dianalin@dlin: ~/STAT547/group05 ] $ Rscript scripts/EDA.r
  ── Attaching packages ────────────────────────────── tidyverse 1.3.0 ──
  ✓ ggplot2 3.3.0     ✓ purrr  0.3.3
  ✓ tibble  2.1.3     ✓ dplyr  0.8.5
  ✓ tidyr   1.0.2     ✓ stringr 1.4.0
  ✓ readr   1.3.1     ✓ forcats 0.5.0
  ── Conflicts ───────────────────────────────── tidyverse_conflicts() ──
  x dplyr::filter() masks stats::filter()
  x dplyr::lag()    masks stats::lag()
  here() starts at /Users/dianalin/STAT547/group05
  Warning message:
  In dir.create("images") : 'images' already exists
  [1] "Exploratory Data Analysis complete!"
  ```

---
> - [x] Do the scripts produce the expected output?

- Yes! Running `scripts/load.R` successfully produced:
  - `data/survey_raw.csv`

- Running `scripts/clean.r` successfully produced:
  - `data/survey_data.csv`

- Running `scripts/EDA.r` successfully produced:
  - `images/satisfaction_v_work_life_bal.png`
  - `images/satisfaction_v_supervis_relationship.png`
  - `images/basic_demographics.png`

---
> - [x] Are the scripts and functions appropriately documented?

- Regarding `scripts/load.R`:
  ```
  "This script takes in a data file and exports a csv in the data folder.

  Usage: scripts/load.R <url_to_read>" -> doc
  ```

  - this script does not 'take in' a data file, so the script documentation is incorrect-- this script takes in a URL to a data file, and exports it as a csv in the data folder.
  -  each line of the script is well document with comments

- Regarding `scripts/clean.r`:
  - the criteria for this script was to:

  > - Have at least TWO command-line arguments (at minimum, you may have more as well)
  > - Take in the path to the raw data (in the data folder) as a command-line argument
  > - Take in the filename to where the wrangled data should be saved as a command-line argument

  - there are no command line arguments taken in by this script, and therefore there is no documentation for the script
  - however, each line of the script is well documented with comments

- Regarding `scripts/EDA.r`:
  - the criteria for this script was to:

  > - Take in a path where exported images should be saved (likely images) as a command-line argument

  - this script does not take in any command line arguments and therefore lacks script documentation
  - however, each line of the script is well documented with comments

---
> - [x] Does it take a long time for the analysis to run? Are there tasks that could be vectorized to make things faster?

- the scripts do not take long to run! 
- however, in `scripts/EDA.r`, the package `purrr` is loaded but never used

---
> - [x] Are the research questions appropriate and well-chosen? 

- Yes, you picked a very interesting topic, one that is relevant to almost all students in the class as we are mostly graduate students
- I will be very interested to see your final results!

---
> - [x] Are the visualizations effectively displayed? How can they be improved?

- all plots should have titles (`labs(title = )`)
- I think the plots should be able to stand on their own, so for `images/satisfaction_v_supervis_relationship.png` and `images/satisfaction_v_work_life_bal.png`, you should use a figure caption or a subtitle (`labs(caption = , subtitle = )`) to define the scale-- it is unclear just by looking whether satisfaction is highest at 1, or highest at 5
- I like the use of `geom_point(position = "jitter")` for the `images/satisfaction_v_supervis_relationship.png` and `images/satisfaction_v_work_life_bal.png`
- I like the use of `alpha` in `images/satisfaction_v_supervis_relationship.png` and `images/satisfaction_v_work_life_bal.png`

---
> - [x] Are there other, more effective visualizations that could or should be used?

- I think it could be beneficial to scale the supervisor/work-life balance satisfaction that is 1-7 to the same as satisfaction PhD (1-5). If the scales are the same, it would be very easy to see if there is a correlation
- the y-axis is missing a closing parenthesis `)` in `images/satisfaction_v_supervis_relationship.png`

## Other Criteria
- [x] 200-300 words
- [x] can be point form but make sure it's complete
