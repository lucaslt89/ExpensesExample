//
//  ExpensesReport.swift
//  
//
//  Created by Lucas on 24/09/2019.
//

import Foundation

public class ExpensesReport: Codable {
    
    public let expenses: [Expense]?
    public let total: Int!
    
}
