## CodeBook for the Tidy UCI HAR Dataset

_Note: This codebook is generated, do not edit it directly. See the README for instructions on how to update._

### Structure of the tidy data

The tidy dataset is represented in a 'long' or 'narrow' form, where each subject/activity combination is represented as 1 row. This results in 180 rows, which is 6 activity rows for each of the 30 subjects. 

Each row also contains a variable representing the mean calculated over the original mean and standard deviation measurements from the dataset for the corresponding subject and activity. There are 66 of these measurements, meaning each row has a total of 68 columns (66 measurements plus activity and subject).

The data is ordered by activity and then subject, purely because I thought it looked nice :).

The long form was chosen for this data since I found it much easier to read and explore data with 68 columns vs the 408 or more that would be needed in a wide form. It's also very comvenient to group the data in the long form to produce interesting aggregations, for example to get the mean of all subjects per activity:

```
data[,lapply(.SD, mean), by=activity]
```

Or to simply filter it by one activity type:

```
data[activity == 'WALKING']
```

Finally, a wide form can easily produced using the ```reshape()``` function if needed:

```
reshape(data, idvar="subject", timevar="activity", direction="wide")
```

### Transformations

The following transformations were made in order to produce a tidy dataset.
1. Variable names from ```UCI HAR Dataset/features.txt``` were used to label each column of the test and train datasets.
1. Variables not containing the substrings ```std()``` or ```mean()``` were deleted. I chose to not include ```meanFreq()``` measurements as my interpretation of the assignment instructions was to only include pure mean/std values and the original description of ```meanFreq()``` indicates it is a weighted average, which is not a pure mean.
1. Parentheses and hyphens were removed from variable names to make them easier to read and type. I also capitalized the first letter of 'mean' and 'std' in the names to make it clear that this is part of the original variable name before I calculated a mean over subject/activity.
1. 'mean_' was prepended to each measurement to make it clear that this is a mean over multiple measurements and not the original measurement.
1. ```activity``` and ```subject``` columns were added containing the activity labels and subject IDs from the raw dataset. Since these represent labels and not measurements, they were treated as factors and not numerics.
1. ```rbindlist``` was used to combine the test and train data into one dataset.
1. The ```subject``` and ```activity``` factors were re-ordered based on their numerical ordering, and then the dataset was re-ordered by activity and subject in ascending order. This was done for neatness and readability.
1. The numerical ```activity``` values were replaced with activity strings from ```UCI HAR Dataset/activity_labels.txt``` to make them more descriptive.
1. The mean of all measurements (grouped by activity and subject) was calculated and stored in a new dataset.
1. The result was written to disk using ```fwrite()``` with ```sep = " "```, which is the equivalent of ```write.table()``` but much faster.

### A Note on data.table

I chose to use ```data.table``` and the corresponding ```fwrite()``` and ```fread()``` functions because it proved to be a massive speed increase when testing my code over using standard ```data.frame``` and ```read.table```. As an example, simply loading the train set with ```read.table``` takes 16 seconds on my machine:

```
$ echo 'invisible(read.table("UCI HAR Dataset/train/X_train.txt"))' > test.R
$ time Rscript test.R

real	0m16.210s
user	0m15.488s
sys	0m0.303s
```

Whereas running the entire ```run_analysis.R``` script (which uses fread and data.table) on the same machine takes only 1.5 seconds.
```
ryanheffern-mbp:getting_and_cleaning_data ryanheffernan$ time Rscript run_analysis.R

real	0m1.484s
user	0m1.128s
sys	0m0.141s
```

### Variable Names

The tidy dataset contains an ```activity``` and ```subject```  variable which represents the activity and subject for which the measurements for each row apply.

The rest of the variables consist of the means of measurements from the original UCI HAR dataset. The names are slightly sanitized versions of the original feature names with 'mean_' prepended to signify that this is a mean over multiple measurements and not a single measurement.

For example, if the original variable was ```tBodyAcc-mean()-X```, then its counterpart in the tidy dataset is ```mean_tBodyAccMeanX```. The parentheses and hyphens were removed order to make the variable names match standard coding conventions and avoid any characters that may be illegal or special in common programming languages. I also think that these variables names are more readable
and easier to type in code due to the removal of special characters.

These variables all represent the mean of the corresponding feature values per activity per subject. In other words it's the mean of the original features grouped by activity and subject.

### Full Variable List

See ```UCI HAR Dataset/features_info.txt``` for details of the original measurements.

Variable | Description
------------------|------------
activity | Activity label, one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
subject | Subject ID, 1 through 30
mean_tBodyAccMeanX | Mean of the tBodyAcc-mean()-X measurements for the corresponding subject and activity
mean_tBodyAccMeanY | Mean of the tBodyAcc-mean()-Y measurements for the corresponding subject and activity
mean_tBodyAccMeanZ | Mean of the tBodyAcc-mean()-Z measurements for the corresponding subject and activity
mean_tBodyAccStdX | Mean of the tBodyAcc-std()-X measurements for the corresponding subject and activity
mean_tBodyAccStdY | Mean of the tBodyAcc-std()-Y measurements for the corresponding subject and activity
mean_tBodyAccStdZ | Mean of the tBodyAcc-std()-Z measurements for the corresponding subject and activity
mean_tGravityAccMeanX | Mean of the tGravityAcc-mean()-X measurements for the corresponding subject and activity
mean_tGravityAccMeanY | Mean of the tGravityAcc-mean()-Y measurements for the corresponding subject and activity
mean_tGravityAccMeanZ | Mean of the tGravityAcc-mean()-Z measurements for the corresponding subject and activity
mean_tGravityAccStdX | Mean of the tGravityAcc-std()-X measurements for the corresponding subject and activity
mean_tGravityAccStdY | Mean of the tGravityAcc-std()-Y measurements for the corresponding subject and activity
mean_tGravityAccStdZ | Mean of the tGravityAcc-std()-Z measurements for the corresponding subject and activity
mean_tBodyAccJerkMeanX | Mean of the tBodyAccJerk-mean()-X measurements for the corresponding subject and activity
mean_tBodyAccJerkMeanY | Mean of the tBodyAccJerk-mean()-Y measurements for the corresponding subject and activity
mean_tBodyAccJerkMeanZ | Mean of the tBodyAccJerk-mean()-Z measurements for the corresponding subject and activity
mean_tBodyAccJerkStdX | Mean of the tBodyAccJerk-std()-X measurements for the corresponding subject and activity
mean_tBodyAccJerkStdY | Mean of the tBodyAccJerk-std()-Y measurements for the corresponding subject and activity
mean_tBodyAccJerkStdZ | Mean of the tBodyAccJerk-std()-Z measurements for the corresponding subject and activity
mean_tBodyGyroMeanX | Mean of the tBodyGyro-mean()-X measurements for the corresponding subject and activity
mean_tBodyGyroMeanY | Mean of the tBodyGyro-mean()-Y measurements for the corresponding subject and activity
mean_tBodyGyroMeanZ | Mean of the tBodyGyro-mean()-Z measurements for the corresponding subject and activity
mean_tBodyGyroStdX | Mean of the tBodyGyro-std()-X measurements for the corresponding subject and activity
mean_tBodyGyroStdY | Mean of the tBodyGyro-std()-Y measurements for the corresponding subject and activity
mean_tBodyGyroStdZ | Mean of the tBodyGyro-std()-Z measurements for the corresponding subject and activity
mean_tBodyGyroJerkMeanX | Mean of the tBodyGyroJerk-mean()-X measurements for the corresponding subject and activity
mean_tBodyGyroJerkMeanY | Mean of the tBodyGyroJerk-mean()-Y measurements for the corresponding subject and activity
mean_tBodyGyroJerkMeanZ | Mean of the tBodyGyroJerk-mean()-Z measurements for the corresponding subject and activity
mean_tBodyGyroJerkStdX | Mean of the tBodyGyroJerk-std()-X measurements for the corresponding subject and activity
mean_tBodyGyroJerkStdY | Mean of the tBodyGyroJerk-std()-Y measurements for the corresponding subject and activity
mean_tBodyGyroJerkStdZ | Mean of the tBodyGyroJerk-std()-Z measurements for the corresponding subject and activity
mean_tBodyAccMagMean | Mean of the tBodyAccMag-mean() measurements for the corresponding subject and activity
mean_tBodyAccMagStd | Mean of the tBodyAccMag-std() measurements for the corresponding subject and activity
mean_tGravityAccMagMean | Mean of the tGravityAccMag-mean() measurements for the corresponding subject and activity
mean_tGravityAccMagStd | Mean of the tGravityAccMag-std() measurements for the corresponding subject and activity
mean_tBodyAccJerkMagMean | Mean of the tBodyAccJerkMag-mean() measurements for the corresponding subject and activity
mean_tBodyAccJerkMagStd | Mean of the tBodyAccJerkMag-std() measurements for the corresponding subject and activity
mean_tBodyGyroMagMean | Mean of the tBodyGyroMag-mean() measurements for the corresponding subject and activity
mean_tBodyGyroMagStd | Mean of the tBodyGyroMag-std() measurements for the corresponding subject and activity
mean_tBodyGyroJerkMagMean | Mean of the tBodyGyroJerkMag-mean() measurements for the corresponding subject and activity
mean_tBodyGyroJerkMagStd | Mean of the tBodyGyroJerkMag-std() measurements for the corresponding subject and activity
mean_fBodyAccMeanX | Mean of the fBodyAcc-mean()-X measurements for the corresponding subject and activity
mean_fBodyAccMeanY | Mean of the fBodyAcc-mean()-Y measurements for the corresponding subject and activity
mean_fBodyAccMeanZ | Mean of the fBodyAcc-mean()-Z measurements for the corresponding subject and activity
mean_fBodyAccStdX | Mean of the fBodyAcc-std()-X measurements for the corresponding subject and activity
mean_fBodyAccStdY | Mean of the fBodyAcc-std()-Y measurements for the corresponding subject and activity
mean_fBodyAccStdZ | Mean of the fBodyAcc-std()-Z measurements for the corresponding subject and activity
mean_fBodyAccJerkMeanX | Mean of the fBodyAccJerk-mean()-X measurements for the corresponding subject and activity
mean_fBodyAccJerkMeanY | Mean of the fBodyAccJerk-mean()-Y measurements for the corresponding subject and activity
mean_fBodyAccJerkMeanZ | Mean of the fBodyAccJerk-mean()-Z measurements for the corresponding subject and activity
mean_fBodyAccJerkStdX | Mean of the fBodyAccJerk-std()-X measurements for the corresponding subject and activity
mean_fBodyAccJerkStdY | Mean of the fBodyAccJerk-std()-Y measurements for the corresponding subject and activity
mean_fBodyAccJerkStdZ | Mean of the fBodyAccJerk-std()-Z measurements for the corresponding subject and activity
mean_fBodyGyroMeanX | Mean of the fBodyGyro-mean()-X measurements for the corresponding subject and activity
mean_fBodyGyroMeanY | Mean of the fBodyGyro-mean()-Y measurements for the corresponding subject and activity
mean_fBodyGyroMeanZ | Mean of the fBodyGyro-mean()-Z measurements for the corresponding subject and activity
mean_fBodyGyroStdX | Mean of the fBodyGyro-std()-X measurements for the corresponding subject and activity
mean_fBodyGyroStdY | Mean of the fBodyGyro-std()-Y measurements for the corresponding subject and activity
mean_fBodyGyroStdZ | Mean of the fBodyGyro-std()-Z measurements for the corresponding subject and activity
mean_fBodyAccMagMean | Mean of the fBodyAccMag-mean() measurements for the corresponding subject and activity
mean_fBodyAccMagStd | Mean of the fBodyAccMag-std() measurements for the corresponding subject and activity
mean_fBodyBodyAccJerkMagMean | Mean of the fBodyBodyAccJerkMag-mean() measurements for the corresponding subject and activity
mean_fBodyBodyAccJerkMagStd | Mean of the fBodyBodyAccJerkMag-std() measurements for the corresponding subject and activity
mean_fBodyBodyGyroMagMean | Mean of the fBodyBodyGyroMag-mean() measurements for the corresponding subject and activity
mean_fBodyBodyGyroMagStd | Mean of the fBodyBodyGyroMag-std() measurements for the corresponding subject and activity
mean_fBodyBodyGyroJerkMagMean | Mean of the fBodyBodyGyroJerkMag-mean() measurements for the corresponding subject and activity
mean_fBodyBodyGyroJerkMagStd | Mean of the fBodyBodyGyroJerkMag-std() measurements for the corresponding subject and activity
