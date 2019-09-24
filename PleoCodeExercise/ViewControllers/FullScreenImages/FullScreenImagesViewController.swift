//
//  FullScreenImagesViewController.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import ImageSlideshow

class FullScreenImagesViewController: UIViewController {

    var images : [InputSource] = []
    @IBOutlet weak var imageSlideshow: ImageSlideshow!

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageSlideshow.setImageInputs(images)
    }
    
}
