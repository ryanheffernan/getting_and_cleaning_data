# Example script to use read the tidy dataset files into 
# one data.table

library(data.table)

df <- rbindlist(
    lapply(
        list.files('tidy_dataset/', '.*\\.txt$', full.names = TRUE), 
        fread, 
        header=TRUE
    )
)
