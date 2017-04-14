
# Download data
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataURL, "files")
unzip("files")

# Read files
# Appropriately label the data set with descriptive variable names

features <- read.table("./UCI HAR Dataset/features.txt")[,2]
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features)
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")

train_x <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features)
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

# Merges the training and the test sets to create one data set
test_set <- cbind(test_x, test_y, test_subject)
train_set <- cbind(train_x, train_y, train_subject)

all_data <- merge(test_set, train_set, all = TRUE, sort=FALSE)

# Extract only the measurements on the mean and standard deviation for each measurement
mean_std <- names(all_data)[grepl("(.*)mean\\.\\.(.*)|(.*)std\\.\\.(.*)", names(all_data))]
library(dplyr)
mean_std_data <- all_data[, mean_std]

# read activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "name"))

# Use descriptive activity names to name the activities in the data set
mean_std_data$Activity <- activity_names[all_data$Activity, 2]

# create a second, independent tidy data set with the average of each variable for each activity and each subject
data2 <- mean_std_data
data2$Subject <- all_data$Subject

tidy_data <- data2 %>% group_by(Activity, Subject) %>% summarize_each(funs(mean))

write.table(tidy_data, "tidy_data.txt")
