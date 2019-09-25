//
//  ExpensesListViewController.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import PleoCore
import ImageSlideshow
import Alamofire

class ExpensesListViewController: UIViewController {
    
    var expenses : [ExpenseViewModel] = []
    var limitReached = false
    let pageSize : Int = 10
    var ongoingRequest : Request?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: UIViewLifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExpenses(offset: 0)
    }
    
    // MARK: Private Helpers
    
    private func loadExpenses(offset: Int) {
        if offset == 0 {
            expenses = []
            limitReached = false
        }
        ongoingRequest = APIManager.getExpenses(limit: pageSize, offset: offset) { (response) in
            self.ongoingRequest = nil
            switch response.result {
            case let .success(expenseReport):
                let expensesViewModels = expenseReport.expenses!.map{ExpenseViewModel(expense: $0)}
                self.expenses += expensesViewModels
                self.limitReached = self.expenses.count == expenseReport.total
                self.tableView.reloadData()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

}

extension ExpensesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier) as? ExpenseTableViewCell else { return UITableViewCell() }
        cell.setupWithExpense(expenses[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    /**
     * This is a very simple solution to implement infinite scrolling since the API response is quite fast. A better solution would be to add a mock cell at the end with an activity indicator, and when that cell appears we load the next page. We could also use tableView:willDisplay:forRowAt: method.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeightTrigger = scrollView.contentSize.height - 100 - tableView.bounds.height
        if actualPosition >= contentHeightTrigger && ongoingRequest == nil && !limitReached {
            loadExpenses(offset: expenses.count)
        }
    }
    
}

extension ExpensesListViewController : ExpenseTableViewCellDelegate {
    func didTapExpenseSlideshow(imageSlideshow: ImageSlideshow) {
        guard let fullScreenVC = storyboard?.instantiateViewController(identifier: "FullScreenImagesViewController") as? FullScreenImagesViewController else { return }
        fullScreenVC.images = imageSlideshow.images
        present(fullScreenVC, animated: true, completion: nil)
    }
    
    func didTapExpenseEdit(expenseID: String) {
        guard let editExpenseVC = storyboard?.instantiateViewController(identifier: "EditExpenseViewController") as? EditExpenseViewController else { return }
        editExpenseVC.expenseId = expenseID
        editExpenseVC.modalPresentationStyle = .fullScreen
        present(editExpenseVC, animated: true, completion: nil)
    }
    
}
