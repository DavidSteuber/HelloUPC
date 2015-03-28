//
//  CodeDataViewController.swift
//  HelloUPC
//
//  Created by David Steuber on 3/24/15.
//  Copyright (c) 2015 David Steuber.
//

import UIKit

class CodeDataViewController: UIViewController {
    @IBOutlet var codeDataView: CodeDataView!
    @IBOutlet var barcodeTypeLabel: UILabel!
    @IBOutlet var barcodeDataLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        barcodeTypeLabel.text = appDelegate.codeRecognizer.type
        barcodeDataLabel.text = appDelegate.codeRecognizer.data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidDisappear(animated: Bool) {

        super.viewDidDisappear(animated)
    }

    @IBAction func scanAgain() {
        // println("scanAgain button pressed")
        performSegueWithIdentifier("ViewController", sender: self)
    }

}
