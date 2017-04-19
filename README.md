# Swift-HAR

Human activity recognition on iPhones using Swift, CoreMotion, and a
Feed-Forward Neural Network from Swift-AI.

## Progress
- [x] UI to display results and gather user input.
- [x] Data logger to record accelerometer data from an iPhone 6s.
- [x] Data exporter to save data in CSV format.
- [x] Bootstrapper to create testing and training data for the NeuralNet.
- [x] Set up and configure the NeuralNet object for activity classification.
- [x] Hook up the NeuralNet to classify untagged user activity.
- [x] Midnight dance party cause it works!
- [ ] Rewrite the spaghetti code in the ViewController into classes.
- [ ] Add support for additional activities (running, sit ups, weight lifting, etc.)

## Notes

### Current Code outline:
Summary: Use accelerometer data to predict whether a user is standing or walking.
1. Read accelerometer data for 1 activity for 10 seconds.
2. Tag the data as standing or walking.
3. Repeat steps 1 and 2 for the second activity.
4. Bootstrap the recorded data using a 1 second window to create training and testing files for the NeuralNet.
5. Train the NeuralNet based on the training and testing file.
6. Now the NeuralNet is ready to classify user activities.

### Machine learning APIs in Swift for iOS
1. [NeuralNet module from Swift-AI by Collin Hundley.](https://github.com/Swift-AI/NeuralNet)

### References:
1. http://systemg.research.ibm.com/ma-sensoranalytics.html
2. https://medium.com/@robringham/ios-motion-data-machine-learning-with-swift-and-r-1291f9ab7379#.p7x241ci4
3. http://blog.telenor.io/2015/10/26/machine-learning.html
4. http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6838194
5. http://www.icephd.org/sites/default/files/IWAAL2012.pdf
6. https://www.hackingwithswift.com/example-code/system/how-to-use-core-motion-to-read-accelerometer-data
7. http://nshipster.com/cmdevicemotion/
8. https://medium.com/@0xben/using-github-with-xcode-6-8208b92c7a60#.tztc1xfqr
9. http://www.mydrivesolutions.com/engineering/swift-data-collection/

### Swift Tutorials:
1. https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html
2. https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/
3. Accelerometer data recorder: https://developer.apple.com/reference/coremotion/cmsensorrecorder
4. Ben Cormier's tutorial on "Swift Tutorial: Core Motion (Accelerometer/Gyroscope)"
5. https://www.sitepoint.com/creating-hello-world-app-swift/

### Swift StackExchange threads:
1. http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
2. delay function: http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861

### Xcode help
1. http://mrgott.com/swift-programing/18-how-to-run-ios-application-on-your-iphone-using-xcode-7
