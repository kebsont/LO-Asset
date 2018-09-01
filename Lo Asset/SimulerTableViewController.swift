//
//  SimulerTableViewController.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 01/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit
import MapKit
class SimulerTableViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @IBOutlet weak var telemetrieSwitch: UISwitch!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var rpmLabel: UILabel!
    @IBOutlet weak var rpmSlider: UISlider!
 
    @IBOutlet weak var coLabel: UILabel!
    @IBOutlet weak var coSlider: UISlider!
    
    @IBOutlet weak var pressionLabel: UILabel!
    @IBOutlet weak var pressionSlider: UISlider!
    
    @IBOutlet weak var humiditeSlider: UISlider!
    @IBOutlet weak var locLatitude: UILabel!
    @IBOutlet weak var locLongitude: UILabel!
    @IBAction func changeTelemetrie(_ sender: UISwitch) {
        if telemetrieSwitch.isOn {
            temperatureSlider.isEnabled = false
            humiditeSlider.isEnabled = false
            rpmSlider.isEnabled = false
            coSlider.isEnabled = false
            pressionSlider.isEnabled = false
        }else{
            temperatureSlider.isEnabled = true
            humiditeSlider.isEnabled = true
            rpmSlider.isEnabled = true
            coSlider.isEnabled = true
            pressionSlider.isEnabled = true
        }
    }
    @IBAction func humidValueChanged(_ sender: UISlider) {
        let currentHumid = Int(sender.value)
        humidLabel.text = "\(currentHumid)%"
    }
    @IBAction func tempValueChanged(_ sender: UISlider) {
        let currentTemp = Int(sender.value)
        tempLabel.text = "\(currentTemp)°"
    }
    @IBAction func rpmValueChanged(_ sender: UISlider) {
        let currentRpm = Int(sender.value)
        rpmLabel.text = "\(currentRpm) rpm"
    }
    @IBAction func coValueChanged(_ sender: UISlider) {
        let currentCo = Int(sender.value)
        coLabel.text = "\(currentCo) ppm"
    }
    @IBAction func pressionValueChanged(_ sender: UISlider) {
        let currentPression = Int(sender.value)
        pressionLabel.text = "\(currentPression) mBars"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        telemetrieSwitch.isOn = false
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locLatitude.text = "\(locValue.latitude)°"
        locLongitude.text = "\(locValue.longitude)°"
    }
   

}
