import XCTest
@testable import PleoCore

final class PleoCoreTests: XCTestCase {
    
    func testGetExpenses() {
        let expectation = XCTestExpectation(description: "Get expenses")
        APIManager.getExpenses(limit: 10, offset: 0) { (response) in
            XCTAssert(response.value?.expenses?.count == 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testUpdateExpense() {
        let expectation = XCTestExpectation(description: "UpdateExpense")
        APIManager.updateExpense(id: "5b996064dfd5b783915112f5", comment: "Test comment", completion: { (response) in
            XCTAssert(response.error == nil)
            APIManager.getExpenses(limit: 10, offset: 0) { (response) in
                XCTAssert(response.value?.expenses?.first?.comment == "Test comment")
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 10)
    }

}
