
library(plyr)

## Read features
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
names(activities) <- c("activity", "activity_lable")

## Read train data
trainSubjects <- read.table("train/subject_train.txt")
trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/Y_train.txt")

## Read test data
testSubjects <- read.table("test/subject_test.txt")
testX <- read.table("test/X_test.txt")
testY <- read.table("test/Y_test.txt")

## Set column names for X (from features)
names(trainX) <- features[,2]
names(testX) <- features[,2]

## Set column name for Y
names(trainY) <- c("activity")
names(testY) <- c("activity")

## Set column names for subjects
names(trainSubjects) <- c("subject")
names(testSubjects) <- c("subject")

## Metge subjects, Y and X
train <- cbind(trainSubjects, trainY, trainX)
test <- cbind(testSubjects, testY, testX)

## Metge test and train data
allData <- rbind(test, train)

selectedColumns <- grepl("Mean", names(allData), ignore.case = TRUE) | grepl("Std", names(allData), ignore.case = TRUE)
selectedColumns[1:2] <- TRUE
reducedData <- allData[,selectedColumns]

## Add activity_lable column
dataActTemp <- merge(activities, reducedData, by.x="activity", by.y="activity")
## Remove activity column
dataAct <- dataActTemp[,-1]

dataFinal <- ddply(dataAct, .(activity_lable, subject), numcolwise(mean))

## Write merged results to a text file
write.table(dataFinal, file = "final_data.txt")
