//
//  ViewController.swift
//  LoAsset
//
//  Created by Moustapha Kebe on 24/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit
import AVFoundation
//import Toast_Swift

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    

    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()         //Creating session
    var g_var: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Define capture devcie
        var deviceDiscoverySession: AVCaptureDevice.DiscoverySession

        if AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) != nil {

            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        } else {

            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        }
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
//            self.view.makeToast("Failed to get the camera device", duration: 3.0, position: .top)
            return
        }
        
//        replace this commented code per all above if the camera doesn't work
        
//        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
//        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
    }
    

func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)    {

        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    guard let g_text = object.stringValue
                        else { print("No Api Key found")
                                    return
                            }
                    print(g_text)
                    self.g_var = g_text
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(g_text, forKey: "apikeyValue")
                    userDefaults.synchronize()
                     self.view.makeToast("API Key scanné avec succès:", duration: 3.0, position: .top)
                    self.session.stopRunning()
                    self.performQR()
//                    break
                }
            }
        }
    }
    
    func performQR(){
        performSegue(withIdentifier: "toQR", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toQR"){
            let QRVC = segue.destination as? ParametersTableViewController
            QRVC?.TheApiKeyFromScan = g_var
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

