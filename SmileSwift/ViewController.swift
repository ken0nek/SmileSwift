//
//  ViewController.swift
//  SmileSwift
//
//  Created by Ken Tominaga on 11/7/14.
//  Copyright (c) 2014 Ken Tominaga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var sampleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, { () -> Void in
            let image  = CIImage(CGImage: self.sampleImageView.image?.CGImage)
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            let options = [CIDetectorSmile : true, CIDetectorEyeBlink : true]
            let features = detector.featuresInImage(image, options: options)
            
            var resultString: NSMutableString = "DETECTED FACES:\n\n"
            
            for feature in features as [CIFaceFeature] {
//                println(feature.hasSmile, feature.bounds)
                resultString.appendFormat("bounds:%@\n", NSStringFromCGRect(feature.bounds))
                resultString.appendFormat("hasSmile: %@\n\n", feature.hasSmile ? "YES" : "NO")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.outputTextView.text = resultString
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

