## Data for project
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Description - http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Requirements
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Assumptions
# 1. Make sure that data set file is manually downloaded and unzipped
# 2. Workding directory is set to "UCI HAR Dataset" folder or any other folder where test, train subfolders and rest of the data files available
# 3. run_analysis.R is run from the working directory

# Pre work
# I am going to use data.table package. So check and see if package is installed or not. If not installed, install the same
if (!require(data.table))
{
    install.packages("data.table")
}


# 1. Merges the training and the test sets to create one data set.
# test and train folders have data sets for X (measurements), Y (activity) and subject who performed the activity. 
# All three files contain same number of records and indicates Which subject performed which activity and what are measurements
# Also test and train files for each varialbe (measurements, activity and subject) contain same number of columns. 
# So test and train can be appeneded together to create one large data table. This needs to be done in same order across all three variables.

# Read measurements 
test1 <- read.table("./test/X_test.txt")
train1 <- read.table("./train/X_train.txt")

#append together using rbind and then convert to data.table
measurements <- data.table(rbind(test1, train1))

# Read activities. We will use same test1/train1 as we are not going to use later 
test1 <- read.table("./test/Y_test.txt")
train1 <- read.table("./train/Y_train.txt")

#append together using rbind and then convert to data.table
activities <- data.table(rbind(test1, train1))


# Read subjects.  We will use same test1/train1 as we are not going to use later 
test1 <- read.table("./test/subject_test.txt")
train1 <- read.table("./train/subject_train.txt")

#append together using rbind and then convert to data.table
subjects <- data.table(rbind(test1, train1))

# We will merge all three tables later. 


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# features.txt has details about all 561 variables. features_info.txt describles functions with mean() and std() as mean and std. deviation. 
# We want to only use mean and std deviation. Separate fields with mean() or std()

features <- read.table("features.txt")
# run grep on all feature names and get indices in vector where mean() and std() present.
# we have to use \\ as \ is used by regex to bypass and another \ is used by R to bypass
interested_features <- grep("-mean\\(\\)|-std\\(\\)", features[,2], value=FALSE)     # second column has list of features. value=FALSE will return indices

# We need to get interested_features column indices. See data.table vignette for "with" usage
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro-vignette.html
measurements <- measurements[, interested_features, with=FALSE]


# 3. Uses descriptive activity names to name the activities in the data set
# activity descriptions are found in activity_labels.txt file.
activity_desc <- read.table("./activity_labels.txt")

# Instead of ALL CAPS activity description, I am changing it to regular case. e.g. Walking, Walking_upstairs etc
# Changing all activity desription to lower case
activity_desc[,2] <- tolower(activity_desc[,2])
# Updating first character to upper case. 
activity_desc[,2] <- paste(toupper(substring(activity_desc[,2], 1,1)), substring(activity_desc[,2], 2, nchar(activity_desc[,2])), sep="")


# activities data.table is just one column. We can replace it using "value" row, 2nd column from description where value = value of activities data table row
setnames(activities, "V1", "Activity")

# Updating Activity column with description
activities[, Activity := activity_desc[activities[, Activity], 2]]


# 4. Appropriately labels the data set with descriptive variable names.
# Activity was labelled in step 3. We will label subject and measurements in this step

setnames(subjects, "V1", "Subject")

# measurements has only mean and std variables. We need to get description from features using row index (step 2)
# convert interested_features to vector as otherwise it shows Factor.
setnames(measurements, colnames(measurements), as.vector(features[interested_features,2]))
# substitute "-" with "_" and remove ( ) in variable names as when reading back (for test), it removes it
origCols <- copy(colnames(measurements))
cols <- colnames(measurements)
cols <- gsub("-", "_", cols)
cols <- gsub("\\(|\\)", "", cols)
setnames(measurements, colnames(measurements), cols)



# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Now we will merge all three data tables so that we have Activity, Subject, Measurement columns. Though there are no key columns.

# create final data.table with activities. Do deep copy as not to change earlier tables
final <- copy(activities)

# Now add subjects
#final[, c(colnames(subjects)) := list(subjects[,Subject])]
final[, c(colnames(subjects)) := subjects]

# Now add measurements
final[, c(colnames(measurements)) := measurements]

# Calculate mean of all columns by activity and subject fields. .SD indicates all columns except listed in by. See vignette
mean_of_measure <- final[, lapply(.SD, mean), by= .(Activity, Subject)]

#First we will change all column names to have Avg at start. Once done, we will reset first two columns to Activity and Subject.
setnames(mean_of_measure, colnames(mean_of_measure), paste("Avg_", colnames(mean_of_measure), sep=""))
setnames(mean_of_measure, c("Avg_Activity", "Avg_Subject"), c("Activity", "Subject"))

# write the tidy data to txt file
write.table(mean_of_measure, "Tidy_Data_Mean_Of_Measurements_By_Activity_Subject.txt", row.names=FALSE)


## Below commented code can be used to read the generated file and do some basic checks
## Start of reading generating file
# read_data <- read.table("./Tidy_Data_Mean_Of_Measurements_By_Activity_Subject.txt", header=TRUE)
# nrow(read_data)  ## should be 180  (30 subjects * 6 activities)
# ncol(read_data)  ## should be 2 (Activity, Subject) + 66 (avg of measurements) = 68
# colnames(read_data)
# head(read_data, n=5)
## End of reading generated file


## Below commented code is used to generate part of CodeBook.md. This is run once outside of the code so to provide variable name and its meaning.
## Start of CodeBookPart.md generation
## varDesc <- paste(paste(paste("Avg_", colnames(measurements), sep=""), "Average Of feature - ", sep="|"), origCols, sep="")
## write.table(varDesc, "CodeBookPart.md", col.names=FALSE, row.names=FALSE, quote=FALSE)

## End of CodeBookPart.md generation



