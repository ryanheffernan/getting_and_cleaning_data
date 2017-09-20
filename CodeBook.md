## CodeBook for the Tidy UCI HAR Dataset

### Variable Names

The variable names for the averages of the measurements from the original dataset are simply slightly modified versions of the original variable names with '__mean' appended to signify that this is a mean over all measurements for a specific subject and activity.

For example, if the original variable was ```tBodyAcc-mean()-X```, then its counterpart in the tidy dataset is ```tBodyAcc_mean_X__mean```. The parentheses were removed and hyphens were replaced with underscores in order to make the variable names match standard coding conventions and avoid any characters that may be illegal or special in common programming languages. 

See ```UCI HAR Dataset/features_info.txt``` for explanations of the original measurements.

In addition, the tidy dataset contains an ```activity``` and ```subject```  variable which represents the activity and subject for which the measurements for each row apply.

### Structure of the tidy data

The tidy dataset files are stored in the ```tidy_dataset/``` directory. The data consists of one file per activity which allows for clean seperation of measurements for each activity type. 

Each row in a file represents the averages of all relevant measurements from the original dataset for one subject and one activity.

The rows in each file are ordered by subject in ascending order so that when loaded into an R data.frame or data.table, row 1 corresponds to subject 1, row 2 to subject 2, and so on.

An example of how to load all of the tidy dataset files into one data.table is provided in ```read_tidy_data.R```.

### Transformations

The following transformations were made in order to produce a tidy dataset.
1. Variable names from ```UCI HAR Dataset/features.txt``` were used to label each column of the test and train datasets.
1. Variables not containing the substrings ```std()``` or ```mean()``` were deleted.
1. Parentheses were removed from variable names and hyphens were replaced with underscores.
1. ```activity``` and ```subject``` columns wer added containing the activity labels and subject IDs from the raw dataset. Since these represent labels and not measurements, they were treated as factors and not numerics.
1. ```rbindlist``` was used to combine the test and train data into one dataset.
1. The ```subject``` and ```activity``` factors were re-ordered based on their numerical ordering, and then the dataset was re-ordered by activity and subject in ascending order.
1. The numerical ```activity``` values were replaced with activity strings from ```UCI HAR Dataset/activity_labels.txt``` to make them more descriptive.
1. The mean of all measurements (grouped by activity and subject) was calculated and stored in a new dataset.
1. A file was written for each activity containing the means for every subject corresponding to that activity.


