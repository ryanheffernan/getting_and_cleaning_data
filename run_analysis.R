library(data.table)
library(dplyr)

loadUCIDataset <- function(dataFile, labelFile, subjectFile) {
    labelPreamble <- '^[0-9 ]+'
    activityLabels <- gsub(
        labelPreamble,
        '', 
        readLines('UCI HAR Dataset/activity_labels.txt')
    )
    variableNames <- gsub(
        labelPreamble,
        '',
        readLines('UCI HAR Dataset/features.txt')
    )

    data <- fread(dataFile)
    names(data) <- variableNames
    data[, grep('std\\(\\)|mean\\(\\)', names(data), invert=TRUE) := NULL]
    data[, activity:=as.factor(readLines(labelFile))]
    data[, subject:=as.factor(readLines(subjectFile))]
    levels(data$activity) <- activityLabels
    names(data) <- gsub('[\\,\\-]', '_', names(data))
    names(data) <- gsub('[\\(\\)]', '', names(data))
    
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

averages <- allData[, lapply(.SD, mean), by=list(activity, subject)]
averages[
    , 
    subject := factor(
        subject, 
        sort(as.numeric(unique(subject))),
        ordered = TRUE
    )
]
averages[, activity := factor(activity, sort(unique(activity)), ordered = TRUE)]
setorder(averages, subject, -activity)

fwrite(averages, 'tidy_data.txt')