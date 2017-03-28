# Swift-HAR

Human activity recognition on iPhones using Swift.

## Notes

### Code outline:
Summary: Look at the accelerometer and gyro data to predict whether a user is sitting, walking, or running.
1. Read accelerometer and gyro data for 1 activity for 30 seconds.
2. Write the recorded data from memory to a file along with a tag.
4. Create multiple data files by using a sliding window to sample the 30 second data.
2. Split the data into a training and a testing set. 
3. Train the classifier (maybe SVM or FFN).
4. Test the classifier with a subset of test data.

### Machine learning APIs in Swift for iOS
1. Swift-AI
2. Swift-Brain

### References:
1. http://systemg.research.ibm.com/ma-sensoranalytics.html
2. https://medium.com/@robringham/ios-motion-data-machine-learning-with-swift-and-r-1291f9ab7379#.p7x241ci4
3. http://blog.telenor.io/2015/10/26/machine-learning.html
4. http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6838194
5. http://www.icephd.org/sites/default/files/IWAAL2012.pdf
6. https://www.hackingwithswift.com/example-code/system/how-to-use-core-motion-to-read-accelerometer-data
7. http://nshipster.com/cmdevicemotion/
8. https://medium.com/@0xben/using-github-with-xcode-6-8208b92c7a60#.tztc1xfqr

### Swift Tutorials:
1. https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html
2. https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/

### Swift StackExchange threads:
1. http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file

### Xcode help
1. http://mrgott.com/swift-programing/18-how-to-run-ios-application-on-your-iphone-using-xcode-7
