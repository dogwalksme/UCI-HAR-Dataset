#!/usr/bin/env Rscript
#
# run-analysis.R - Transform the UCI HAR Dataset into two
#                  tidy datasets.
#
# usage:
#   $ Rscript run-analysis.R
#
# output:
#   data/X.txt    Merged and tidy UCI HAR dataset
#   data/X2.txt   Avg of each metric by subject and activity
#
# This script assumes that the original dataset is
# unzipped and can be found in `data/UCI HAR Dataset`
#

#
# Step 1 - Merges the training and the test sets to create one data set.
#
testFiles <- c(
  "data/UCI HAR Dataset/test/subject_test.txt",
  "data/UCI HAR Dataset/test/X_test.txt",
  "data/UCI HAR Dataset/test/y_test.txt")
trainFiles <- gsub("test", "train", testFiles)
mergedFiles <- gsub("test", "merged", testFiles)
mergedFiles <- gsub("UCI HAR Dataset/", "", mergedFiles)

# Create folder structure where the merged files will go
if (!dir.exists("data/merged")) {
  dir.create("data/merged/Inertial Signals", recursive = TRUE)
}

# For each tuple, save to disk test + train as merged.
mergeTuples <- data.frame(test=testFiles, train=trainFiles, merged=mergedFiles)
apply(mergeTuples, 1, function (t) {
  print( paste("merging to", t[3] ))
  test <- read.table(t[1])
  train <- read.table(t[2])
  write.table(rbind(test,train), t[3])
})

#
# Step 2 - Extracts only the measurements on the mean and standard deviation
#          for each measurement.
print("Subsetting data into `X`")

# Load the merged data and the column names (features.txt)
# Subset the table for mean and standard deviation columns
X_merged <- read.table("data/merged/X_merged.txt")
allFeatures <- read.table("data/UCI HAR Dataset/features.txt")
features <- allFeatures[grep("-mean|-std", allFeatures$V2), ]

# X is the data set. It will get tidied up.
X <- X_merged[, features$V1]

# let's name the columns with cleaned up column names from features.
names(X) <- gsub("[\\)\\(]","", features$V2) # remove the '()'
names(X) <- gsub("-", "_", names(X))         # replace '-' to '_'

# let's merge the subjects.
print("Merging subject data into `X`")
subjects <- read.table("data/merged/subject_merged.txt")
X <- cbind(X, subject = subjects$V1)  # Also naming the column as 'subject'

#
# Step 3 - Uses descriptive activity names to name the activities in the
#          data set
#
print("Merging activity data into `X`")
activityLabels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
activities <- read.table("data/merged/y_merged.txt")
Y <- merge(activities, activityLabels, by = "V1")
X <- cbind(X, activity = Y$V2)  # Also naming the column as 'activity'.
print("Saving tidy data to `data/X.txt`")
write.table(X, "data/X.txt")

#
# Step 4 - Appropriately label the data set with descriptive Variable names.
#
# (All columns have been appropriately named at this point)

#
# Step 5 - From the data set in step 4, creates a second, independent tidy data
#          set with the average of each variable for each activity and each
#          subject.
#
print("Saving tidy data to `data/X2.txt`")
X2 <- aggregate(. ~ activity + subject, X, mean)
write.table(X2, "data/X2.txt")

