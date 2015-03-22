//
//  CameraView.swift
//  HelloUPC
//
//  Created by David Steuber on 3/22/15.
//  Copyright (c) 2015 David Steuber.
//

import UIKit
import Foundation
import AVFoundation

@IBDesignable
class CameraView: UIView {

    var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()

    func configure(captureSession: AVCaptureSession) -> Void {
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(captureSession) as AVCaptureVideoPreviewLayer
        previewLayer.frame = self.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer)
    }
}
