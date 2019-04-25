#Set your working directory at the "UCI HAR Dataset" folder

#Load the required libraries for proper functioning of the code
library(dplyr)
library(tidyr)  
library(reshape2)

#Load the features given onto the data frame features
features <- read_delim("features.txt", delim = " ", col_names = FALSE)
#features has the second column as the name of all the vectors that are measured. 
#Extract them so it can be used as the column names for the measures data frame
featurenames <- dplyr::pull(features,X2 )

#Load the activity lables onto the data frame
activity <- read_delim("activity_labels.txt", delim = " ", col_names = FALSE)
#Assign names to the two columns extracted from the file as follows to be used for Merge later
names(activity) <- c("activityid", "activity")

#Load all the training data sets - measures, activities and subjects that took the exercise.
#Use trim_ws = TRUE to remove excess consecutive leading or trailing spaces
trainmeasure <- read_delim("train/X_train.txt", delim = " ", col_names = FALSE, trim_ws = TRUE)
trainactivity <- read_delim("train/y_train.txt", delim = " ", col_names = FALSE, trim_ws = TRUE)
trainsubject <- read_delim("train/subject_train.txt", delim = " ", col_names = FALSE)

#Assign proper meaningful names for all the data frames loaded
names(trainmeasure) <- featurenames
names(trainactivity) <- "activityid"
names(trainsubject) <- "subject"

#Training activities have only ID. 
#Match them with the reference data frame to assign proper activity names for all these IDs
trainactivity <- merge(trainactivity, activity)

#column bind all the three data frames - measures, activities and subjects to get 
#a consolidated training data frame
trainfull <- cbind(trainactivity, trainmeasure)
trainfull <- cbind(trainsubject, trainfull)

#remove the intermediate variables to conserve space. If you dont need this, comment the below lines
rm(trainactivity,trainmeasure,trainsubject)

#Load all the testing data sets - measures, activities and subjects that took the exercise.
#Use trim_ws = TRUE to remove excess consecutive leading or trailing spaces
testmeasure <- read_delim("test/X_test.txt", delim = " ", col_names = FALSE, trim_ws = TRUE)
testactivity <- read_delim("test/y_test.txt", delim = " ", col_names = FALSE, trim_ws = TRUE)
testsubject <- read_delim("test/subject_test.txt", delim = " ", col_names = FALSE)

#Assign proper meaningful names for all the data frames loaded
names(testmeasure) <- featurenames
names(testactivity) <- "activityid"
names(testsubject) <- "subject"

#Testing activities have only ID. 
#Match them with the reference data frame to assign proper activity names for all these IDs
testactivity <- merge(testactivity, activity)

#column bind all the three data frames - measures, activities and subjects to get 
#a consolidated testing data frame
testfull <- cbind(testactivity, testmeasure)
testfull <- cbind(testsubject, testfull)

#remove the intermediate variables to conserve space. If you dont need this, comment the below lines
rm(testactivity,testmeasure,testsubject)

#remove the intermediate variables to conserve space. If you dont need this, comment the below lines
rm(features,featurenames,activity)

#As requested the first dataset per assignment - create one consolidated data frame of both
#training and testing data using row bind
fulldata <- rbind(trainfull, testfull)

#remove the intermediate variables to conserve space. If you dont need this, comment the below lines
rm(trainfull,testfull)

#If you look at the data, all measures are present a individual columns. About 561 columns. 
#But for a clean tidy dataset to process, it is easier to have them as key value pair.
#So lets use the melt function to achieve it
#Keep the subject, activityid, activity as is. So they are kept as id.
#All other columns should be melted to key value pair for easier processing
tidydatafull <-  melt(fulldata, id=names(fulldata)[1:3], measure.vars = names(fulldata)[4:564])

#remove the intermediate variables to conserve space. If you dont need this, comment the below lines
rm(fulldata)

# rename the default column name 'variable' to a meaningful name 'measurement'
colnames(tidydatafull)[colnames(tidydatafull) == "variable"] <- "measurement"  

#Assignment needs to extract only the mean and standard deviation data alone for all the subjects and activities.
#Using the regular expression and grepl command, extract only the mean and std rows from the full tidy data frame
tidymeanstddata <- tidydatafull[grepl("*mean\\()*|*std\\()*", tidydatafull$measurement),]  # Extract only the measurements which are either a mean or a standard deviation

#Assigment's anohter request is to create a tidy dataset containing mean value of each measure with respect to 
# each subject and activity. To achieve this, lets first create a new data frame
# which is grouped by subject, activity, measurement.
# then chain it to summarise the 'value' column for finding the mean
groupedbytidydata <- tidymeanstddata %>% group_by(subject, activity, measurement) %>% 
  summarise(mean = mean(value))

write.table(groupedbytidydata, file = "step5tidydata.txt", row.name=FALSE)
#we can leave it here which will make a tidy data set for further processing. 

# But for quickly viewing the data or for final manual review this layout will not be useful.
# hence the below two lines are added so we get nice single row for each subject + activity combination
# all measures are now back to their own indivdual columns.
groupedbytidydataforreview <- groupedbytidydata %>%  
  spread(measurement, mean) %>% 
  ungroup() 