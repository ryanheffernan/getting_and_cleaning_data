# Extract averages of specific fields in the UCI HAR Dataset
# for each activity and subject and store in a tidy dataset

library(data.table)

loadUCIDataset <- function(dataFile, activityFile, subjectFile) {
    data <- fread(dataFile)
    
    variableNames <- gsub(
        '^[0-9 ]+',
        '',
        readLines('UCI HAR Dataset/features.txt')
    )
    names(data) <- variableNames
    data[, grep('std\\(\\)|mean\\(\\)', names(data), invert=TRUE) := NULL]
    names(data) <- gsub('\\-([sm])(\\w+)\\(\\)', '\\U\\1\\L\\2', names(data), perl=TRUE)
    #names(data) <- gsub('[\\(\\)\\,\\-]', '', names(data))
    
    data[, activity:=as.factor(readLines(activityFile))]
    data[, subject:=as.factor(readLines(subjectFile))]
    return(data)
}

testData <- loadUCIDataset(
    'UCI HAR Dataset/test/X_test.txt', 
    'UCI HAR Dataset/test/y_test.txt', 
    'UCI HAR Dataset/test/subject_test.txt'
)
trainData <- loadUCIDataset(
    'UCI HAR Dataset/train/X_train.txt', 
    'UCI HAR Dataset/train/y_train.txt', 
    'UCI HAR Dataset/train/subject_train.txt'
)
allData <- rbindlist(list(testData, trainData))

# Factors need to be properly ordered before we can order the dataset
allData[
    , 
    subject := factor(
        subject, 
        sort(as.numeric(unique(subject))),
        ordered = TRUE
    )
]
allData[
    , 
    activity := factor(
        activity, 
        sort(as.numeric(unique(activity))), 
        ordered = TRUE
    )
]
setorder(allData, -activity, subject)

activityLabels <- gsub(
    '^[0-9 ]+',
    '',
    readLines('UCI HAR Dataset/activity_labels.txt')
)
levels(allData$activity) <- activityLabels

averages <- allData[, lapply(.SD, mean), by=list(activity, subject)]
names(averages)[3:ncol(averages)] <- 
    paste0('mean_', names(averages)[3:ncol(averages)])

# Equivalent of write.table but much faster
fwrite(averages, file='tidy_data.txt', sep=" ")
