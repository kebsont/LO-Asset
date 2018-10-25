//
//  QRScannerController.swift
//  LoAsset
//
//  Created by Moustapha Kebe on 24/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//
import AVFoundation
import Foundation
import UIKit

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?

    
}

