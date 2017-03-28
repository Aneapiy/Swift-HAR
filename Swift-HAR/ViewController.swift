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

    @IBOutlet weak var accelXText: UITextField!
    @IBOutlet weak var accelYText: UITextField!
    @IBOutlet weak var accelZText: UITextField!
    @IBOutlet weak var gyroXText: UITextField!
    @IBOutlet weak var gyroYText: UITextField!
    @IBOutlet weak var gyroZText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        accelXText.delegate = self
        accelYText.delegate = self
        accelZText.delegate = self
        definesPresentationContext = true
        
        if manager.isGyroAvailable && manager.isAccelerometerAvailable && manager.isDeviceMotionAvailable {
            //Set sensor data updates to 0.1 seconds
            manager.accelerometerUpdateInterval = 0.1
            manager.gyroUpdateInterval = 0.1
            //Enable data updates from sensors
            //manager.startAccelerometerUpdates()
            manager.startGyroUpdates(to: .main) {
                [weak self] (data: CMGyroData?, error: Error?) in
                if (data?.rotationRate) != nil {
                    self?.gyroXText.text = "Gyro-X: " + String(format: "%.2f", (manager.gyroData?.rotationRate.x)!)
                    self?.gyroYText.text = "Gyro-Y: " + String(format: "%.2f", (manager.gyroData?.rotationRate.y)!)
                    self?.gyroZText.text = "Gyro-Z: " + String(format: "%.2f", (manager.gyroData?.rotationRate.z)!)
                }
            }
            
            manager.startAccelerometerUpdates(to: .main) {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                if (data?.acceleration) != nil {
                    self?.accelXText.text = "Accel-X: " + String(format: "%.2f", (manager.accelerometerData?.acceleration.x)!)
                    self?.accelYText.text = "Accel-Y: " + String(format: "%.2f", (manager.accelerometerData?.acceleration.y)!)
                    self?.accelZText.text = "Accel-Z: " + String(format: "%.2f", (manager.accelerometerData?.acceleration.z)!)
                }
            }
            
            /*
            let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector("stateUpdate"), userInfo: nil, repeats: true)
            */
        }
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
