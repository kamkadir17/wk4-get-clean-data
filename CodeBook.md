This script uses the samsung dataset for analysis and does the following

1. Creates 3 new datasets which are to tidy up the given data
- tidydatafull
- tidymeanstddata
- groupedbytidydata

2. The given data is not in a key value pair format. The script merges the data from various files of samsung data folder and finally creates datasets that have the below 5 columns 

subject - subject who did the exercise
activityid - activity id the subject performed
activity   - actual activity name
measurement - key of the various measures / vectors captured in the samsung data set
value   - corresponding value of the measure

3. The groupedbytidydata dataset alone will not have activity id as it is not necessary.

