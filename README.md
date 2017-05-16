# Swift-HAR

Human activity recognition on iPhone 6s with Swift, CoreMotion, and a Feed-Forward Neural Network classifier from Swift-AI.

Columbia University EECS E6895 Advanced Big Data Analytics (Spring 2017) Final Project by nh2518

## Abstract
Human activity recognition (HAR) is the use of sensors and algorithms to classify human action. Applications of HAR in healthcare involve remote monitoring of patient physical activity, detecting falls in elderly patients, and helping classify movement in patients with motion disorders. HAR can also be used in wearable electronics that track user exercise and activity. In this paper, I demonstrate an HAR application written in Swift 3.1 for the iPhone 6s running iOS 10.3.1. Data logs gathered from the CoreMotion API feeds into a Feed Forward Neural Network created using the Swift-AI framework. Both training and inference from the neural network is executed locally in an iPhone 6s. The neural network can recognize multiple repetitive and continuous activities by changing the number of output nodes to match the number of unique activities the user logs. The trained neural network successfully classifies the tested user activities of standing still, walking, or doing bicep curls.

## Progress
- [x] UI to display results and gather user input.
- [x] Data logger to record accelerometer data from an iPhone 6s.
- [x] Data exporter to save data in CSV format.
- [x] Bootstrapper to create testing and training data for the NeuralNet.
- [x] Set up and configure the NeuralNet object for activity classification.
- [x] Hook up the NeuralNet to classify untagged user activity.
- [x] Midnight dance party cause it works!
- [x] Add support for additional activities (running, sit ups, weight lifting, etc.)
- [ ] Rewrite the spaghetti code in the ViewController into classes.

## Swift-HAR Overview
Summary: Use accelerometer data to predict what action the user is doing.

The Swift-HAR app uses Swift 3.1 and runs on iOS 10.3.1 or later. The app was written using Xcode 8.3.2. The app accesses accelerometer and gyroscope data using the Swift CoreMotion API. The classifier is a feed-forward neural network (FFNN) created using the NeuralNet class of Swift-AI [7]. Currently, Swift-HAR classifies user action based only on the tri-axis accelerometer data. At this time, Swift-HAR only supports repetitive and continuous activities such as walking, running, standing still, bicep curls, jump roping, etc. Swift-HAR does not support non-periodic activities such playing tennis, playing basketball, fencing, golfing, etc.

To record training data, the user enters the tag for the activity in the text field that says “Enter your action here!” and presses the “Record Data” button. The user then has 2 seconds to start doing the activity. An audible “beep” signals that Swift-HAR has started recording data. A second “beep” signals that Swift-HAR has finished recording data for that activity (~15 seconds after the first beep). The recorded acceleration data for the three axes is then exported into a csv file saved in the app’s document folder as well as kept in memory.

Once the user is done recording different activities, pressing “Train NeuralNet” will take all of the recorded data stored in memory and use it to train a classifier. Each activity’s data set will be bootstrapped into a training and testing set along with the user’s activity tag. The data then feeds into a 3 layer feed-forward neural network with 300 input nodes (100 nodes for each axis), 240 hidden layer nodes, and a number of output nodes equal to the number of unique activities the user has logged.

After training, the NeuralNet is ready to classify user activities. The user can ask Swift-HAR to guess an activity by pressing the “Guess Action” button. Swift-HAR will then log data for ~15 seconds, and provide a guess of what activity the neural network thinks the user just performed.

## Notes

### Machine learning API in Swift for iOS:
Special thanks to Collin Hundley and the Swift AI team for providing code for the neural network used as a classifier for this project.
1. [NeuralNet module from Swift-AI by Collin Hundley.](https://github.com/Swift-AI/NeuralNet)

### References:
1. D. Anguita, A. Ghio, L. Oneto, X. Parra, and J. L. Reyes-Ortiz, "A Public Domain Dataset for Human Activity Recognition using Smartphones," in ESANN, 2013.
2. D. Anguita, A. Ghio, L. Oneto, X. Parra, and J. L. Reyes-Ortiz, "Energy Efficient Smartphone-Based Activity Recognition using Fixed-Point Arithmetic," J. UCS, vol. 19, no. 9, pp. 1295-1314, 2013.
3. Apple. (2017, February 23, 2017). API Reference. Available: https://developer.apple.com/reference/
4. A. Wearables. (March, 30). Wristband 2. Available: https://www.atlaswearables.com/wristband2/
5. K. Coble, "AI Toolbox," ed, 2017.
6. D. Anguita, A. Ghio, L. Oneto, X. Parra, and J. L. Reyes-Ortiz, "Human activity recognition on smartphones using a multiclass hardware-friendly support vector machine," presented at the Proceedings of the 4th international conference on Ambient Assisted Living and Home Care, Vitoria-Gasteiz, Spain, 2012. 
7. C. Hundley. (2017). Swift-AI/NeuralNet. Available: https://github.com/Swift-AI/NeuralNet
8. B. Remseth and J. Jongboom, "Live analyzing movement through machine learning," in Engineering @TelenorDigital vol. 2017, ed, 2015.
9. J. L. Reyes-Ortiz, D. Anguita, L. Oneto, and X. Parra, "Smartphone-Based Recognition of Human Activities and Postural Transitions Data Set," ed. UCI Machine Learning Repository, 2015.
10. R. Smith and J. Ho. (2017, February 23, 2017). The Apple iPhone 6s and iPhone 6s Plus Review. Available: http://www.anandtech.com/show/9686/the-apple-iphone-6s-and-iphone-6s-plus-review/5
11. X. Su, H. Tong, and P. Ji, "Activity recognition with smartphone sensors," Tsinghua Science and Technology, vol. 19, no. 3, pp. 235-249, 2014.

### Other threads consulted:
1. http://systemg.research.ibm.com/ma-sensoranalytics.html
2. https://medium.com/@robringham/ios-motion-data-machine-learning-with-swift-and-r-1291f9ab7379#.p7x241ci4
3. http://blog.telenor.io/2015/10/26/machine-learning.html
4. http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6838194
5. http://www.icephd.org/sites/default/files/IWAAL2012.pdf
6. https://www.hackingwithswift.com/example-code/system/how-to-use-core-motion-to-read-accelerometer-data
7. http://nshipster.com/cmdevicemotion/
8. https://medium.com/@0xben/using-github-with-xcode-6-8208b92c7a60#.tztc1xfqr
9. http://www.mydrivesolutions.com/engineering/swift-data-collection/
10. https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html
11. https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/
12. Accelerometer data recorder: https://developer.apple.com/reference/coremotion/cmsensorrecorder
13. Ben Cormier's tutorial on "Swift Tutorial: Core Motion (Accelerometer/Gyroscope)"
14. https://www.sitepoint.com/creating-hello-world-app-swift/
15. http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
16. delay function: http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
17. http://mrgott.com/swift-programing/18-how-to-run-ios-application-on-your-iphone-using-xcode-7
