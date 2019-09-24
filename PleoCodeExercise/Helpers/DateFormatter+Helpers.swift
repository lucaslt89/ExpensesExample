//
//  DateFormatter+Helpers.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit

extension DateFormatter {
    
    static func displayDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mmm dd, yyyy"
        return dateFormatter.string(from: date)
    }

}
