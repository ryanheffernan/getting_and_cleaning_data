## Tidying the UCI HAR Dataset
_Week 4 Project for "Getting and Cleaning Data" offered by Johns Hopkins University on Coursera_

### Repository Contents
File or Directory | Description
------------------|------------
UCI HAR Dataset/ | Original raw dataset 
tidy_dataset/ | Tidied dataset 
CodeBook.md | Code Book describing the tidy dataset
run_analysis.R | Script to product the tidy dataset from the raw dataset
read_tidy_data.R | Example script to read the tidy dataset into an R data.table

### Running the Code

1. Clone the repo

    ```
    git clone git@github.com:ryanheffernan/getting_and_cleaning_data.git
    ```
    
1. Execute the R script from the root of the repo

    ```
    cd getting_and_cleaning_data
    Rscript run_analysis.R
    ```