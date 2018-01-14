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

        // create CGImage from image on storyboard.
        guard let image = sampleImageView.image,
            let cgImage = image.cgImage else {
            return
        }

        DispatchQueue.global(qos: .background).async {
            
            let ciImage = CIImage(cgImage: cgImage)

            // set CIDetectorTypeFace.
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            // set detector options
            let options = [
                CIDetectorSmile: true,
                CIDetectorEyeBlink: true
            ]

            // get face features from image
            let features = detector?.features(in: ciImage, options: options) as! [CIFaceFeature]

            let featuresDescription = features
                .map { f in
                    // you can configure CIFaceFeature descriptions here. There are many other properties you can get.
                    return """
                    **********
                    bounds: \(f.bounds)
                    hasSmile: \(f.hasSmile)
                    hasfaceAngle: \(f.hasFaceAngle) -> \(f.faceAngle)
                    leftEyeClosed: \(f.leftEyeClosed)
                    rightEyeClosed: \(f.rightEyeClosed)
                    **********
                    """
                }
                .joined(separator: "\n")

            let outputText = "DETECTED FACES (\(features.count)):\n\n" + featuresDescription

            DispatchQueue.main.async { () -> Void in
                self.outputTextView.text = "\(outputText)"
            }
        }
    }
}
