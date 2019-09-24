//
//  Expense.swift
//  
//
//  Created by Lucas on 24/09/2019.
//

import Foundation

public class Expense : NSObject, Codable {
    
    public let id: String!
    public let amount: Amount!
    public let date: Date!
    public let merchant: String!
    public let receipts: [ReceiptImage]?
    public let comment: String?
    public let category: String?
    public let user: User!
    public let index: Int!
    
}
