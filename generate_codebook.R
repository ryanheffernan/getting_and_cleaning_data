# Script used to generate the code book for the tidy data
# This also serves as an example of reading the data into a data.table

library(data.table)
data <- fread("tidy_data.txt")

codebook <- readLines('CodeBookTemplate.md')
codebook <- append(
    codebook,
    c("",
      "### Full Variable List",
      "",
      paste(
        "See ```UCI HAR Dataset/features_info.txt```` for details",
        "of the original measurements."
      ),
      "",
      "Variable | Description",
      "------------------|------------",
      paste(
        "activity | Activity label, one of WALKING, WALKING_UPSTAIRS,",
        "WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING"
      ),
      "subject | Subject ID, 1 through 30"
    )
)

# Convert sanitized variable names back to original names
for (name in names(data[,!c("activity", "subject"), with=FALSE])) {
    match = 'mean_(\\w*)(Mean|Std)'
    replace = '\\1\\-\\L\\2\\(\\)'
    
    # Match names like .*mean()
    orig <- gsub(paste0(match, '$'), replace, name, perl=TRUE)
    
    # Match names like .*mean()-X
    orig <- gsub(
        paste0(match, '\\-(\\w)'), 
        paste0(replace, '\\-\\U\\3'),
        orig,
        perl=TRUE
    )
    description = paste(
        'Mean of the', 
        orig, 
        'measurement for the corresponding subject and activity')
    codebook <- append(codebook, paste(name, "|", description))
}

writeLines(codebook, 'CodeBook.md')
