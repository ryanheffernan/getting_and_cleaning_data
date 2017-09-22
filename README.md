## Tidying the UCI HAR Dataset
_Week 4 Project for "Getting and Cleaning Data" offered by Johns Hopkins University on Coursera_

### Repository Contents
File or Directory | Description
------------------|------------
original_dataset/ | Original raw dataset 
tidy_data.txt | Tidied dataset 
CodeBook.md | Code Book describing the tidy dataset
CodeBookTemplate.md | Template for the Code Book
generate_codebook.R | Script to generate the Code Book from the Code Book Template and tidy dataset
run_analysis.R | Script to produce the tidy dataset from the raw dataset


### Running the Code
1. Clone the repo:

    ```
    git clone git@github.com:ryanheffernan/getting_and_cleaning_data.git
    ```
    
1. Execute the R script from the root of the repo:

    ```
    cd getting_and_cleaning_data
    Rscript run_analysis.R
    ```

1. Alternatively, open ```run_analysis.R``` in RStudio and execute it. Ensure to ```setwd()``` to the root directory of this repo first.


### Updating the Code Book

I'm lazy and didn't want to type out the full variable list by hand, so I use a script to generate a portion of the CodeBook from the tidy dataset as well as a 'template' CodeBook which contains the rest of the code book details.

To update the main contents of the Code Book, edit ```CodeBookTemplate.md``` and run ```generate_codebook.R``` to update ```CodeBook.md```:

```
vi CodeBookTemplate.md
...make changes and save...
Rscript generate_codebook.R
```

To update how the variable list is displayed, edit ```generate_codebook.R``` and run as above.