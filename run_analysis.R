setwd("C:\\Users\\ds\\DataScientiest_Coursera\\Class3\\Week4")
library(dplyr)
library(tidyr)
library(lubridate)
library(data.table)
if(!file.exists("data")){
	dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = fileUrl, destfile = "./data/Data.zip", mode = "wb")
dateDownloaded <- now()
unzip(zipfile = "./data/Data.zip", exdir = "./data")
# list folder contents in the directory, files are in "UCI HAR Dataset"
path_files <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_files, recursive=TRUE)
files
#combine the training set and test set data accordingly: 
#Activity consist of data from “Y_train.txt” and “Y_test.txt”
#Subject consist of data from “subject_train.txt” and subject_test.txt"
#Features consist of data from “X_train.txt” and “X_test.txt”
#Names of Variables Features come from “features.txt”
#Levels of Activity come from “activity_labels.txt”
#remember: path_files <- file.path("./data" , "UCI HAR Dataset")

##Read the Activity files

ActivityTestData  <- tbl_df(read.table(file.path(path_files, "test" , "Y_test.txt" ),header = FALSE))
ActivityTrainData <- tbl_df(read.table(file.path(path_files, "train", "Y_train.txt"),header = FALSE))

##Read the Subject files
SubjectTrainData <- tbl_df(read.table(file.path(path_files, "train", "subject_train.txt"),header = FALSE))
SubjectTestData  <- tbl_df(read.table(file.path(path_files, "test" , "subject_test.txt"),header = FALSE))

##Read Fearures files
FeaturesTestData  <- tbl_df(read.table(file.path(path_files, "test" , "X_test.txt" ),header = FALSE))
FeaturesTrainData <- tbl_df(read.table(file.path(path_files, "train", "X_train.txt"),header = FALSE))

##find out what the tables are
dim(ActivityTestData)
head(ActivityTestData)
str(ActivityTestData)

str(ActivityTrainData)
head(ActivityTrainData)

str(SubjectTrainData)
head(SubjectTrainData)

str(SubjectTestData)
head(SubjectTestData)

str(FeaturesTrainData)
head(FeaturesTrainData)

str(FeaturesTestData)
head(FeaturesTestData)

#merge data using rbind since the column variables are the same; rename column according to the data set
##data.table package will help in renaming column headings
###setnames(data, old=c("old_name","another_old_name"), new=c("new_name", "another_new_name"))
ActivityData <- rbind(ActivityTestData, ActivityTrainData)
setnames(ActivityData, "V1", "activity")
SubjectData <- rbind(SubjectTestData, SubjectTrainData)
setnames(SubjectData, "V1", "subject")
FeaturesData <- rbind(FeaturesTestData, FeaturesTrainData)
#Features has many columns, key is in features.txt
FeaturesKey <- tbl_df(read.table(file.path(path_files, "features.txt")))
##checking
str(FeaturesKey)
#Now match the FeaturesKey to the column names and rename them; in column 2, heading "V2"
names(FeaturesData) <- FeaturesKey$"V2"
#merge data tables, columns, with cbind
SubActData <- cbind(SubjectData , ActivityData)
AllData <- cbind(SubActData, FeaturesData)
#read in the last file, activity_labels.txt
activityLabels <- read.table(file.path(path_files, "activity_labels.txt"),header = FALSE)
View(activityLabels)
setnames(activityLabels, "V2", "activityLabels")

FeaturesWanted <- grep("mean|std",FeaturesKey$"V2", value=TRUE)
selectColumns <- c("subject", "activity", as.character(FeaturesWanted))
subData <- subset(AllData, select = selectColumns)
##checking table
str(subData)
###Need to use descriptive activity names to name the activities
subData$activity <- as.character(subData$activity)
subData$activity <- factor(subData$activity, levels = activityLabels[,1], labels = activityLabels[,2])

##now I want to see what the variable names are, then apply the proper descriptive labels
splitnames <-  strsplit(names(subData), "-")
###want to get the first element of the list#
#try the function in the lecture
firstElement <- function(x){x[1]}
splitnames2 <- unique(sapply(splitnames, firstElement))
# Acc is for accelerometer
# Gyro is for gyroscope
# prefix 't' to denote time
# prefix 'f' to indicate frequency domain signals
# Mag for magnitude
# BodyBody is just Body

names(subData) <- gsub("Acc","accelerometer",names(subData))
names(subData) <- gsub("Gyro","gyroscope",names(subData))
names(subData) <- gsub("^t","time",names(subData))
names(subData) <- gsub("^f","frequency",names(subData))
names(subData) <- gsub("Mag","magnitude",names(subData))
names(subData) <- gsub("BodyBody","Body",names(subData))
##double checking
names(subData)

#Part 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#Checking subject names
subjectname <- sort(unique(subData$subject))
subjectname
# [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21
#[22] 22 23 24 25 26 27 28 29 30

#use group_by and summarize, then arrange
newtable <- subData %>%
	group_by(subject, activity) %>%
	summarize_each(funs(mean)) %>%
	arrange(subject,activity)
#checking
str(newtable)

##Now write to hard drive
write.table(newtable, file = "./tidydata.txt",row.name=FALSE)
