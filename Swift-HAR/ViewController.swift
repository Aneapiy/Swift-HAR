//
//  ViewController.swift
//  Swift-HAR
//
//  Created by Nond on 3/25/17.
//  Copyright © 2017 BDAC. All rights reserved.
//

import UIKit
import CoreMotion

let manager = CMMotionManager()

class ViewController: UIViewController {
    
    // MARK: Var outlets
    
    @IBOutlet weak var accelXText: UITextField!
    @IBOutlet weak var accelYText: UITextField!
    @IBOutlet weak var accelZText: UITextField!
    @IBOutlet weak var gyroXText: UITextField!
    @IBOutlet weak var gyroYText: UITextField!
    @IBOutlet weak var gyroZText: UITextField!
    @IBOutlet weak var currentAppStatus: UITextView!
    
    // MARK: Buttons
    @IBAction func recDataButtonPressed(_ sender: Any) {
        print("Record Button Clicked!")
        //Can't use CMSensorRecorder cause not compatible with iPhone 6s.
        self.startLoggingData()
        
    }
    
    @IBAction func saveBPressed(_ sender: Any) {
        self.exportToText()
    }

    
    @IBAction func startLiveRecBPressed(_ sender: Any) {
        print("Start Live Update Button Clicked!")
        self.startLiveUpdates()
    }
    @IBAction func stopLiveRecBPressed(_ sender: Any) {
        print("Stop Live Update Button Clicked!")
        self.stopUpdates()
    }
    
    @IBAction func recSavStandBPressed(_ sender: Any) {
        actionType = "standing"
        self.startLoggingData()
        delay(14){self.exportToText()}
    }
    
    @IBAction func recSaveWalkBPressed(_ sender: Any) {
        actionType = "walking"
        self.startLoggingData()
        delay(14){self.exportToText()}
    }
    
    
    
    // MARK: Main constants and vars
    let updateInterval = 0.01
    let dataLogTime = 10.0 //seconds
    var rowNum:Int = 0
    var timer = Timer()
    var counter = 0
    var i = 0
    var dataInd: Float = 0.0
    var ax: Float = 0.0
    var ay:Float = 0.0
    var az:Float = 0.0
    var actionType = "unDefData"
    var bootTrainDataNum = 80
    var bootTestDataNum = 20
    var bootStepSize = 0
    var ptsPerData = 100
    
    //Create an FFNN instance
    let network = FFNN(inputs: 100, hidden: 64, outputs: 2, learningRate: 0.7, momentum: 0.4, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: false))
    
    //Create an empty array to store the data
    // Try just looking at the z acceleration for now to test FFNN
    var dataMatrix = [[Float]]()
    var standTrainMatrix = [[Float]]()
    var walkTrainMatrix = [[Float]]()
    var standTestMatrix = [[Float]]()
    var walkTestMatrix = [[Float]]()
    
    // MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        accelXText.delegate = self
        accelYText.delegate = self
        accelZText.delegate = self
        definesPresentationContext = true
        
        //default values on init
        accelXText.text = "Accel-X: 0.0"
        accelYText.text = "Accel-Y: 0.0"
        accelZText.text = "Accel-Z: 0.0"
        gyroXText.text = "Gyro-X: 0.0"
        gyroYText.text = "Gyro-Y: 0.0"
        gyroZText.text = "Gyro-Z: 0.0"
        rowNum = Int(dataLogTime/updateInterval)
        bootStepSize = rowNum/(bootTrainDataNum + bootTestDataNum)
        
        //Preallocate matrices for storing data
        dataMatrix = Array(repeating: Array(repeating:0.0, count: 4), count: rowNum)
        standTrainMatrix = Array(repeating: Array(repeating: 0.0, count: ptsPerData), count: bootTrainDataNum)
        walkTrainMatrix = Array(repeating: Array(repeating: 0.0, count: ptsPerData), count: bootTrainDataNum)
        standTestMatrix = Array(repeating: Array(repeating: 0.0, count: ptsPerData), count: bootTrainDataNum)
        walkTestMatrix = Array(repeating: Array(repeating: 0.0, count: ptsPerData), count: bootTrainDataNum)
        
        if manager.isGyroAvailable && manager.isAccelerometerAvailable && manager.isDeviceMotionAvailable {
            //Set sensor data updates to the updateInterval
            manager.accelerometerUpdateInterval = updateInterval
            manager.gyroUpdateInterval = updateInterval

        }
    }
    // MARK: Output data functions
    func outputAccData(acceleration: CMAcceleration){
        accelXText.text = "Accel-X: " + "\(acceleration.x).2fg"
        accelYText.text = "Accel-Y: " + "\(acceleration.y).2fg"
        accelZText.text = "Accel-Z: " + "\(acceleration.z).2fg"
        // NSLog("%f, %f, %f", acceleration.x, acceleration.y, acceleration.z)
    }
    
    func outputGyroData(rotation: CMRotationRate){
        gyroXText.text = "Gyro-X: " + "\(rotation.x).2fg"
        gyroYText.text = "Gyro-Y: " + "\(rotation.y).2fg"
        gyroZText.text = "Gyro-Z: " + "\(rotation.z).2fg"
    }
    
    func startLiveUpdates(){
        manager.startAccelerometerUpdates(to: .main) {
            [weak self] (data: CMAccelerometerData?, error: Error?) in
            if (data?.acceleration) != nil {
                self?.outputAccData(acceleration: (data?.acceleration)!)
            }
        }
        manager.startGyroUpdates(to: .main) {
            [weak self] (data: CMGyroData?, error: Error?) in
            if (data?.rotationRate) != nil {
                self?.outputGyroData(rotation: (data?.rotationRate)!)
            }
        }
    }
    
    func startLoggingData(){
        print("Start logging data")
        currentAppStatus.text = "Data Logging Started"
        //start accelerometer data and loop through the dataMatrix to store data
        manager.startAccelerometerUpdates(to: .main) {
            [weak self] (data: CMAccelerometerData?, error: Error?) in
            if (data?.acceleration) != nil {
                self?.ax = Float((data?.acceleration.x)!)
                self?.ay = Float((data?.acceleration.y)!)
                self?.az = Float((data?.acceleration.z)!)
            }
        }
        delay(0.5){
            self.timer = Timer.scheduledTimer(timeInterval: self.updateInterval, target:self, selector: #selector(self.recordToDataMatrix), userInfo: nil, repeats: true)
        }
    }

    func recordToDataMatrix(){
        if i == rowNum{
            self.timer.invalidate()
            print("Finished logging data")
            print(dataMatrix) //for testing only
            currentAppStatus.text = "Data Logging Complete"
            i = 0
            dataInd = 0.0
            stopUpdates()
        }
        else {
            dataMatrix[i][0] = dataInd
            dataMatrix[i][1] = ax
            dataMatrix[i][2] = ay
            dataMatrix[i][3] = az
            i += 1
            dataInd += Float(self.updateInterval)
        }
    }
    func stopUpdates(){
        manager.stopAccelerometerUpdates()
        manager.stopGyroUpdates()
        self.timer.invalidate()
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()){
        //function from stack overflow. Delay in seconds
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        
    }
    
    func exportToText(){
        print("Exporting")
        currentAppStatus.text = "Exporting..."
        /*
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("dataFile.txt")
        (dataMatrix[0] as NSArray).write(to: fileURL, atomically: true)
        */
        
        //this is the file. we will write to. The name of the file will be the action tag TODO
        //let file = "dataLog.txt"
        
        let file = makeFileName(actionType)
        
        let exportText = flattenDataMatrix(dataMatrix)
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //writing
            do {
                try exportText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
                print("Export Successful!")
                currentAppStatus.text = "Export Complete!"
            }
            catch {print(error)} //and then QQ in the fetal position
            /*
            do {
                let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print("\(text2)")
            }
            catch {/* error handling here */}
            */
        }
    }
    
    func flattenDataMatrix(_ arr2D: [[Float]]) -> String {
        var returnString = "time,accelx,accely,accelz"
        for row in arr2D {
            let stringArray = row.flatMap{String($0)}
            let string = stringArray.joined(separator: ",")
            returnString.append("\n"+string)
        }
        
        return returnString
    }
    
    func makeFileName(_ state: String) -> String {
        return state + "_" + fileTagger() + ".csv"
    }
    
    func fileTagger() -> String {
        let date = Date()
        let dateString = date.description
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let dateTag = dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 10)).replacingOccurrences(of: "-", with: "")
        return "\(dateTag)-\(hour)\(minutes)\(seconds)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*func stateUpdate() {
        if manager.accelerometerData != nil {
            accelXText.text = String(format: "%.2f", (manager.accelerometerData?.acceleration.x)!)
        }
    }*/
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
