# Getting and Cleaning Data Course Project Readme file
## Author: Nishant Shah

This is README file for Getting and Cleaning Data course project offered through Johns Hopkins and Coursera.

# Project Requirements
Data file for the project:  
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  
Full description of the data:  
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  

You should create one R script called run_analysis.R that does the following.   
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.   
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

# Implementation Details
* Manually download data file from above link and unzip it to local directory - e.g. **`C:\Coursera\Project`**  
* Unzip process will create directory **`"UCI HAR Dataset"`** and copy all the required files and subdirectories to this directory.  
* Download the run_analysis.R file from [Github](https://github.com/shahnish) and copy in **`"UCI HAR Dataset"`** directory.  
* In RStudio, set working direcotry to the local **`"UCI HAR Dataset"`** directory. e.g. **`setwd("C:\\Coursera\\Project\\UCI HAR Dataset")`**  
* Type command **`source("run_analysis.R")`** to run the script for project.  
* It will install **`data.table`** package if not present and will generate tidy data which in local directory. The same was uploaded to project website.  
* The generated file name is **`Tidy_Data_Mean_Of_Measurements_By_Activity_Subject.txt`** 
* Sample code to test result.  
```
read_data <- read.table("./Tidy_Data_Mean_Of_Measurements_By_Activity_Subject.txt", header=TRUE)
nrow(read_data)  ## should be 180  (30 subjects * 6 activities)
ncol(read_data)  ## should be 2 (Activity, Subject) + 66 (avg of measurements) = 68
colnames(read_data)
head(read_data, n=5)
```
* Read **`CodeBook.md`** for details about each step and description of variable names of tidy data  




