# Getting and Cleaning Data Course Project CodeBook file
## Author: Nishant Shah

This is CodeBook file for Getting and Cleaning Data course project offered through Johns Hopkins and Coursera.

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
**0. Pre work**   
I am extensively using **`data.table`** package. Code will automatically install this package if not installed before. Also refer to **`README.md`** for details on unzipping data set, location of data set and R script.  
  
**1. Merges the training and the test sets to create one data set.**  
test and train folders have data sets for X (measurements), Y (activity) and subject who performed the activity. All three files in same folder contain same number of records and indicate which subject performed which activity and what are measurements. However there are no common key columns.     
  * X file contains measurements of features - total 561 columns   
  * Y file contains corresponding activity performed by subject. - 1 column   
  * subject file contains the subject who performed the activity - 1 column   
  * test and train folder files for X, Y and subject contain same number of columns and hence can be easily appended to create one common data set. This needs to be done in same order across all three files.  
  * test has details of 2947 observations and train has details of 7352 observations there by total of 10299 observations.  
  
  
**2. Extracts only the measurements on the mean and standard deviation for each measurement.**  
features.txt has details about all 561 variables. features_info.txt describles functions with mean() and std() as mean and std. deviation. I separated out functions with mean() and std() in their name. This resulted in total of 66 measurements which we are interested in.    
  * After this step, our measurements data.table had **10299 observaions** with **66 measurements** for each observation.  
  
  
**3. Uses descriptive activity names to name the activities in the data set**  
Activity descriptions are found in activity_labels.txt file. The description found to be in ALL CAPS case. I changed it to normal case.  
```
Walking
Walking_upstairs
Walking_downstairs
Sitting
Standing
Laying

```
  
  
**4. Appropriately labels the data set with descriptive variable names.**  
I made sure that subject and activities data.table have project column name of Subject and Activity respectively. I also removed **`(`** and **`)`** characters from the variable names and replaced **`-`** with **`_`** and updated measurements data.table  
  
  
**5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**  
This is the most important step as we need to merge all three data sets and then calculate mean of all measurements by activity and subject.   
  * First created **final** data.table using activities and **`copy`** command since data.table otherwise does copy by reference.   
  * Created new Subject column based on subjects data.table  
  * Created remaining 66 measurements columns using measurements data.table  
  * Used data.table functionality to calculate mean of each measurement grouped by Activity and Subject. See [data.table vignette](https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro-vignette.html)  
  * Prefixed **Avg_** to each measurement column of final data.table since its mean value.  
  * Created **Tidy_Data_Mean_Of_Measurements_By_Activity_Subject.txt** file using final data.table.  
  * This resulted in total 180 records (30 subjects * 6 activities) with 68 columns (Activity, Subject and 66 mean of measurements)  
  
  
# Structure of Tidy_Data_Mean_Of_Measurements_By_Activity_Subject.txt   
  
  
Variable | Description  
:------------ | :-------------    
Activity | Type of activity. One of the value from Walking, Walking_upstairs, Walking_downstairs,  Sitting, Standing, Laying
Subject | Subject performing activity. One of the value from 1 to 30    
Avg_tBodyAcc_mean_X|Average Of feature - tBodyAcc-mean()-X
Avg_tBodyAcc_mean_Y|Average Of feature - tBodyAcc-mean()-Y
Avg_tBodyAcc_mean_Z|Average Of feature - tBodyAcc-mean()-Z
Avg_tBodyAcc_std_X|Average Of feature - tBodyAcc-std()-X
Avg_tBodyAcc_std_Y|Average Of feature - tBodyAcc-std()-Y
Avg_tBodyAcc_std_Z|Average Of feature - tBodyAcc-std()-Z
Avg_tGravityAcc_mean_X|Average Of feature - tGravityAcc-mean()-X
Avg_tGravityAcc_mean_Y|Average Of feature - tGravityAcc-mean()-Y
Avg_tGravityAcc_mean_Z|Average Of feature - tGravityAcc-mean()-Z
Avg_tGravityAcc_std_X|Average Of feature - tGravityAcc-std()-X
Avg_tGravityAcc_std_Y|Average Of feature - tGravityAcc-std()-Y
Avg_tGravityAcc_std_Z|Average Of feature - tGravityAcc-std()-Z
Avg_tBodyAccJerk_mean_X|Average Of feature - tBodyAccJerk-mean()-X
Avg_tBodyAccJerk_mean_Y|Average Of feature - tBodyAccJerk-mean()-Y
Avg_tBodyAccJerk_mean_Z|Average Of feature - tBodyAccJerk-mean()-Z
Avg_tBodyAccJerk_std_X|Average Of feature - tBodyAccJerk-std()-X
Avg_tBodyAccJerk_std_Y|Average Of feature - tBodyAccJerk-std()-Y
Avg_tBodyAccJerk_std_Z|Average Of feature - tBodyAccJerk-std()-Z
Avg_tBodyGyro_mean_X|Average Of feature - tBodyGyro-mean()-X
Avg_tBodyGyro_mean_Y|Average Of feature - tBodyGyro-mean()-Y
Avg_tBodyGyro_mean_Z|Average Of feature - tBodyGyro-mean()-Z
Avg_tBodyGyro_std_X|Average Of feature - tBodyGyro-std()-X
Avg_tBodyGyro_std_Y|Average Of feature - tBodyGyro-std()-Y
Avg_tBodyGyro_std_Z|Average Of feature - tBodyGyro-std()-Z
Avg_tBodyGyroJerk_mean_X|Average Of feature - tBodyGyroJerk-mean()-X
Avg_tBodyGyroJerk_mean_Y|Average Of feature - tBodyGyroJerk-mean()-Y
Avg_tBodyGyroJerk_mean_Z|Average Of feature - tBodyGyroJerk-mean()-Z
Avg_tBodyGyroJerk_std_X|Average Of feature - tBodyGyroJerk-std()-X
Avg_tBodyGyroJerk_std_Y|Average Of feature - tBodyGyroJerk-std()-Y
Avg_tBodyGyroJerk_std_Z|Average Of feature - tBodyGyroJerk-std()-Z
Avg_tBodyAccMag_mean|Average Of feature - tBodyAccMag-mean()
Avg_tBodyAccMag_std|Average Of feature - tBodyAccMag-std()
Avg_tGravityAccMag_mean|Average Of feature - tGravityAccMag-mean()
Avg_tGravityAccMag_std|Average Of feature - tGravityAccMag-std()
Avg_tBodyAccJerkMag_mean|Average Of feature - tBodyAccJerkMag-mean()
Avg_tBodyAccJerkMag_std|Average Of feature - tBodyAccJerkMag-std()
Avg_tBodyGyroMag_mean|Average Of feature - tBodyGyroMag-mean()
Avg_tBodyGyroMag_std|Average Of feature - tBodyGyroMag-std()
Avg_tBodyGyroJerkMag_mean|Average Of feature - tBodyGyroJerkMag-mean()
Avg_tBodyGyroJerkMag_std|Average Of feature - tBodyGyroJerkMag-std()
Avg_fBodyAcc_mean_X|Average Of feature - fBodyAcc-mean()-X
Avg_fBodyAcc_mean_Y|Average Of feature - fBodyAcc-mean()-Y
Avg_fBodyAcc_mean_Z|Average Of feature - fBodyAcc-mean()-Z
Avg_fBodyAcc_std_X|Average Of feature - fBodyAcc-std()-X
Avg_fBodyAcc_std_Y|Average Of feature - fBodyAcc-std()-Y
Avg_fBodyAcc_std_Z|Average Of feature - fBodyAcc-std()-Z
Avg_fBodyAccJerk_mean_X|Average Of feature - fBodyAccJerk-mean()-X
Avg_fBodyAccJerk_mean_Y|Average Of feature - fBodyAccJerk-mean()-Y
Avg_fBodyAccJerk_mean_Z|Average Of feature - fBodyAccJerk-mean()-Z
Avg_fBodyAccJerk_std_X|Average Of feature - fBodyAccJerk-std()-X
Avg_fBodyAccJerk_std_Y|Average Of feature - fBodyAccJerk-std()-Y
Avg_fBodyAccJerk_std_Z|Average Of feature - fBodyAccJerk-std()-Z
Avg_fBodyGyro_mean_X|Average Of feature - fBodyGyro-mean()-X
Avg_fBodyGyro_mean_Y|Average Of feature - fBodyGyro-mean()-Y
Avg_fBodyGyro_mean_Z|Average Of feature - fBodyGyro-mean()-Z
Avg_fBodyGyro_std_X|Average Of feature - fBodyGyro-std()-X
Avg_fBodyGyro_std_Y|Average Of feature - fBodyGyro-std()-Y
Avg_fBodyGyro_std_Z|Average Of feature - fBodyGyro-std()-Z
Avg_fBodyAccMag_mean|Average Of feature - fBodyAccMag-mean()
Avg_fBodyAccMag_std|Average Of feature - fBodyAccMag-std()
Avg_fBodyBodyAccJerkMag_mean|Average Of feature - fBodyBodyAccJerkMag-mean()
Avg_fBodyBodyAccJerkMag_std|Average Of feature - fBodyBodyAccJerkMag-std()
Avg_fBodyBodyGyroMag_mean|Average Of feature - fBodyBodyGyroMag-mean()
Avg_fBodyBodyGyroMag_std|Average Of feature - fBodyBodyGyroMag-std()
Avg_fBodyBodyGyroJerkMag_mean|Average Of feature - fBodyBodyGyroJerkMag-mean()
Avg_fBodyBodyGyroJerkMag_std|Average Of feature - fBodyBodyGyroJerkMag-std()


 

  

  
  









