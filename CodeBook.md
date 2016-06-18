

This is a code book written in fulfilment of the Getting and Cleaning Data Course Project. The link to the data was provided at the
following website, https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip; 
and a description of how the data was collected came from the web site
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.  

One can also found it in the various files that came in the zipped data set.

In summary, the project requires one to:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.
  5. From the data set in step 4, creates a second, independent tidy data set
  with the average of each variable for each activity and each subject.

Here is how it was accomplished, descriptions can also be found in the code run_analysis.R.
1.  Merging the training and test data sets:
	The experiments were carried out with a group of 30 volunteers: subjects, each subject performed six activities (WALKING,
        WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. The
        files downloaded includes the following:  'README.txt', 'features_info.txt': Shows information about the variables used on the
        feature vector; 'features.txt': List of all features; 'activity_labels.txt': Links the class labels with their activity name;
        'train/X_train.txt': Training set; 'train/y_train.txt': Training labels; 'test/X_test.txt': Test set; 'test/y_test.txt': Test
         labels.

	Data sets were merged sequentially using rbind for each test and training set, 
	followed by cbind for the activity, subject and features data.  Column names were also added accordingly:
	 a. ActivityTestData from file test/Y_test.txt, combined with ActivityTrainData from file train/Y_train.txt
	 to make ActivityData.
	 b. SubjectTrainData from file train/subject_train.txt combined with SubjectTestData 
	 from file test/subject_test.txt to make SubjectData; 
	 c. FeaturesTestData from file test"/X_test.txt combined with FeaturesTrainData from file train/X_train.txt to make
	    FeaturesData. Column names for the Features data were obtained from the file features.txt.
	 d. cbind ActivityData with SubjectData to give SubActData
	e. cbind SubActData with FeaturesData to give the merged data set AllData.
2. 	Extracts only the measurements on the mean and standard deviation for each measurement
		FeaturesWanted:  contains the list for measurements on the mean and standard deviation,
		subData:  the data for the subset with just the FeaturesWanted

3. Uses descriptive activity names to name the activities in the data set
		activityLabels: list obtained from activity_labels.txt
		
4. Appropriately labels the data set with descriptive variable names.
	From features_info.txt : 
		"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ 
                and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. 
                Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency 
               of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration
               signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

		Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals
		(tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated 
		using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

		Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ,
		fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

		These signals were used to estimate variables of the feature vector for each pattern:  
		'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."
	Hence, substitute column name abbreviated with the full description:
		Acc to accelerometer
		Gyro to gyroscope
		prefix 't' to time
		prefix 'f' to frequency 
		Mag to magnitude
		BodyBody to Body.  
	List of variable names:
	> names(subData)
		[1] "subject"                                           
		[2] "activity"                                          
		[3] "timeBodyaccelerometer-mean()-X"                    
		[4] "timeBodyaccelerometer-mean()-Y"                    
		[5] "timeBodyaccelerometer-mean()-Z"                    
		[6] "timeBodyaccelerometer-std()-X"                     
		[7] "timeBodyaccelerometer-std()-Y"                     
		[8] "timeBodyaccelerometer-std()-Z"                     
		[9] "timeGravityaccelerometer-mean()-X"                 
		[10] "timeGravityaccelerometer-mean()-Y"                 
		[11] "timeGravityaccelerometer-mean()-Z"                 
		[12] "timeGravityaccelerometer-std()-X"                  
		[13] "timeGravityaccelerometer-std()-Y"                  
		[14] "timeGravityaccelerometer-std()-Z"                  
		[15] "timeBodyaccelerometerJerk-mean()-X"                
		[16] "timeBodyaccelerometerJerk-mean()-Y"                
		[17] "timeBodyaccelerometerJerk-mean()-Z"                
		[18] "timeBodyaccelerometerJerk-std()-X"                 
		[19] "timeBodyaccelerometerJerk-std()-Y"                 
		[20] "timeBodyaccelerometerJerk-std()-Z"                 
		[21] "timeBodygyroscope-mean()-X"                        
		[22] "timeBodygyroscope-mean()-Y"                        
		[23] "timeBodygyroscope-mean()-Z"                        
		[24] "timeBodygyroscope-std()-X"                         
		[25] "timeBodygyroscope-std()-Y"                         
		[26] "timeBodygyroscope-std()-Z"                         
		[27] "timeBodygyroscopeJerk-mean()-X"                    
		[28] "timeBodygyroscopeJerk-mean()-Y"                    
		[29] "timeBodygyroscopeJerk-mean()-Z"                    
		[30] "timeBodygyroscopeJerk-std()-X"                     
		[31] "timeBodygyroscopeJerk-std()-Y"                     
		[32] "timeBodygyroscopeJerk-std()-Z"                     
		[33] "timeBodyaccelerometermagnitude-mean()"             
		[34] "timeBodyaccelerometermagnitude-std()"              
		[35] "timeGravityaccelerometermagnitude-mean()"          
		[36] "timeGravityaccelerometermagnitude-std()"           
		[37] "timeBodyaccelerometerJerkmagnitude-mean()"         
		[38] "timeBodyaccelerometerJerkmagnitude-std()"          
		[39] "timeBodygyroscopemagnitude-mean()"                 
		[40] "timeBodygyroscopemagnitude-std()"                  
		[41] "timeBodygyroscopeJerkmagnitude-mean()"             
		[42] "timeBodygyroscopeJerkmagnitude-std()"              
		[43] "frequencyBodyaccelerometer-mean()-X"               
		[44] "frequencyBodyaccelerometer-mean()-Y"               
		[45] "frequencyBodyaccelerometer-mean()-Z"               
		[46] "frequencyBodyaccelerometer-std()-X"                
		[47] "frequencyBodyaccelerometer-std()-Y"                
		[48] "frequencyBodyaccelerometer-std()-Z"                
		[49] "frequencyBodyaccelerometer-meanFreq()-X"           
		[50] "frequencyBodyaccelerometer-meanFreq()-Y"           
		[51] "frequencyBodyaccelerometer-meanFreq()-Z"           
		[52] "frequencyBodyaccelerometerJerk-mean()-X"           
		[53] "frequencyBodyaccelerometerJerk-mean()-Y"           
		[54] "frequencyBodyaccelerometerJerk-mean()-Z"           
		[55] "frequencyBodyaccelerometerJerk-std()-X"            
		[56] "frequencyBodyaccelerometerJerk-std()-Y"            
		[57] "frequencyBodyaccelerometerJerk-std()-Z"            
		[58] "frequencyBodyaccelerometerJerk-meanFreq()-X"       
		[59] "frequencyBodyaccelerometerJerk-meanFreq()-Y"       
		[60] "frequencyBodyaccelerometerJerk-meanFreq()-Z"       
		[61] "frequencyBodygyroscope-mean()-X"                   
		[62] "frequencyBodygyroscope-mean()-Y"                   
		[63] "frequencyBodygyroscope-mean()-Z"                   
		[64] "frequencyBodygyroscope-std()-X"                    
		[65] "frequencyBodygyroscope-std()-Y"                    
		[66] "frequencyBodygyroscope-std()-Z"                    
		[67] "frequencyBodygyroscope-meanFreq()-X"               
		[68] "frequencyBodygyroscope-meanFreq()-Y"               
		[69] "frequencyBodygyroscope-meanFreq()-Z"               
		[70] "frequencyBodyaccelerometermagnitude-mean()"        
		[71] "frequencyBodyaccelerometermagnitude-std()"         
		[72] "frequencyBodyaccelerometermagnitude-meanFreq()"    
		[73] "frequencyBodyaccelerometerJerkmagnitude-mean()"    
		[74] "frequencyBodyaccelerometerJerkmagnitude-std()"     
		[75] "frequencyBodyaccelerometerJerkmagnitude-meanFreq()"
		[76] "frequencyBodygyroscopemagnitude-mean()"            
		[77] "frequencyBodygyroscopemagnitude-std()"             
		[78] "frequencyBodygyroscopemagnitude-meanFreq()"        
		[79] "frequencyBodygyroscopeJerkmagnitude-mean()"        
		[80] "frequencyBodygyroscopeJerkmagnitude-std()"         
		[81] "frequencyBodygyroscopeJerkmagnitude-meanFreq()"  
		
5. From the data set in step 4, creates a second, independent tidy data set 
     with the average of each variable for each activity and each subject.
	   newtable : contains the average of each variable for each activity and each subject
	   tidydata.txt: text file written from newtable created.	

			
