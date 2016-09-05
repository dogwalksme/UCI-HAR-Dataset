
##  Tidying the UCI HAR Dataset 

This project provides two tidy datasets created from the UCI HAR Dataset.
The data used for this project can be found
[here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
and a full description of the data set can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).


## How to generate the tidy datasets

Ensure that the Samsung data is located in the `data/` folder under 
`data/UCI HAR Dataset`.

To generate the tidy data sets run: 

```
$ Rscript run-analysis.R
[1] "merging to data/merged/subject_merged.txt"
[1] "merging to data/merged/X_merged.txt"
[1] "merging to data/merged/y_merged.txt"
NULL
[1] "Subsetting data into `X`"
[1] "Merging subject data into `X`"
[1] "Merging activity data into `X`"
[1] "Saving tidy data at `data/X.txt`"
[1] "Saving tidy data at `data/X2.txt`"
```

## Output

### `data/X.txt`

X.txt is a tidy dataset consisting of the merged data provided by the UCI HAR data set. In addition to the activity and subject data, only the means and standard deviations measures have been selected to be included.

More information can be found in `X-CodeBook.md`

### `data/X2.txt`

X2.txt is a tidy dataset that averages all metrics of X1 by activity and subject. More information can be found in `X2-CodeBook.md`.  X2.txt is constructucted from X.txt in this way:

```
> X2 <- aggregate(. ~ activity + subject, X, mean)
```

