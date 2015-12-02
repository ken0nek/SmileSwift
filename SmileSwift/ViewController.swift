//
//  ViewController.swift
//  SmileSwift
//
//  Created by Ken Tominaga on 11/7/14.
//  Copyright (c) 2014 Ken Tominaga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var outputTextView: UITextView!
    @IBOutlet private weak var sampleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        detectFaces()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func detectFaces() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            
            // create CGImage from image on storyboard.
            guard let image = self.sampleImageView.image, cgImage = image.CGImage else {
                return
            }
            
            let ciImage = CIImage(CGImage: cgImage)
            
            // set CIDetectorTypeFace.
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            // set options
            let options = [CIDetectorSmile : true, CIDetectorEyeBlink : true]
            
            // get features from image
            let features = detector.featuresInImage(ciImage, options: options)
            
            var resultString = "DETECTED FACES:\n\n"
            
            for feature in features as! [CIFaceFeature] {
                resultString.appendContentsOf("bounds: \(NSStringFromCGRect(feature.bounds))\n")
                resultString.appendContentsOf("hasSmile: \(feature.hasSmile ? "YES" : "NO")\n")
                resultString.appendContentsOf("faceAngle: \(feature.hasFaceAngle ? String(feature.faceAngle) : "NONE")\n")
                resultString.appendContentsOf("leftEyeClosed: \(feature.leftEyeClosed ? "YES" : "NO")\n")
                resultString.appendContentsOf("rightEyeClosed: \(feature.rightEyeClosed ? "YES" : "NO")\n")
                
                resultString.appendContentsOf("\n")
            }
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.outputTextView.text = "\(resultString)"
            }
        }
    }
}




