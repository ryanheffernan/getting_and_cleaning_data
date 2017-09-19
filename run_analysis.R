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
    
    data <- data.table(read.table(dataFile))
    names(data) <- variableNames
    
    data[,activity:=as.factor(readLines(labelFile))]
    data[,subject:=as.factor(readLines(subjectFile))]
    data[,which(duplicated(names(data))) := NULL]
    
    levels(data$activity) <- activityLabels
    
    data <- select(
        data,
        contains('std()'),
        contains('mean()'),
        'activity', 
        'subject'
    )
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

allData <- rbind(testData, trainData)


write.table(allData, 'tidy_data.txt')