## Code for the Week 4 Assignment - Getting and Cleaning Data Course
## Author: Karl Melgarejo (19.09.2021)


## Creating a local file
        # Setting the local path (this is the path to my file in my PC)
setwd("C:/Users/KARL/Dropbox/Cursos online/Johns Hopkins - Coursera/3. Getting and Cleaning Data/Assig")

        # Local file
if(!file.exists("./Data")){
        dir.create("./Data")
}

## Downloading the data
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = url1, destfile = "./Data/Dataset.zip")

        #Unzip the data in the local file
unzip(zipfile = "./Data/Dataset.zip", exdir = "./Data")

## Q1: "Merges the training and the test sets to create one data set"

library(data.table)

        # Read Training Data from the unzipped file
Train_DS <- read.table(file = "./Data/UCI HAR Dataset/train/X_train.txt", sep = "")
dim(Train_DS)
names(Train_DS)
str(Train_DS)
head(Train_DS)

        # Read Test Data from the unzipped file
Test_DS <- read.table(file = "./Data/UCI HAR Dataset/test/X_test.txt", sep = "")
dim(Test_DS)
names(Test_DS)
str(Test_DS)
head(Test_DS)

        # Merging data sets
TT_DS <- merge(Train_DS, Test_DS, all=TRUE)
dim(TT_DS)


## Q2: Extracts only the measurements on the mean and standard deviation for each measurement.

        #Extracting the mean for each measurement
m <- apply(TT_DS, 2, mean)
head(m)

        #Extracting the standard deviation for each measurement
s <- apply(TT_DS, 2, sd)
head(s)


## Q3: Uses descriptive activity names to name the activities in the data set

        # Reading activity labels in Test data set
act_lTest <- read.table(file = "./Data/UCI HAR Dataset/test/y_test.txt", sep = "")
act_lTest <- rename(act_lTest, cod = V1)

        # Reading activity labels in Training data set
act_lTrain <- read.table(file = "./Data/UCI HAR Dataset/train/y_train.txt", sep = "")
act_lTrain <- rename(act_lTrain, cod = V1)

        # Reading activity labels in "Activity Labels" data set
lab <- read.table(file = "./Data/UCI HAR Dataset/activity_labels.txt", sep = "")
lab <- rename(lab, cod = V1, Activlabel = V2)

        # Adding labels as a new column in Test and Train Data Sets
Train_DS$Activity_Cod <- act_lTrain
Test_DS$Activity_Cod <- act_lTest

        # Merging data sets
TT_DS <- rbind(Train_DS, Test_DS)

        # Loop to name each value of the "Activity Cod" with the Name of the Activity
for(i in 1:6){
        TT_DS$Activity_Label[TT_DS$Activity_Cod==i] <- lab$Activlabel[i]
}

## Q4: Appropriately labels the data set with descriptive variable names

        # It is useful to install the following package
install.packages('papeR')
library(papeR)     

        # Reading the "Variable Labels"
lab_var <- read.table(file = "./Data/UCI HAR Dataset/features.txt", sep = "")
class(lab_var)
tail(lab_var)
dim(lab_var)

        # Adding labels for the new variables
lab_var[562,2] <- "Activiy code"
lab_var[563,2] <- "Activiy Label"

        # Labeling the variable names
labels(TT_DS) <- lab_var$V2
labels(TT_DS)


# Q5: From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
library(reshape2)
library(data.table)

        # First we need the "Subjects Data Set"
subj_train <- read.table(file = "./Data/UCI HAR Dataset/train/subject_train.txt", sep = "")
subj_test <- read.table(file = "./Data/UCI HAR Dataset/test/subject_test.txt", sep = "")

        # Merging Subjects Data Sets and adding to the Big Data Set
subj_ds <- rbind(subj_train, subj_test)

TT_DS$Subject <- subj_ds
labels(TT_DS$Subject) <- "Subject id"
labels(TT_DS$Subject)

        # Reshaping the Data Set by using "Melt" function
v <- names(TT_DS)[1:561]
TT_DS_T <- data.table(TT_DS)
TT_DS_melt <- melt(TT_DS_T, id=c("Subject", "Activity_Label", "Activity_Cod"), measure.vars = v)

        # Grouping the Data Set by "Subject" and "Activity" 
TT_DS_g <- group_by(TT_DS_melt, Subject, Activity_Label, variable)

        # Creating New Data Set with average values of each variable for each subject and activity 
New_Data <- dplyr::summarise(TT_DS_g, Mean=mean(value))
head(New_Data, n=10)

write.table(New_Data, file = "./New_Data.txt",  row.name=FALSE)
