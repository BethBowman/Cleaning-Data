# Cleaning-Data
Final Project

README

To process this data, I read in the X_ and Y_ data sets as well as the subject names. While I read these in as individual files, I then combined them and renamed the column titles to more accurately represent what the columns had. After adding a column to describe if the data was a “test” or “training” data, I combined the data.

Next, renamed the values in the activity column to correspond with the value that each number represented

Because the X_ set or now newly named “data” column includes values for 561 different data types, I wanted to pull from this data that represented the information for mean and std values. To do this, I first defined which value position (index) had this data. I then added these indexes in the data set so that I could pull from the data column the right values. Finally, I used this index number to pull the data from the data column. After this, I removed the messy “data” column.

To find the averages, I created a new data frame, “avgData” that is initiated on the average value for the first mean data set. Then I added to this data frame by cycling through each of the next data columns and added the mean values by subject and activity. 

My code is heavily commented throughout so I hope this in combination with the comments will help.
