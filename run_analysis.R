#Downloads the UCI HAR zip file if it doesn't exist

filesPath <- "C:/Manoj-H/docs/data science/JHU/3 - Getting and Cleaning Data/Project/UCI HAR Dataset"
setwd(filesPath)
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

##Unzip DataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Step 1
# Merges the training and the test sets to create one data set.
setwd("C:/Manoj-H/docs/data science/JHU/3 - Getting and Cleaning Data/Project/UCI HAR Dataset/data/UCI HAR Dataset")

#Reading training table
X_train <-read.table("train/X_train.txt",stringsAsFactors=F,header=F)
Y_train <-read.table("train/Y_train.txt",stringsAsFactors=F,header=F)
subject_train <-read.table("train/subject_train.txt",stringsAsFactors=F,header=F)

#Reading test table
X_test<-read.table("test/X_test.txt",stringsAsFactors=F,header=F)
Y_test<-read.table("test/Y_test.txt",stringsAsFactors=F,header=F)
subject_test<-read.table("test/subject_test.txt",stringsAsFactors=F,header=F)

#Reading features
features<-read.table("features.txt",stringsAsFactors=F,header=F)

#Reading activity labels
activity_labels<-read.table("activity_labels.txt",stringsAsFactors=F,header=F)

names(X_train)<-features[,2]
names(Y_train)<-"Activity_ID"
names(subject_train)<-"Subject_ID"

names(X_test)<-features[,2]
names(Y_test)<-"Activity_ID"
names(subject_test)<-"Subject_ID"

names(activity_labels)<-c("Activity_ID","Activity_Type")

#Merge train :
train<-cbind(Y_train,subject_train,X_train)
#Merge test :
test<-cbind(Y_test,subject_test,X_test)

#Merge train and test
UCI<-rbind(train,test)

#Step#2
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Reading column names:

FeaturesNames<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
#Create vector for defining ID, mean and standard deviation:
selectedNames<-c(as.character(FeaturesNames), "Subject_ID", "Activity_ID" )

#Making nessesary subset from UCI
Data<-subset(UCI,select=selectedNames)

#Step#3
#Uses descriptive activity names to name the activities in the data set

Data<- merge(Data,activity_labels,by='Activity_ID',all.x=TRUE)

#Step#4
#Appropriately labels the data set with descriptive variable names.
#In the former part, variables activity and subject and names of the activities have been labelled using descriptive names.
#In this part, Names of Feteatures will labelled using descriptive variable names.
#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Step#5
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data$Activity_Type <- as.character(Data$Activity_Type)
sec_TidySet <- aggregate(. ~Subject_ID + Activity_ID - Activity_Type , Data, mean)
sec_TidySet <- sec_TidySet[order(sec_TidySet$Subject_ID, sec_TidySet$Activity_ID),]

#Writing second tidy data set in txt file

write.table(sec_TidySet, "sec_TidySet.txt", row.name=FALSE)


