# Readme
This is the "Readme" file for the Week 4 Assignment - Getting and Cleaning Data Course

Author: Karl Melgarejo (19.09.2021)

Generalities: The code "run_analysis.R" performs all the activities required for this assignment.
First, it creates a local file to download the data, then it downloads it and unzips it.
Finally, the code reads the data into R and performs the required activities.

About the data: As the "Readme" file mentions (of the data provided), the data sets "X_train" and "X_test" have 
the data of Training and Test, which are required for the first question. 

Question 1: To answer the first question, "X_train" and "X_test" are merged in the data named "TT_DS".

Question 2: To answer the second question, the "apply" function is used, the mean and standard deviation
are included in the data set "m" and "s".

Question 3: To answer the third question, the "Activity" information was included in the merged data set
and a loop is performed to name the activities in the merged data set "TT_DS".

Question 4: To answer the fourth question, information of the variable labels was included. Then the variables
are labeled by using the function "labels". Now the merged data "TT_DS" includes labels for the variables.

Question 5: To answer the final question, information of the "subjects" was included. Then the "TT_DS" data 
was reshaped and grouped. With these operations, then the function "summarize" was used to calculate
average values of each variable, each subject and each activity. The data set "New_Data" has this information.

## End.
