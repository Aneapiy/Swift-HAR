# Swift-HAR

User behavior analysis on iOS devices

## Notes

### Possible Ideas:
* Look at the accelerometer and gyro data to predict whether a user is sitting, walking, or running.
  * Log sensor data and tag the data.
  * Split the data into a training and a testing set. 
  * Train the classifier (maybe SVM or FFN).
  * Test the classifier with a subset of test data.
* Log what apps the user uses, for what duration, and what times of the data. Create an anomaly detector in case someone else starts using the phone.

### Machine learning APIs in Swift for iOS
1. Swift-AI
2. Swift-Brain

### References to look at:
1. http://systemg.research.ibm.com/ma-sensoranalytics.html
2. https://medium.com/@robringham/ios-motion-data-machine-learning-with-swift-and-r-1291f9ab7379#.p7x241ci4
3. http://blog.telenor.io/2015/10/26/machine-learning.html
4. http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6838194
5. http://www.icephd.org/sites/default/files/IWAAL2012.pdf
6. https://www.hackingwithswift.com/example-code/system/how-to-use-core-motion-to-read-accelerometer-data

### Swift Tutorials:
1. https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html
2. https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/
