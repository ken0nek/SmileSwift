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
        
        detectFaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func detectFaces() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, { () -> Void in
            
            // storyboardに置いたimageViewからCIImageを生成する
            let image  = CIImage(CGImage: self.sampleImageView.image?.CGImage)
            
            // 顔認識なのでTypeをCIDetectorTypeFaceに指定する
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            // 取得するパラメーターを指定する
            let options = [CIDetectorSmile : true, CIDetectorEyeBlink : true]
            
            // 画像から特徴を抽出する
            let features = detector.featuresInImage(image, options: options)
            
            var resultString: NSMutableString = "DETECTED FACES:\n\n"
            
            for feature in features as [CIFaceFeature] {
                resultString.appendFormat("bounds:%@\n", NSStringFromCGRect(feature.bounds))
                resultString.appendFormat("hasSmile: %@\n\n", feature.hasSmile ? "YES" : "NO")
                //                resultString.appendFormat("faceAngle: %@", feature.hasFaceAngle ? feature.faceAngle : "NONE");
                //                resultString.appendFormat("leftEyeClosed: %@", feature.leftEyeClosed ? "YES" : "NO");
                //                resultString.appendFormat("rightEyeClosed: %@", feature.rightEyeClosed ? "YES" : "NO");
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.outputTextView.text = resultString
            })
        })
    }
}

