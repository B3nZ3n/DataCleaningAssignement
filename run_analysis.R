library(plyr)
library(openxlsx)
library(dplyr)

# Loading the files located in ./Data

activityLabels <- read.csv("./Data/activity_labels.txt", sep = " ", header =FALSE)
names(activityLabels) <- c("activitynumber","activityname")

subjectTrain <- read.csv("./Data/train/subject_train.txt", sep = " ", header =FALSE)
names(subjectTrain) <- c("subjectnumber")

trainingActivity <- read.csv("./Data/train/y_train.txt", sep = " ", header =FALSE)
names(trainingActivity) <- c("activitynumber")

trainingData <- read.csv("./Data/train/x_train.txt",sep="",header=FALSE,strip.white=TRUE)

#merging subject and activity
trainingTidy <- merge(subjectTrain,trainingActivity, by=0, ALL=TRUE)
names(trainingTidy) <- c("recordid","subjectnumber","activitynumber")
trainingTidy <-  subset(trainingTidy,select = -recordid)

#adding activity labels
trainingTidy <- merge(trainingTidy, activityLabels)

#adding data
trainingTidy <- merge(trainingTidy, trainingData, by=0, all=TRUE)

#dropping 1st column rowNumber
trainingTidy <- subset(trainingTidy,select = -1)



subjectTest <- read.csv("./Data/test/subject_test.txt", sep = " ", header =FALSE)
names(subjectTest) <- c("subjectnumber")

testActivity <- read.csv("./Data/test/y_test.txt", sep = " ", header =FALSE)
names(testActivity) <- c("activitynumber")

testData <- read.csv("./Data/test/x_test.txt",sep="",header=FALSE,strip.white=TRUE)



testTidy <- merge(subjectTest,testActivity, by=0, ALL=TRUE)
names(testTidy) <- c("recordid","subjectnumber","activitynumber")
testTidy <-  subset(testTidy,select = -recordid)

#adding activity labels
testTidy <- merge(testTidy, activityLabels)

#adding data
testTidy <- merge(testTidy, testData, by=0, all=TRUE)

#dropping 1st column rowNumber
testTidy <- subset(testTidy,select = -1)

finalTidy <- rbind(testTidy, trainingTidy)


## now labeling the variables

variableNames <- read.csv("./Data/features.txt", sep = " ", header =FALSE)
names(variableNames) <- c("featurenumber","featurename")



names(finalTidy) <- c(c("activitynumber","subjectnumber","activityname"),c(as.character(variableNames$featurename)))

columnNames <- names(finalTidy)


export1 <- finalTidy[grepl("activitynumber|subjectnumber|activityname|mean|std",ignore.case = TRUE,columnNames)]


## uggly, fix later
export2 <- ddply(export1, .(subjectnumber,activityname), summarise,
      mean(`tBodyAcc-mean()-X`),mean(`tBodyAcc-mean()-Y`),mean(`tBodyAcc-mean()-Z`),mean(`tBodyAcc-std()-X`),mean(`tBodyAcc-std()-Y`),mean(`tBodyAcc-std()-Z`),mean(`tGravityAcc-mean()-X`),mean(`tGravityAcc-mean()-Y`),mean(`tGravityAcc-mean()-Z`),mean(`tGravityAcc-std()-X`),mean(`tGravityAcc-std()-Y`),mean(`tGravityAcc-std()-Z`),mean(`tBodyAccJerk-mean()-X`),mean(`tBodyAccJerk-mean()-Y`),mean(`tBodyAccJerk-mean()-Z`),mean(`tBodyAccJerk-std()-X`),mean(`tBodyAccJerk-std()-Y`),mean(`tBodyAccJerk-std()-Z`),mean(`tBodyGyro-mean()-X`),mean(`tBodyGyro-mean()-Y`),mean(`tBodyGyro-mean()-Z`),mean(`tBodyGyro-std()-X`),mean(`tBodyGyro-std()-Y`),mean(`tBodyGyro-std()-Z`),mean(`tBodyGyroJerk-mean()-X`),mean(`tBodyGyroJerk-mean()-Y`),mean(`tBodyGyroJerk-mean()-Z`),mean(`tBodyGyroJerk-std()-X`),mean(`tBodyGyroJerk-std()-Y`),mean(`tBodyGyroJerk-std()-Z`),mean(`tBodyAccMag-mean()`),mean(`tBodyAccMag-std()`),mean(`tGravityAccMag-mean()`),mean(`tGravityAccMag-std()`),mean(`tBodyAccJerkMag-mean()`),mean(`tBodyAccJerkMag-std()`),mean(`tBodyGyroMag-mean()`),mean(`tBodyGyroMag-std()`),mean(`tBodyGyroJerkMag-mean()`),mean(`tBodyGyroJerkMag-std()`),mean(`fBodyAcc-mean()-X`),mean(`fBodyAcc-mean()-Y`),mean(`fBodyAcc-mean()-Z`),mean(`fBodyAcc-std()-X`),mean(`fBodyAcc-std()-Y`),mean(`fBodyAcc-std()-Z`),mean(`fBodyAcc-meanFreq()-X`),mean(`fBodyAcc-meanFreq()-Y`),mean(`fBodyAcc-meanFreq()-Z`),mean(`fBodyAccJerk-mean()-X`),mean(`fBodyAccJerk-mean()-Y`),mean(`fBodyAccJerk-mean()-Z`),mean(`fBodyAccJerk-std()-X`),mean(`fBodyAccJerk-std()-Y`),mean(`fBodyAccJerk-std()-Z`),mean(`fBodyAccJerk-meanFreq()-X`),mean(`fBodyAccJerk-meanFreq()-Y`),mean(`fBodyAccJerk-meanFreq()-Z`),mean(`fBodyGyro-mean()-X`),mean(`fBodyGyro-mean()-Y`),mean(`fBodyGyro-mean()-Z`),mean(`fBodyGyro-std()-X`),mean(`fBodyGyro-std()-Y`),mean(`fBodyGyro-std()-Z`),mean(`fBodyGyro-meanFreq()-X`),mean(`fBodyGyro-meanFreq()-Y`),mean(`fBodyGyro-meanFreq()-Z`),mean(`fBodyAccMag-mean()`),mean(`fBodyAccMag-std()`),mean(`fBodyAccMag-meanFreq()`),mean(`fBodyBodyAccJerkMag-mean()`),mean(`fBodyBodyAccJerkMag-std()`),mean(`fBodyBodyAccJerkMag-meanFreq()`),mean(`fBodyBodyGyroMag-mean()`),mean(`fBodyBodyGyroMag-std()`),mean(`fBodyBodyGyroMag-meanFreq()`),mean(`fBodyBodyGyroJerkMag-mean()`),mean(`fBodyBodyGyroJerkMag-std()`),mean(`fBodyBodyGyroJerkMag-meanFreq()`),mean(`angle(tBodyAccMean,gravity)`),mean(`angle(tBodyAccJerkMean),gravityMean)`),mean(`angle(tBodyGyroMean,gravityMean)`),mean(`angle(tBodyGyroJerkMean,gravityMean)`),mean(`angle(X,gravityMean)`),mean(`angle(Y,gravityMean)`),mean(`angle(Z,gravityMean)`)
      
      )

write.table(export2, "export2.txt",row.name=FALSE)
