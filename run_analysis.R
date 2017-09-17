library(data.table)
library(dplyr)

label_preamble <- '^[0-9 ]+'
activity_labels <- gsub(
    label_preamble,
    '', 
    readLines('UCI HAR Dataset/activity_labels.txt')
)
variable_names <- tolower(gsub(
    label_preamble,
    '',
    readLines('UCI HAR Dataset/features.txt')
))
variable_names <- gsub('[\\,\\-]', '_', variable_names)
variable_names <- gsub('[\\(\\)]', '', variable_names)

test_data <- data.table(read.table('UCI HAR Dataset/test/X_test.txt'))
names(test_data) <- variable_names
test_data[,activity:=as.factor(readLines('UCI HAR Dataset/test/y_test.txt'))]
test_data[,subject:=as.factor(readLines('UCI HAR Dataset/test/subject_test.txt'))]
test_data[, which(duplicated(names(test_data))) := NULL]

train_data <- data.table(read.table('UCI HAR Dataset/train/X_train.txt'))
names(train_data) <- variable_names
train_data[,activity:=as.factor(readLines('UCI HAR Dataset/train/y_train.txt'))]
train_data[,subject:=as.factor(readLines('UCI HAR Dataset/train/subject_train.txt'))]
train_data[,!duplicated(names(train_data))]
train_data[, which(duplicated(names(train_data))) := NULL]

tidy_data <- select(
    rbind(test_data, train_data),
    contains('_std'),
    contains('_mean'),
    'activity',
    'subject'
)
levels(tidy_data$activity) <- activity_labels

write.table(tidy_data, 'tidy_data.txt')