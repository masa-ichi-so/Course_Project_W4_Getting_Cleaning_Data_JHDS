# Course_Project_W4_Getting_Cleaning_Data_JHDS

## This is the course project of the John Hopkins Data Science Specialization: Getting and Cleaning Data.
The included R script, run_analysis.R, conducts the following:
* Download the dataset from web if it does not already exist in the working directory.
* Read both the train and test datasets and merge them. Data included: Activity, Subject, and Features.
* Load the data's feature, activity info and extract columns named 'mean'(-mean) and 'standard deviation'(-std).
* Change variable labels with more descriptive variable names.
* Create a tidy dataset that consists of the mean of each variable for each subject and each activity named tidy_dataset.txt.
