//
//  BarCodeDetectorViewController.swift
//  FirebaseML
//
//  Created by Mohammad Azam on 5/10/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase

class BarCodeDetectorViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView :UIImageView!
    @IBOutlet weak var barCodeRawValueLabel :UILabel! 
    
    let session = AVCaptureSession()
    lazy var vision = Vision.vision()
    var barcodeDetector :VisionBarcodeDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLiveVideo()
        self.barcodeDetector = vision.barcodeDetector()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let barcodeDetector = self.barcodeDetector {
            
            let visionImage = VisionImage(buffer: sampleBuffer)
            
            barcodeDetector.detect(in: visionImage) { (barcodes, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                for barcode in barcodes! {
                    print(barcode.rawValue!)
                     self.barCodeRawValueLabel.text = barcode.rawValue!
                }
            }
        }
    }
    
    private func startLiveVideo() {
        
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)

        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.size.width + 100, height: self.imageView.frame.size.height)
        imageLayer.videoGravity = .resizeAspectFill
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
}
