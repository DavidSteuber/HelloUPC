//
//  ViewController.swift
//  HelloUPC
//
//  Created by David Steuber on 3/22/15.
//  Copyright (c) 2015 David Steuber.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet var cameraView: CameraView!
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let metaDataOutput = AVCaptureMetadataOutput()

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

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!,fromConnection connection: AVCaptureConnection!) {
        runOnSessionThread(){
            self.captureSession.stopRunning()
        }
        if metadataObjects.count > 0 {
            let object: AVMetadataMachineReadableCodeObject = metadataObjects.first as AVMetadataMachineReadableCodeObject
            let codeRecognizer = CodeRecognizer(type: object.type, data: object.stringValue)
            runOnMainThread() {
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.codeRecognizer = codeRecognizer
                println("Barcode Type: \(codeRecognizer.type)")
                println("Barcode Data: \(codeRecognizer.data)")
                self.performSegueWithIdentifier("CoreDataViewController", sender: self)
            }
        } else {
            runOnSessionThread(){
                self.captureSession.startRunning()
            }
        }
    }

    func configure() {
        if let cameraDevice = ViewController.device() {
            let cameraDeviceInput: AVCaptureInput = AVCaptureDeviceInput.deviceInputWithDevice(cameraDevice, error: NSErrorPointer()) as AVCaptureInput

            if captureSession.canAddInput(cameraDeviceInput) {
                captureSession.addInput(cameraDeviceInput)
            }

            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }


            if captureSession.canAddOutput(metaDataOutput) {
                captureSession.addOutput(metaDataOutput)
                /*
                runOnMainThread() {
                    for mot in self.metaDataOutput.availableMetadataObjectTypes {
                        println("mot: \(mot)")
                    }
                }
                */
                metaDataOutput.metadataObjectTypes =
                    metaDataOutput.availableMetadataObjectTypes.filter() {
                        $0 as NSString != "face"
                }
                metaDataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
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
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo){
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

