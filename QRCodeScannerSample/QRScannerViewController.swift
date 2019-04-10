//
//  QRScannerViewController.swift
//  QRCodeScannerSample
//
//  Created by Chethan on 08/04/19.
//  Copyright © 2019 Chethan. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
              self.captureSession.addOutput(captureMetadataOutput)
            
            
            // User granted
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
          
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            self.captureSession.startRunning()

                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession )
                self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
                let frame = self.view.layer.bounds
                let viewHeight = frame.width / 1.77
                containerHeightConstraint.constant = viewHeight
            self.videoPreviewLayer?.frame = CGRect.init(x: 0, y: 0, width:frame.width , height: viewHeight)
                self.containerView.layer.addSublayer(self.videoPreviewLayer!)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.

                
                    
                    self.qrCodeFrameView = UIView()
                    
                    if let qrCodeFrameView = self.qrCodeFrameView {
                        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                        qrCodeFrameView.layer.borderWidth = 2
                        self.containerView.addSubview(qrCodeFrameView)
                        self.view.bringSubviewToFront(qrCodeFrameView)
                    }


        
        // Set delegate and use the default dispatch queue to execute the call back
 
    }
    

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
          //  messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        print(metadataObjects)
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                print( metadataObj.stringValue)
              //  messageLabel.text = metadataObj.stringValue
            }
        }
    }


}
