//
//  ViewController.swift
//  FirebaseML
//
//  Created by Mohammad Azam on 5/8/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit
import Firebase

class CloudBasedViewController: UIViewController {
    
    @IBOutlet weak var classificationLabel :UILabel!
    @IBOutlet weak var imageView :UIImageView!
    
    private var index = 0
    
    let images = ["tulip","dog","cat","fish","bat"]
    
    lazy var vision = Vision.vision()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func detect() {
        
        let imageName = images[index]
        index += 1
        
        let img = UIImage(named: imageName)!
        self.imageView.image = img
        
        let labelDetector = vision.cloudLabelDetector()
        
        let metadata = VisionImageMetadata()
        metadata.orientation = .rightTop
        
        let visionImage = VisionImage(image: img)
        
        labelDetector.detect(in: visionImage) { (labels, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            
            let predictionLabel = labels?.max(by: { (lhs, rhs) -> Bool in
                
                let l :Double = (lhs.confidence?.doubleValue)!
                let r :Double = (rhs.confidence?.doubleValue)!
                
                return r < l
            
            })
            
            for label in labels! {
                print("\(label.label) has \(label.confidence)")
                self.classificationLabel.text = predictionLabel?.label!
            }
        }
        
    }
}



