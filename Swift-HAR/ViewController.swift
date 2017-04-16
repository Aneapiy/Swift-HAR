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
    
    // MARK: Buttons
    @IBAction func recDataButtonPressed(_ sender: Any) {
        print("Record Button Clicked!")
        //Can't use CMSensorRecorder cause not compatible with iPhone 6s.
        self.startLoggingData()
        
    }
    
    @IBAction func retDataButtonPressed(_ sender: Any) {
        
    }
    @IBAction func startLiveRecBPressed(_ sender: Any) {
        print("Start Live Update Button Clicked!")
        self.startLiveUpdates()
    }
    @IBAction func stopLiveRecBPressed(_ sender: Any) {
        print("Stop Live Update Button Clicked!")
        self.stopUpdates()
    }
    // MARK: Main constants and vars
    let updateInterval = 0.1
    let dataLogTime = 10.0 //seconds
    var columnNum:Int = 0
    var timer = Timer()
    var counter = 0
    var i = 0
    var dataInd = 0.0
    var ax = 0.0
    var ay = 0.0
    var az = 0.0
    
    //Create an emtpy array to store the data
    var dataMatrix = [[Double]]()
    
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
        columnNum = Int(dataLogTime/updateInterval)
        dataMatrix = Array(repeating: Array(repeating:0.0, count: 4), count: columnNum)
        
        if manager.isGyroAvailable && manager.isAccelerometerAvailable && manager.isDeviceMotionAvailable {
            //Set sensor data updates to 0.1 seconds
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
        //start accelerometer data and loop through the dataMatrix to store data
        manager.startAccelerometerUpdates(to: .main) {
            [weak self] (data: CMAccelerometerData?, error: Error?) in
            if (data?.acceleration) != nil {
                self?.ax = (data?.acceleration.x)!
                self?.ay = (data?.acceleration.y)!
                self?.az = (data?.acceleration.z)!
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: updateInterval, target:self, selector: #selector(self.recordToDataMatrix), userInfo: nil, repeats: true)
    }

    func recordToDataMatrix(){
        if i == columnNum{
            self.timer.invalidate()
            print("Finished logging data")
            print(dataMatrix) //for testing only
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
            dataInd += self.updateInterval
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
