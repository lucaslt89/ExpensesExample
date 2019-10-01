//
//  APIManager.swift
//  
//
//  Created by Lucas on 24/09/2019.
//

import Foundation
import Alamofire

// TODO: In case the API gets more complex, this class can be split in multiple parts. Some examples:
// • We could use extensions to group API calls (Expenses, Users, Stores, etc, depending on the API modules available).
// • A proper error handling should be implemented in another class -> Need details on how errors are handled on the API side.
// • If we need to implement authentication, or make complex requests, I usually create an "Endpoint" struc with all the request details. Then the APIManager shoudl receive just an Endpoint object and do the API call taking the parameters from there. I can show some examples of this complex implementation, but for now I wanted to go simple.

public struct APIManager {
    
    static let session = Alamofire.Session()
    static let baseURL = "http://localhost:3000"
    static var decoder : JSONDecoder {
        let customDecoder = JSONDecoder()
        customDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let formatter = DateFormatter()
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let date = formatter.date(from: dateString) {
                return date
            }
            return Date.distantPast
        })
        return customDecoder
    }
    
    /**
     * Returns the expenses from the API
     * - parameter limit: The amount of expenses in the requested page
     * - parameter offset: The amount of expenses already loaded. This is used to indicate the page to be loaded.
     * - parameter completion: A completion block that receives a DataResponse<ExpensesReport, AFError> object.
     */
    @discardableResult
    public static func getExpenses(limit: Int, offset: Int, completion: @escaping (DataResponse<ExpensesReport, AFError>) -> Void) -> Request {
        let url = baseURL + "/expenses?limit=\(limit)&offset=\(offset)"
        let request = session.request(url).responseDecodable(decoder: decoder) { (response) in
            completion(response)
        }
        return request
    }
    
    /**
    * Updates the comment of an expense
    * - parameter id: The ID of the expense to be updated
    * - parameter comment: The comment to include in the expense
    * - parameter completion: A completion block to allow error handling if the request fails
    */
    @discardableResult
    public static func updateExpense(id: String, comment: String, completion: @escaping (AFDataResponse<Data?>) -> Void) -> Request {
        let url = baseURL + "/expenses/\(id)"
        let params = ["comment": comment]
        let request = session.request(url, method: .post, parameters: params).response { (response) in
            completion(response)
        }
        return request
    }
    
    @discardableResult
    public static func uploadImageToExpense(id: String, imageFilePath: URL, completion: @escaping (AFDataResponse<Data?>) -> Void) -> Request {
        let url = baseURL + "/expenses/\(id)/receipts"
        let request = session.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageFilePath, withName: "receipt")
        }, to: url)
            .response { (response) in
            completion(response)
        }
        return request
    }
    
}

