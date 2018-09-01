//
//  ParametersTableViewController.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 30/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

class ParametersTableViewController: UITableViewController {
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var protocoleValue: UILabel!
    @IBOutlet weak var protocoleLabel: UILabel!
    @IBOutlet weak var serverValue: UILabel!
    @IBOutlet weak var apikeyValue: UILabel!
    @IBOutlet weak var usernameValue: UILabel!
    @IBOutlet weak var idClientValue: UILabel!
    @IBAction func reinitAction(_ sender: Any) {
        apikeyValue.text = "Pas de clef d'API"
    }
   
    @IBAction func manuelAction(_ sender: UIButton) {
        showInputDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Paramètres"
        apikeyValue.text = "abdqs324114fdqkb4"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        if let navController = navigationController {
//            System.clearNavigationBar(forBar: navController.navigationBar)
//            navController.view.backgroundColor = .clear
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func addTapped (sender:UIButton) {
        print("add pressed")
    }
//    struct System {
//        static func clearNavigationBar(forBar navBar: UINavigationBar) {
//            navBar.setBackgroundImage(UIImage(), for: .default)
//            navBar.shadowImage = UIImage()
//            navBar.isTranslucent = true
//        }
//    }
    func showInputDialog(){
        let alertController = UIAlertController(title: "Clef d'API", message: "Merci de saisir la Clef d'API", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Entrer", style: .default){(_) in
            let apikey = alertController.textFields?[0].text
            self.apikeyValue.text = apikey
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
        
        print(UIDevice.current.modelName)
        
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
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad6,11", "iPad6,17":                    return "iPad 5" // iPad 2017
        case "iPad7,5", "iPad7,6":                      return "iPad 6" // iPad 2018
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2": return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
