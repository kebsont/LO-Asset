//
//  SimulerTableViewController.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 01/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//
import UIKit
import Foundation
import MapKit
import CocoaMQTT
import os.log
class SimulerTableViewController: UITableViewController, CLLocationManagerDelegate {
    let defaultHost = "liveobjects.orange-business.com"
    var locationManager = CLLocationManager()
    var mqtt: CocoaMQTT?
    var msg: String?
    var idClient: String?
    var nomUtilisateur: String?
    var apiKey: String?
    var isConnected: Bool = false
    var MonSwitch: Bool = true
    @IBOutlet weak var connectButton: UIButton!
    @IBAction func connectOrDisconnect(_ sender: UIButton, forEvent event: UIEvent) {
        let currentLabel = connectButton.titleLabel!.text!
                if currentLabel == "CONNECTER" {
                    connectToServer()
                    sender.setTitle("DECONNECTER", for: .normal)
                }else{
                    mqtt!.disconnect()
                    connectButton.setTitle("CONNECTER", for: .normal)
                }
    }
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
    @IBAction func changeTelemetrie(telemetrieSwitch: UISwitch) {
        if telemetrieSwitch.isOn {
            MonSwitch = true
            temperatureSlider.isEnabled = false
            humiditeSlider.isEnabled = false
            rpmSlider.isEnabled = false
            coSlider.isEnabled = false
            pressionSlider.isEnabled = false
        }else{
            MonSwitch = false
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
        
        telemetrieSwitch.addTarget(self, action: Selector("changeTelemetrie:"), for: UIControlEvents.valueChanged)
        telemetrieSwitch.isOn = true
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.delegate = self
        msg = tabBarController?.selectedViewController?.tabBarItem.title
        mqttSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        //        userDefaults.synchronize()
        apiKey = userDefaults.string(forKey: "apikeyValue")
        idClient = userDefaults.string(forKey: "idClientValue")
        nomUtilisateur = userDefaults.string(forKey: "usernameValue")
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
     func connectToServer() {
        mqtt!.connect()
        if(mqtt!.connect()){
            isConnected = true
        }else{
            isConnected = false
        }
        
    }

    
    func mqttSetting() {
        let userDefaults = UserDefaults.standard
        apiKey = userDefaults.string(forKey: "apikeyValue")
        idClient = userDefaults.string(forKey: "iDAsset")
        nomUtilisateur = userDefaults.string(forKey: "usernameValue")
        let clientID = idClient!
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 1883)
        mqtt!.username = nomUtilisateur!
        mqtt!.password = apiKey!
        mqtt!.willMessage = CocoaMQTTWill(topic: "/cmd", message: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
    }
    
}
extension UITableViewController: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    public func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("trust: \(trust)")
        /// Validate the server certificate
        ///
        /// Some custom validation...
        ///
        /// if validatePassed {
        ///     completionHandler(true)
        /// } else {
        ///     completionHandler(false)
        /// }
        completionHandler(true)
    }
    
//     func createScheduler()->DeviceData{
//        let encoder = JSONEncoder()
//        var dataToSend: DeviceData? = nil
//        var mqtt: CocoaMQTT? = nil
//        let version = "v1.0.0"
//        let myAsset = Asset(model: UIDevice.current.modelName, version: version)
//        let constant = ApplicationConstants()
//
//        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
////
//             dataToSend =  dataD
//        }
//        return (dataToSend ?? nil)!
//    }

    
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        let encoder = JSONEncoder()
        let constant = ApplicationConstants()
        let interval = constant.DEFAULT_UPDATE_RATE

        print("ack: \(ack)")
        if ack == .accept {
            let version = "v1.0.0"
//            isConnected = true
            print("Connexion success")
            let ds = DeviceStatus(version: version)
            let myAsset = Asset(model: UIDevice.current.modelName, version: version)
            do{
                
                encoder.outputFormatting = .prettyPrinted
                let dataConfig = try encoder.encode(myAsset.config)
                let dataStatus = try encoder.encode(ds)
                
                // Publish the current device status
                 mqtt.publish(constant.MQTT_TOPIC_PUBLISH_STATUS, withString: String(data: dataStatus, encoding: .utf8)!)
                
                // Publish the current device Settings
                mqtt.publish(constant.MQTT_TOPIC_PUBLISH_CONFIG , withString: String(data: dataConfig, encoding: .utf8)!)
                
                
                // Subscribe to TOPICS for Config, Command and Resource
                mqtt.subscribe(constant.MQTT_TOPIC_SUBSCRIBE_CONFIG)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    mqtt.subscribe(constant.MQTT_TOPIC_SUBSCRIBE_COMMAND)
                }
            } catch {
                //TODO: handle error
            }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    mqtt.subscribe(constant.MQTT_TOPIC_SUBSCRIBE_COMMAND)
//                }
               
                    _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
                        var telemetry = myAsset.getNexTelemetry()
                        print("Voici le CO2")
                        print(telemetry.getCo2())
                        var loc: [Double] = myAsset.getNextLocation()
                        var dataD: DataDevice =  myAsset.createDataDevice(value: telemetry, loc: loc)
                  do{
                    var newData = try encoder.encode(dataD)
                        mqtt.publish(constant.MQTT_TOPIC_PUBLISH_DATA, withString: String(data: newData, encoding: .utf8)!)
                  }catch{
                    //TODO: handle error
                        }
                        
                }
               
                
                
                
           
         
        }
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        let constant = ApplicationConstants()
        print("new state: \(state)")
        if(state  == .disconnected){
            mqtt.unsubscribe(constant.MQTT_TOPIC_SUBSCRIBE_CONFIG)
            mqtt.unsubscribe(constant.MQTT_TOPIC_SUBSCRIBE_COMMAND)
        }
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("message: \(message.string.description), id: \(id)")
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
    }
    
    public  func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("message: \(message.string.description), id: \(id)")
        
        //        let name = NSNotification.Name(rawValue: "MQTTMessageNotification" \ msg!)
        //        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
    }
    
    public  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    public  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    public   func mqttDidPing(_ mqtt: CocoaMQTT) {
        print()
    }
    
    public  func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print()
    }
    
    public  func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("\(err.description)")
    }
}

extension UITableViewController: UITabBarControllerDelegate {
    // Prevent automatic popToRootViewController on double-tap of UITabBarController
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
}

//extension UITableViewController {
//    func print(_ message: String = "", fun: String = #function) {
//        let names = fun.components(separatedBy: ":")
//        var prettyName: String
//        if names.count == 1 {
//            prettyName = names[0]
//        } else {
//            prettyName = names[1]
//        }
//
//        if fun == "mqttDidDisconnect(_:withError:)" {
//            prettyName = "didDisconect"
//        }
//
//        print("[print] [\(prettyName)]: \(message)")
//    }
//}
extension Optional {
    // Unwarp optional value for printing log only
    var description: String {
        if let warped = self {
            return "\(warped)"
        }
        return ""
    }
}
