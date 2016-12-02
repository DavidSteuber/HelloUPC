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

    func configure(_ captureSession: AVCaptureSession) -> Void {
        let previewLayer = AVCaptureVideoPreviewLayer(session:captureSession)

        previewLayer?.frame = self.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer!)
    }
}
