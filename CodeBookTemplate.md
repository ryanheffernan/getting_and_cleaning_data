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
