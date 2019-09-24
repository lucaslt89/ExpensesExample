//
//  Expense.swift
//  
//
//  Created by Lucas on 24/09/2019.
//

import Foundation

public class Expense : NSObject, Codable {
    
    public let id: String!
    public let amount: Amount?
    public let date: Date?
    public let merchant: String?
    public let receipts: [ReceiptImage]?
    public let comment: String?
    public let category: String?
    public let user: User?
    public let index: Int!
    
    override public var description : String {
        return """
        ***
        id: \(id ?? "")
        amount: \(amount?.value ?? "") - \(amount?.currency ?? "")
        date: \(date ?? Date.distantPast)
        merchant: \(merchant ?? "")
        receipts: \(receipts?.map{$0.absoluteURL} ?? [])
        comment: \(comment ?? "")
        category: \(category ?? "")
        user: \(user?.first ?? "") \(user?.last ?? "") - \(user?.email ?? "")
        index: \(index ?? 0)
        ***
        
        
        """
    }
    
}
