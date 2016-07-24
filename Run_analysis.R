############Merges the training and the test sets to create one data set#########
#creat folder
dir.create("./dataset")
#download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./dataset/projectData_getCleanData.zip")
#unzip file
un_Zip <- unzip("./dataset/projectData_getCleanData.zip", exdir = "./dataset")

#merge train 
train.x <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./dataset/UCI HAR Dataset/train/subject_train.txt")
train_data <- cbind(train.subject, train.y, train.x)

#merge test
test.x <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")
test_data <- cbind(test.subject, test.y, test.x)

#Merge into one data set
full_data <- rbind(train_data, test_data)

###Extract only the measurements on the mean and standard deviation for each measurement##
feature_name <- read.table("./dataset/UCI HAR Dataset/features.txt")[,2]
feature_index <- grep(("mean\\(\\)|std\\(\\)"), feature_name)
final_data <- full_data[, c(1, 2, feature_index+2)]
colnames(final_data) <- c("subject", "activity", feature_name[feature_index])

###Uses descriptive activity names to name the activities in the data set#####
#load activity
activity_name <- read.table("./dataset/UCI HAR Dataset/activity_labels.txt")
#name
final_data$activity <- factor(final_data$activity, levels = activity_name[,1], labels = activity_name[,2])

###Appropriately labels the data set with descriptive variable names###
names(final_data) <- gsub("\\()", "", names(final_data))
names(final_data) <- gsub("^t", "time", names(final_data))
names(final_data) <- gsub("^f", "frequence", names(final_data))
names(final_data) <- gsub("-mean", "Mean", names(final_data))
names(final_data) <- gsub("-std", "Std", names(final_data))

###From the data set in step 4, creates a second,-
###-independent tidy data set with the average of each variable for each activity and each subject####
tidy_data <- final_data %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))















