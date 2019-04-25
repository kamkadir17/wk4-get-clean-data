# wk4-get-clean-data
Assignment Submission for the course getting and cleaning data
==================================================================
Data Analysis on Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Kadiresan Dhanasekaran
==================================================================

For the code to work, pls have the working directory pointed to the Samsung data at "UCI HAR Dataset" folder.

The purpose of this code is to analyze various files given as part of the Samsung Data such as 

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'train/subject_train.txt': Training subjects.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'test/subject_test.txt': Test subjects.


It takes in all these files and appropriately joins and binds the relevant files inorder to 
create a compete full data set that contains all the features measured in both train & test files

Then as requested it extracts only the mean and standard deviation measures and creates a subsequent dataset that will be 
further be used to do additional group by processing inorder to arrive at the final tidy data set requested in the assignment.

Below is the design approach of the entire code

. Set your working directory at the "UCI HAR Dataset" folder

. Load the required libraries for proper functioning of the code

. Load the features given onto the data frame features

. Features has the second column as the name of all the vectors that are measured. 

. Extract them so it can be used as the column names for the measures data frame

. Load the activity lables onto the data frame

. Assign names c("activityid", "activity") to the two columns extracted from the file as follows to be used for Merge later

. Load all the training data sets - measures, activities and subjects that took the exercise.

. Assign proper meaningful names for all the data frames loaded

. Training activities have only ID. 
. Match them with the reference data frame to assign proper activity names for all these IDs

. Column bind all the three data frames - measures, activities and subjects to get a consolidated training data frame

. Remove the intermediate variables to conserve space wherever appropriate. If you dont need these variable then comment the rm code following the comment

. Do the same steps for test data sets as well

. As requested the first dataset per assignment - create one consolidated data frame of both training and testing data using row bind

. If you look at the data at this point in time, all measures are present as individual columns. About 561 columns. But for a clean tidy dataset to process, it is easier to have them as key value pair. So lets use the melt function to achieve it. Keep the subject, activityid, activity as is. So they are kept as id.

. All other columns should be melted to key value pair for easier processing

. Rename the default column name 'variable' to a meaningful name 'measurement'
colnames(tidydatafull)[colnames(tidydatafull) == "variable"] <- "measurement"  

. Assignment needs to extract only the mean and standard deviation data alone for all the subjects and activities. Using the regular expression and grepl command, extract only the mean and std rows from the full tidy data frame

. Assignment's another request is to create a tidy dataset containing mean value of each measure with respect to each subject and activity. To achieve this, lets first create a new data frame which is grouped by subject, activity, measurement. Then chain it to summarise the 'value' column for finding the mean

. Write to an output file

. We can leave it here which will make a tidy data set for further processing. 

. But for quickly viewing the data or for final manual review this layout will not be useful. Hence the below two lines are added so we get nice single row for each subject + activity combination all measures are now back to their own individual columns.
