i#Code Book

This document describes the code inside run_analysis.R.

#Step 0 : Download the Data
===========================

Variables used:
*  filesPath : path of data source files
*  fileUrl : url of file of data source
*  destfile: Destination File after download
*  zipfile: downloaded zip file
*  exdir: The directory to extract files to from zip file

##Downloads the UCI HAR zip file if it doesn't exist
filesPath <- "C:/Manoj-H/docs/data science/JHU/3 - Getting and Cleaning Data/Project/UCI HAR Dataset"
setwd(filesPath)
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

##Unzip DataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

##Files in folder UCI HAR Dataset that will be used are:
SUBJECT FILES
* test/subject_test.txt
* train/subject_train.txt

ACTIVITY FILES
* test/X_test.txt
* train/X_train.txt

DATA FILES
* test/y_test.txt
* train/y_train.txt
* features.txt - Names of column variables in the dataTable
* activity_labels.txt - Links the class labels with their activity name.

# Step 1 : Merges the training and the test sets to create one data set.
=======================================================================

##Loading data
Variables used :
* X_train : data pertaining to trainind data set
* Y_train : data pertaining to training labels
* X_test : data pertaining to test data set
* Y_test : data pertaining to test labels
* subject_train: training data pertaining to the subject who performed the activity for each window sample. 
* subject_test: test data pertaining to the subject who performed the activity for each window sample. 
* features: data pertaining to list of all features
* activity_labels: data pertaining to the class labels with their activity name

setwd("C:/Manoj-H/docs/data science/JHU/3 - Getting and Cleaning Data/Project/UCI HAR Dataset/data/UCI HAR Dataset")

##Read data files to train 
X_train <-read.table("train/X_train.txt",stringsAsFactors=F,header=F)
Y_train <-read.table("train/Y_train.txt",stringsAsFactors=F,header=F)

##Read data files to test data
X_test<-read.table("test/X_test.txt",stringsAsFactors=F,header=F)
Y_test<-read.table("test/Y_test.txt",stringsAsFactors=F,header=F)


## Read subject files
subject_train <-read.table("train/subject_train.txt",stringsAsFactors=F,header=F)
subject_test<-read.table("test/subject_test.txt",stringsAsFactors=F,header=F)

##Reading features
features<-read.table("features.txt",stringsAsFactors=F,header=F)

## Read activity files 
activity_labels<-read.table("activity_labels.txt",stringsAsFactors=F,header=F)

##Look at the properties of the above variables

* >str(X_train)
  'data.frame':	7352 obs. of  561 variables:
    $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
    * > str(Y_train)
      'data.frame':	7352 obs. of  1 variable:
        $ Activity_ID: int  5 5 5 5 5 5 5 5 5 5 ...
	* > str(X_test)
	  'data.frame':	2947 obs. of  561 variables:
	    $ tBodyAcc-mean()-X                   : num  0.257 0.286 0.275 0.27 0.275 ...
	    ##Reading features

	     > str(Y_test)
	     'data.frame':	2947 obs. of  1 variable:
	      $ Activity_ID: int  5 5 5 5 5 5 5 5 5 5 ...

	      > str(subject_train)
	      'data.frame':	7352 obs. of  1 variable:
	       $ Subject_ID: int  1 1 1 1 1 1 1 1 1 1 ...

	        > str(subject_test)
		'data.frame':	2947 obs. of  1 variable:
		 $ Subject_ID: int  2 2 2 2 2 2 2 2 2 2 ...

		 > str(features)
		 'data.frame':	561 obs. of  2 variables:
		  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
		   $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

		   > str(activity_labels)
		   'data.frame':	6 obs. of  2 variables:
		    $ Activity_ID  : int  1 2 3 4 5 6
		     $ Activity_Type: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...

		     ##Merges test data and training data to UCI
		     Variables used :
		     *  train : merged training data
		     *  test : merged test data
		     *  UCI : combination of train and test data

		     train<-cbind(Y_train,subject_train,X_train)
		     test<-cbind(Y_test,subject_test,X_test)
		     UCI<-rbind(train,test)

		     > str(train)
		     'data.frame':	7352 obs. of  563 variables:
		      $ Activity_ID                         : int  5 5 5 5 5 5 5 5 5 5 ...

		       > str(test)
		       'data.frame':	2947 obs. of  563 variables:
		        $ Activity_ID                         : int  5 5 5 5 5 5 5 5 5 5 ...

			 > str(UCI)
			 'data.frame':	10299 obs. of  563 variables:
			  $ Activity_ID                         : int  5 5 5 5 5 5 5 5 5 5 ...

			  #Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
			  ===============================================================================================
			  ##Reading column names:
			  Variable used :
			  *  FeaturesNames : contains all features with mean and std

			  FeaturesNames<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

			  > str(FeaturesNames)
			   chr [1:66] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" ...

			   ##Create vector for defining ID, mean and standard deviation:
			   Variables used :
			   *  selectedNames : vector with selected feature name , Subject and Activity

			   selectedNames<-c(as.character(FeaturesNames), "Subject_ID", "Activity_ID" )

			   > str(selectedNames)
			    chr [1:68] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" ...

			    ##Making nessesary subset from UCI

			    Variables Used :
			    *  Data : all observations with selected columns

			    Data<-subset(UCI,select=selectedNames)

			    #Step 3 : Uses descriptive activity names to name the activities in the data set
			    ================================================================================

			    Data<- merge(Data,activity_labels,by='Activity_ID',all.x=TRUE)

			    > str(Data)
			    'data.frame':	10299 obs. of  69 variables:
			     $ Activity_ID                                   : int  1 1 1 1 1 1 1 1 1 1 ...

			     #Step 4 : Appropriately labels the data set with descriptive variable names.
			     ============================================================================

			     *  In the former part, variables activity and subject and names of the activities have been labelled using descriptive names.
			     *  In this part, Names of Feteatures will labelled using descriptive variable names.
			     *  prefix t is replaced by time
			     *  Acc is replaced by Accelerometer
			     *  Gyro is replaced by Gyroscope
			     *  prefix f is replaced by frequency
			     *  Mag is replaced by Magnitude
			     *  BodyBody is replaced by Body

			     names(Data)<-gsub("^t", "time", names(Data))
			     names(Data)<-gsub("^f", "frequency", names(Data))
			     names(Data)<-gsub("Acc", "Accelerometer", names(Data))
			     names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
			     names(Data)<-gsub("Mag", "Magnitude", names(Data))
			     names(Data)<-gsub("BodyBody", "Body", names(Data))

			     #Step 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
			     =======================================================================================================================================================
			     Variables used :
			     *  sec_TidySet  : Second independent tidy data set with the average of each variable for each activity and each subject.

			     Data$Activity_Type <- as.character(Data$Activity_Type)
			     sec_TidySet <- aggregate(. ~Subject_ID + Activity_ID - Activity_Type , Data, mean)
			     sec_TidySet <- sec_TidySet[order(sec_TidySet$Subject_ID, sec_TidySet$Activity_ID),]

			     > str(sec_TidySet )
			     'data.frame':	180 obs. of  69 variables:
			      $ Subject_ID                                    : int  1 1 1 1 1 1 2 2 2 2 ...
			       $ Activity_ID                                   : int  1 2 3 4 5 6 1 2 3 4 ...
			        $ Activity_Type                                 : chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...

				## Writing second tidy data set in txt file

				write.table(sec_TidySet, "sec_TidySet.txt", row.name=FALSE)

				===============================================================
