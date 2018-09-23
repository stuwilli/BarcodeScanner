//
//  ViewController.swift
//  BarcodeScanner
//
//  Created by Stuart Williams on 13/09/2018.
//  Copyright © 2018 Stuart Williams. All rights reserved.
//

import UIKit
import AVFoundation
import BarcodeTypeResolver

class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var input: AVCaptureDeviceInput!
    var metaDataOutput: AVCaptureMetadataOutput!
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access camera")
                return
        }
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        }
        catch let error {
            print("Unabled to initialize back camera", error.localizedDescription)
        }
        
        metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddInput(input) && captureSession.canAddOutput(metaDataOutput){
            captureSession.addInput(input)
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = supportedCodeTypes
            //metaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            setupLivePreview()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                //qrCodeFrameView.layer.backgroundColor = UIColor.black.cgColor
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func setupLivePreview() {
        videoPreviewLayer =  AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer?.frame = self.view.layer.bounds;
                self.view.bringSubview(toFront: self.messageLabel)
            }
        }


    }
    
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print( "No QR code is detected")
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //launchApp(decodedURL: metadataObj.stringValue!)
                print(metadataObj.description) // e.g org.gs1.EAN-13
                print(metadataObj.type.rawValue)
                let r = Resolver()
                let type = r.checkType(type: metadataObj.type.rawValue, val: metadataObj.stringValue ?? "")
                messageLabel.text = type.rawValue + ": " + metadataObj.stringValue!
            }
        }
    }
    
}



