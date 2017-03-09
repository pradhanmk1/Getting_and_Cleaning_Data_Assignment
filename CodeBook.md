#Code Book

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

### str(X_train)
*  'data.frame':	7352 obs. of  561 variables:
*  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
### str(Y_train)
*  'data.frame':	7352 obs. of  1 variable:
*  $ Activity_ID: int  5 5 5 5 5 5 5 5 5 5 ...
### str(X_test)
*  'data.frame':	2947 obs. of  561 variables:
*  $ tBodyAcc-mean()-X                   : num  0.257 0.286 0.275 0.27 0.275 ...
##Reading features

