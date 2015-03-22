//
//  ViewController.swift
//  HelloUPC
//
//  Created by David Steuber on 3/22/15.
//  Copyright (c) 2015 David Steuber.
//

import UIKit
import AVFoundation

let sessionQueue: dispatch_queue_t = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL)

func runOnMainThread(process: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), process)
}

func runOnSessionThread(process: dispatch_block_t) {
    dispatch_async(sessionQueue, process)
}

class ViewController: UIViewController {
    @IBOutlet var cameraView: CameraView!
    var captureSession: AVCaptureSession = AVCaptureSession()
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkDeviceAuthorizationStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        runOnSessionThread(){
            self.captureSession.startRunning()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        runOnSessionThread(){
            self.captureSession.stopRunning()
        }

        super.viewDidDisappear(animated)
    }

    func configure() {
        if let cameraDevice: AVCaptureDevice = ViewController.device() {
            let cameraDeviceInput: AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(cameraDevice, error: NSErrorPointer()) as AVCaptureDeviceInput

            if captureSession.canAddInput(cameraDeviceInput) {
                captureSession.addInput(cameraDeviceInput)
            }

            if self.captureSession.canAddOutput(stillImageOutput) {
                //stillImageOutput.setValue(AVVideoCodecJPEG, forKey: AVVideoCodecKey)
                captureSession.addOutput(stillImageOutput)
            }

            captureSession.commitConfiguration()
        }
    }

    class func device() -> AVCaptureDevice? {
        if let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as NSArray! {
            if devices.count > 0 {
                let captureDevice: AVCaptureDevice = devices.firstObject as AVCaptureDevice!

                return captureDevice // Supposed to be AVCaptureDevicePositionBack
            }
        }

        return nil
    }

    func checkDeviceAuthorizationStatus() {
        let mediaType: String! = AVMediaTypeVideo

        AVCaptureDevice.requestAccessForMediaType(mediaType){
            if $0 {
                runOnSessionThread(){
                    self.cameraView.configure(self.captureSession)
                    self.configure()
                }
            } else {
                runOnMainThread(){
                    let alertView: Void = UIAlertView(title: "HelloUPC",
                        message: "HelloUPC doesn't have permission to use the camera",
                        delegate: nil,
                        cancelButtonTitle: "Bummer").show()
                }
            }
        }
    }
}

