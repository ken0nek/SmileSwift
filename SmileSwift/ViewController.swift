//
//  ViewController.swift
//  SmileSwift
//
//  Created by Ken Tominaga on 11/7/14.
//  Copyright (c) 2014 Ken Tominaga. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    @IBAction func selectPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sampleImageView.image = image
            detectFaces()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: -
    private func detectFaces() {
        DispatchQueue.global(qos: .background).async {
            
            // create CGImage from image on storyboard.
            guard let image = self.sampleImageView.image, let cgImage = image.cgImage else {
                return
            }
            
            let ciImage = CIImage(cgImage: cgImage)
            
            // set CIDetectorTypeFace.
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            // set options
            let options = [CIDetectorSmile : true, CIDetectorEyeBlink : true]
            
            // get features from image
            let features = detector?.features(in: ciImage, options: options)
            
            var resultString = "DETECTED FACES:\n\n"

            for feature in features as! [CIFaceFeature] {
                resultString.append("bounds: \(NSStringFromCGRect(feature.bounds))\n")
                resultString.append("hasSmile: \(feature.hasSmile ? "YES" : "NO")\n")
                resultString.append("faceAngle: \(feature.hasFaceAngle ? String(feature.faceAngle) : "NONE")\n")
                resultString.append("leftEyeClosed: \(feature.leftEyeClosed ? "YES" : "NO")\n")
                resultString.append("rightEyeClosed: \(feature.rightEyeClosed ? "YES" : "NO")\n")
                
                resultString.append("\n")
            }
            
            DispatchQueue.main.async { () -> Void in
                self.outputTextView.text = "\(resultString)"
            }
        }
    }
}
