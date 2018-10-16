//
//  ParametersTableViewController.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 30/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//
import UIKit

class ParametersTableViewController: UITableViewController, ServerSelectionDelegate {
    func didSelectServerType(serverType: ServerType) {
        switch serverType {
        case .orangeM2MProd:
            serverValue.text = "OrangeM2M Prod"
            break
        case .other:
            serverValue.text = "OrangeM2M PreProd"
            break
        }
    }
    
    @IBOutlet weak var versionApp: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var protocoleValue: UILabel!
    @IBOutlet weak var protocoleLabel: UILabel!
    @IBOutlet weak var serverValue: UILabel!
    @IBOutlet weak var apikeyValue: UILabel!
    @IBOutlet weak var usernameValue: UILabel!
    @IBOutlet weak var idClientValue: UILabel!
    @IBOutlet weak var deviceModel: UILabel!
    @IBOutlet weak var idAsset: UILabel!
    @IBAction func reinitAction(_ sender: Any) {
        apikeyValue.text = "Pas de clef d'API"
    }
    
    @IBAction func manuelAction(_ sender: UIButton) {
        showInputDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "Paramètres"
        apikeyValue.text = "ad842965e9f94bd5833b5fa7caf3086f"
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //        if let navController = navigationController {
        //            System.clearNavigationBar(forBar: navController.navigationBar)
        //            navController.view.backgroundColor = .clear
        //        }
        
        
        let userDefaults = UserDefaults.standard
        let currentServerTypeValue = userDefaults.integer(forKey: SERVER_TYPE_KEY)
        
        if let serverType = ServerType(rawValue: currentServerTypeValue) {
            self.didSelectServerType(serverType: serverType)
        }
        userDefaults.set(idClientValue.text, forKey: "idClientValue")
        userDefaults.set(usernameValue.text, forKey: "usernameValue")
        userDefaults.set(apikeyValue.text, forKey: "apikeyValue")
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func addTapped (sender:UIButton) {
        print("add pressed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushServerType" {
            if let serverTypeSelectionTableViewController = segue.destination as? ServerSelectionTableViewController {
                serverTypeSelectionTableViewController.parametersViewController = self
            }
        }
    }
    
    func showInputDialog(){
        let alertController = UIAlertController(title: "Clef d'API", message: "Merci de saisir la Clef d'API", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Entrer", style: .default){(_) in
            let apikey = alertController.textFields?[0].text
            self.apikeyValue.text = apikey
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.apikeyValue.text, forKey: "apikeyValue")
            userDefaults.synchronize()
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel){(_) in}
        alertController.addTextField{(textField) in
            textField.placeholder = "XXXXXXXXXXXXXXXXX"
        }
        
        //adding the action to dialogBox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally show the dialog box
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        let modelName = UIDevice.current.modelName
        
        deviceModel.text = modelName
        
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            idClientValue.text = "\(modelName)-\(identifierForVendor)"
            userDefaults.set(idClientValue.text, forKey: "idClientValue")
            userDefaults.synchronize()
            idAsset.text = "\(identifierForVendor)"
        }
        userDefaults.set(apikeyValue.text, forKey: "apikeyValue")
        userDefaults.synchronize()
        
    }
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPodTouch5"
        case "iPod7,1":                                 return "iPodTouch6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone4"
        case "iPhone4,1":                               return "iPhone4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone5s"
        case "iPhone7,2":                               return "iPhone6"
        case "iPhone7,1":                               return "iPhone6Plus"
        case "iPhone8,1":                               return "iPhone6s"
        case "iPhone8,2":                               return "iPhone6sPlus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone7Plus"
        case "iPhone8,4":                               return "iPhoneSE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone8Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhoneX"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad4"
        case "iPad6,11", "iPad6,17":                    return "iPad5" // iPad 2017
        case "iPad7,5", "iPad7,6":                      return "iPad6" // iPad 2018
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPadAir"
        case "iPad5,3", "iPad5,4":                      return "iPadAir2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPadMini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPadMini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPadMini3"
        case "iPad5,1", "iPad5,2":                      return "iPadMini4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2": return "iPad Pro"
        case "AppleTV5,3":                              return "AppleTV"
        case "AppleTV6,2":                              return "AppleTV4K"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
