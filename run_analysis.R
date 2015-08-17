##  Create one R script called run_analysis.R that does the following. 
##      1. Merges the training and the test sets to create one data set.
##      2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##      3. Uses descriptive activity names to name the activities in the data set
##      4. Appropriately labels the data set with descriptive variable names. 
##      5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
##         variable for each activity and each subject.

library(reshape2)

## Load Activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

## Load data column names
columns <- read.table("./UCI HAR Dataset/features.txt")[,2]

## Extract only the required columns which are needed for this exercise
req_columns <- grepl("mean|std", columns)

## Load and process X, Y test and subject data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 

## Assign names to the columns
names(x_test) <- columns

## Extract only standard deviation and mean for each measurements.
x_test <- x_test[,req_columns]

## Process activity labels
y_test[,2] <- activities[y_test[,1]]
names(y_test) <- c("Activity_ID", "Activity_Label")

## Label subject table.
names(subject_test) <- "subject"

## Bind data sets to create one large data table with all relevant columns in it.
test_data <- cbind(subject_test, y_test, x_test)

## Load and process X, Y training and subject data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 

## Assign names to the columns
names(x_train) <- columns

## Extract only standard deviation and mean for each measurements.
x_train <- x_train[,req_columns]

## Process activity labels
y_train[,2] <- activities[y_train[,1]]
names(y_train) <- c("Activity_ID", "Activity_Label")

## Label subject table.
names(subject_train) <- "subject"

## Bind data sets to create one large data table with all relevant columns in it.
train_data <- cbind(subject_test, y_test, x_test)

## Merge test and training data in one data set.
merged_data <- rbind(test_data, train_data)

id_labels <- c("subject", "Activity_ID", "Activity_Label")

## Get the columns for which calculations need to be done.
data_labels <- setdiff(colnames(merged_data), id_labels)

## Convert data set in a stack form using melt function.
molten_data <- melt(merged_data, id = id_labels, measure.vars = data_labels)

## Apply mean function using decast to convert the stacked data set to wide format.
tidy_data   = dcast(molten_data, subject + Activity_Label ~ variable, mean)

## Write data set to a file.
write.table(tidy_data, file = "./tidy_data.txt")
