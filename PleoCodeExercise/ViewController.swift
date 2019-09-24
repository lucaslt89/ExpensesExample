//
//  ViewController.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import PleoCore

class ViewController: UIViewController {
    
    var expenses : [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.getExpenses(limit: 10, offset: 0) { (response) in
            print(response.value?.expenses ?? "")
        }
    }


}

