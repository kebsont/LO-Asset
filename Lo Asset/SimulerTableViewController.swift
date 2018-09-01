//
//  SimulerTableViewController.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 01/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

class SimulerTableViewController: UITableViewController {
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
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

}
