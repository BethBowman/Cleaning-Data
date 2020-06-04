library(dplyr)
## Reading in files
## I already have the files in this directory
# Reading  in  test  data
X_test <- read.table("./test/x_test.txt", sep = "\t")
y_test <- read.table("./test/y_test.txt", sep = "\t")
subject_test <- read.table("./test/subject_test.txt", sep = "\t")
# I don't need the raw Inertial Signals data
# body_acc_x_test <- read.table("./test/Inertial Signals/body_acc_x_test.txt", sep = "\t")
# body_acc_y_test <- read.table("./test/Inertial Signals/body_acc_y_test.txt", sep = "\t")
# body_acc_z_test <- read.table("./test/Inertial Signals/body_acc_z_test.txt", sep = "\t")
# body_gyro_x_test <- read.table("./test/Inertial Signals/body_gyro_x_test.txt", sep = "\t")
# body_gyro_y_test <- read.table("./test/Inertial Signals/body_gyro_y_test.txt", sep = "\t")
# body_gyro_z_test <- read.table("./test/Inertial Signals/body_gyro_z_test.txt", sep = "\t")
# total_acc_x_test <- read.table("./test/Inertial Signals/total_acc_x_test.txt", sep = "\t")
# total_acc_y_test <- read.table("./test/Inertial Signals/total_acc_y_test.txt", sep = "\t")
# total_acc_z_test <- read.table("./test/Inertial Signals/total_acc_z_test.txt", sep = "\t")
dim(X_test)
testingData <- cbind(subject_test, y_test, X_test, rep("test", times = 2947))
colnames(testingData) <- c("subject", "activity", "data", "set")
head(testingData)
testingDataName <- testingData

# Reading  in  train  data
X_train <- read.table("./train/x_train.txt", sep = "\t")
y_train <- read.table("./train/y_train.txt", sep = "\t")
subject_train <- read.table("./train/subject_train.txt", sep = "\t")
# I don't need the raw Inertial Signals data
# body_acc_x_train <- read.table("./train/Inertial Signals/body_acc_x_train.txt", sep = "\t")
# body_acc_y_train <- read.table("./train/Inertial Signals/body_acc_y_train.txt", sep = "\t")
# body_acc_z_train <- read.table("./train/Inertial Signals/body_acc_z_train.txt", sep = "\t")
# body_gyro_x_train <- read.table("./train/Inertial Signals/body_gyro_x_train.txt", sep = "\t")
# body_gyro_y_train <- read.table("./train/Inertial Signals/body_gyro_y_train.txt", sep = "\t")
# body_gyro_z_train <- read.table("./train/Inertial Signals/body_gyro_z_train.txt", sep = "\t")
# total_acc_x_train <- read.table("./train/Inertial Signals/total_acc_x_train.txt", sep = "\t")
# total_acc_y_train <- read.table("./train/Inertial Signals/total_acc_y_train.txt", sep = "\t")
# total_acc_z_train <- read.table("./train/Inertial Signals/total_acc_z_train.txt", sep = "\t")
dim(X_train)
trainingData <- cbind(subject_train, y_train, X_train, rep("train", times = 7352))
colnames(trainingData) <- c("subject", "activity", "data", "set")
head(trainingData)
trainingDataName <- trainingData

# Now combine Training and Testing Data
dataPreProcess <- rbind(testingDataName, trainingDataName)
table(dataPreProcess$set)

#The easiest thing to do is to  rename the "activity" codes to their real values
unique (dataPreProcess$activity)
for(i in 1:length(dataPreProcess$activity)) {
        if (dataPreProcess[i,]$activity == 1) {
                dataPreProcess[i,]$activity <- "walking"
        } else if (dataPreProcess[i,]$activity == 2) {
                dataPreProcess[i,]$activity <- "walkingUp"
        } else if (dataPreProcess[i,]$activity == 3) {
                dataPreProcess[i,]$activity <- "walkingDown"
        } else if (dataPreProcess[i,]$activity == 4) {
                dataPreProcess[i,]$activity <- "sitting"
        } else if (dataPreProcess[i,]$activity == 5) {
                dataPreProcess[i,]$activity <- "standing"
        } else if (dataPreProcess[i,]$activity == 6) {
                dataPreProcess[i,]$activity <- "laying"
        }
}
# Confirm this is what I was expecting
unique (dataPreProcess$activity)

# Now, I need to figure out what the X variable is and take the rows with mean and std
line1<- unlist(strsplit(as.character(dataPreProcess[1,]$data), split = "\\s+"))[2:562]
# This correlates with the features data. I need to get the mean and std values here
# strsplit functioin returns an empty character first, so  I subset to remove that
# build list of the features & index for mean() and std() to  make column headers eventually
features <- read.table("features.txt")
meanIndex <- features[grep("mean()", as.character(features$V2)), ]
stdIndex <- features[grep("std()", as.character(features$V2)), ]

# Now I need to select from the X variable,  the ones that correspond with "mean" or "std"
# First, create new "mean" columns with the feature names, fill in index  number as value  for placeholder
for(i in 1:length(meanIndex$V2))  {
        # new column name pulled from row V2
        colName <- as.character(meanIndex[i, ]$V2)
        # index filled down the row for new column in df
        dataPreProcess$new <- rep(as.numeric(meanIndex[i,]$V1), times = length(dataPreProcess$data))
        # rename the column name
        dataPreProcess<-rename(dataPreProcess, !!colName:= new)
}
# Now, create new "std" columns with the feature names, fill in index  number as value  for placeholder
for(i in 1:length(stdIndex$V2))  {
        # new column name pulled from row V2
        colName <- as.character(stdIndex[i, ]$V2)
        # index filled down the row for new column in df
        dataPreProcess$new <- rep(as.numeric(stdIndex[i,]$V1), times = length(dataPreProcess$data))
        # rename the column name
        dataPreProcess<-rename(dataPreProcess, !!colName:= new)
}

# Now I need to grab  the value in  the "data" column that corresponds with the index
dataComp <- dataPreProcess
for(i in 1:length(dataPreProcess$data)) {
        # split the X/data string to be indexed  values. First character produced is empty,  so remove
        line<- unlist(strsplit(as.character(dataComp[i,]$data), split = "\\s+"))[2:562]
        # for each column in this row, I have to look  up the right value, 5:83
        for (x in 5:83) {
                # Second, select the ones that correspond to the index number of columns 5:83
                index <- dataComp[i,x]
                val <- line[as.numeric(index)]
                # replace the index value with the value from the X/data string
                dataComp[i,x] <- val
        }
}
tail(dataComp)
# Success! this is the final data frame to then calculate averages from
# Remove the data/X column  in here even though I could erase it  now
dataFinal <- subset(dataComp, select = -c(data))


# Now  for the final section, I  need to get mean of each data column by activity and subject
# I'm going to start the data frame by filling in the first column data
# get the column name for col 5
colName <- colnames(dataFinal[5])
# subset just current column
currCol  <- dataFinal[ , c(1, 2, 5)]
# rename columns to generic names
colnames(currCol) <- c("subject", "activity", "current")
# find average across the groups
avgData <- currCol %>% group_by(subject, activity) %>% summarize(mean = mean(as.numeric(current)))
#  rename thie average back  to the origiinal column name
avgData<-rename(avgData, !!colName:= mean)
# Now loop through the rest of the columns
for (y in 6:82) {
        #grab the  column name of this column
        colName <- colnames(dataFinal[y])
        # subset just current column
        currCol  <- dataFinal[ , c(1, 2, y)]
        # rename columns to generic names
        colnames(currCol) <- c("subject", "activity", "current")
        # find average across the groups
        testing <- currCol %>% group_by(subject, activity) %>% summarize(mean = mean(as.numeric(current)))
        # Bind the mean column from this  to the summary column
        avgData <- cbind(avgData, mean  = testing$mean) 
        # rename the column back to column name
        avgData<-rename(avgData, !!colName:= mean)
}
