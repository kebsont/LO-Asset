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
import Toast_Swift
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
    var currentHumid: Int = 0
    var currentRpm: Int = 0
    var currentCo: Int = 0
    var currentTemp: Int = 0
    var currentPression: Int = 0
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
//    @IBOutlet weak var telemetrieSwitch: UISwitch!
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
    
    @IBAction func switchAuto(_ sender: UISwitch) {
        if sender.isOn == true {
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
    @IBOutlet weak var getThatHumidite: UISlider!
    @IBAction func humidValueChanged(_ sender: UISlider) {
         currentHumid = Int(sender.value)
        humidLabel.text = "\(currentHumid)%"
        print(currentHumid)
    }
    @IBAction func tempValueChanged(_ sender: UISlider) {
         currentTemp = Int(sender.value)
        tempLabel.text = "\(currentTemp)°"
    }
    @IBAction func rpmValueChanged(_ sender: UISlider) {
         currentRpm = Int(sender.value)
        rpmLabel.text = "\(currentRpm) rpm"
    }
    @IBAction func coValueChanged(_ sender: UISlider) {
         currentCo = Int(sender.value)
        coLabel.text = "\(currentCo) ppm"
    }
    @IBAction func pressionValueChanged(_ sender: UISlider) {
         currentPression = Int(sender.value)
        pressionLabel.text = "\(currentPression) mBars"
    }
//    public func getHumidite() -> Int {
//        var newVal:Int = 0
//        newVal =
//        return newVal
//    }
    public func getCO2() -> Int {
        if var thisCO2:Int? = self.currentCo
        {
            thisCO2 =  currentRpm
            return thisCO2!
        }
    }
    
    public func getTemp() -> Int {
        if var thisTemp:Int? = self.currentTemp
        {
            thisTemp =  currentTemp
            return thisTemp!
        }
    }
    public func getPression() -> Int {
        if var thisPression:Int? = self.currentPression
        {
            thisPression =  currentPression
            return thisPression!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        locLatitude.text =  "\(round(locValue.latitude*1000000)/1000000)°"
        locLongitude.text = "\(round(locValue.longitude*1000000)/1000000)°"
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
        if(apiKey != nil){
            mqtt!.password = apiKey!
        }
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
        let preferences = AppPreferences()
        let interval = constant.DEFAULT_UPDATE_RATE
        let version = preferences.AppVersion
        print("ack: \(ack)")
        self.view.makeToast("\(ack)", duration: 3.0, position: .center)
        if ack == .accept {
//            isConnected = true
            print("Connexion success")
            self.view.makeToast("Connecté avec succès", duration: 3.0, position: .top)
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
            self.view.makeToast("Déconnecté avec succès", duration: 3.0, position: .top)

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
        let constant = ApplicationConstants()
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        var response = try encoder.encode(message.["cid"])
        print("messageEEE: \(message.string.description), id: \(id)")
        
        switch message.topic {
        case constant.MQTT_TOPIC_SUBSCRIBE_CONFIG:
            do{
            let decoder = JSONDecoder()
                let cfgData = (message.string)!.data(using: .utf8)!
                let decodedCfg = try decoder.decode(DeviceConfig.self, from: cfgData)
                
                print("Configgg")
                for cf in decodedCfg.cfg{
                    print(cf)
                }
//                print(decodedCfg.cfg["updateRate"].["v"])
            }catch{
                //HANdle error
            }
           
//            Modifier le log level
//            self.view.makeToast("Commande reçue: \(message.string!)", duration: 3.0, position: .top)
            break
        case constant.MQTT_TOPIC_SUBSCRIBE_COMMAND:
            if(message.string! == "buzzer"){
                self.view.makeToast("Commande Buzzer reçue:", duration: 3.0, position: .top)
            }
            break
        case constant.MQTT_TOPIC_SUBSCRIBE_RESOURCE:
            self.view.makeToast("New Resource Available: \(message.string!)", duration: 3.0, position: .top)
            break
        default:
            break
        }
        
//        mqtt.publish(constant.MQTT_TOPIC_RESPONSE_COMMAND , withString: message.string! )
//        mqtt.publish(<#T##topic: String##String#>, withString: <#T##String#>)
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
         self.view.makeToast("\(err.description)", duration: 3.0, position: .top)
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
