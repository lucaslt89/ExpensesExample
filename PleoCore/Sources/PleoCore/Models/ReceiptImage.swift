//
//  ReceiptImage.swift
//  
//
//  Created by Lucas on 24/09/2019.
//

import Foundation

public class ReceiptImage: Codable {
    
    let url: String!
    
    public var absoluteURL: URL {
        let absoluteURLString = APIManager.baseURL + url
        return URL(string: absoluteURLString)!
    }
    
}
