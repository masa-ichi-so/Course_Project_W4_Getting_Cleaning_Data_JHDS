
# Download the data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataproject.zip", method="libcurl")

# Unzip the file
unzip(zipfile = "./data/dataproject.zip", exdir = "./data")

# Unzip files folder UCI HAR Dataset
pathUCI <-  file.path( "./data","UCI HAR Dataset")
files <- list.files(pathUCI, recursive = TRUE)
files

# 1. Merges the training and the test sets to create one data set. ----
# Read data from the files 
# Activity files
data_activity_test <- read.table(file.path(pathUCI,"test", "Y_test.txt"), header = FALSE)
data_activity_train <- read.table(file.path(pathUCI,"train", "Y_train.txt"), header = FALSE)

# Subject Files
data_subject_test <- read.table(file.path(pathUCI, "test", "subject_test.txt"), header = FALSE)
data_subject_train <- read.table(file.path(pathUCI, "train", "subject_train.txt"), header = FALSE)

# Features Files
data_features_test <- read.table(file.path(pathUCI, "test", "X_test.txt"), header = FALSE)
data_features_train <- read.table(file.path(pathUCI, "train", "X_train.txt"), header = FALSE)


# Concatenate data by rows
data_activity <- rbind(data_activity_train, data_activity_test)
data_subject <- rbind(data_subject_train, data_subject_test)
data_features <- rbind(data_features_train, data_features_test)

# Set names to variables
names(data_activity) <- "Activity"
names(data_subject) <- "Subject"
feature_names <- read.table(file.path(pathUCI, "features.txt"), header = FALSE)
names(data_features) <- feature_names$V2

# Merge data
data_1 <- cbind(data_subject, data_activity)
data <- cbind(data_1, data_features)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement ----

data_features_mean_std <- feature_names$V2[grep("mean\\(\\)|std\\(\\)", feature_names$V2)]
data_features_mean_std

# Subset data frame by selected names: data_features_mean_std
data_mean_std <- subset(data, select = c(data_features_mean_std, "Subject", "Activity"))


# 3. Uses descriptive activity names to name the activities in the data set----

activity_labels <- read.table(file.path(pathUCI, "activity_labels.txt"), header = FALSE)

data_mean_std$Activity <- factor(data_mean_std$Activity, labels = activity_labels$V2)


# 4. Appropriately labels the data set with descriptive variable names. ----
names(data_mean_std)<-gsub("^t", "time", names(data_mean_std))
names(data_mean_std)<-gsub("^f", "frequency", names(data_mean_std))
names(data_mean_std)<-gsub("Acc", "Accelerometer", names(data_mean_std))
names(data_mean_std)<-gsub("Gyro", "Gyroscope", names(data_mean_std))
names(data_mean_std)<-gsub("Mag", "Magnitude", names(data_mean_std))
names(data_mean_std)<-gsub("BodyBody", "Body", names(data_mean_std))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.----
library(tidyverse)
tidy_data <- data_mean_std %>% 
  group_by(Subject, Activity) %>% 
  summarise(across(`frequencyBodyGyroscopeJerkMagnitude-std()`:`timeBodyAccelerometer-mean()-X`, mean)) %>%
  ungroup()

write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)
                        