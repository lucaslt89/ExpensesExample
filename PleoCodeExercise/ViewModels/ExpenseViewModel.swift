//
//  ExpenseViewModel.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import PleoCore

class ExpenseViewModel {
    
    let expense : Expense
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var merchantName : String {
        return expense.merchant
    }
    
    var amountString : String {
        return "\(expense.amount.value ?? "") \(expense.amount.currency ?? "")"
    }
    
    var dateString : String {
        return "\(DateFormatter.displayDateString(date: expense.date))"
    }
    
    var userDetails : String {
        return "\(expense.user.first ?? "") \(expense.user.last ?? "") - \(expense.user.email ?? "")"
    }
    
    var comment : String {
        return expense.comment ?? ""
    }
    
    var receiptsURLs : [URL] {
        return expense.receipts?.map{$0.absoluteURL} ?? []
    }

}
