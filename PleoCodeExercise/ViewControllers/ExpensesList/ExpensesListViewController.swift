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
    var filteredExpenses : [ExpenseViewModel] = []
    var filterApplied = false
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
                self.showAllExpenses()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Button Actions
    
    @IBAction func filtersButtonPressed(_ sender: Any) {
        let alertView = UIAlertController(title: NSLocalizedString("filters", comment: ""), message: nil, preferredStyle: .actionSheet)
        let receiptsWithImageAction = UIAlertAction(title: NSLocalizedString("show_expenses_with_image", comment: ""), style: .default) { (action) in
            self.showExpensesWithImages()
        }
        let receiptsWithCommentAction = UIAlertAction(title: NSLocalizedString("show_expenses_with_comments", comment: ""), style: .default) { (action) in
            self.showExpensesWithComments()
        }
        let allReceiptsAction = UIAlertAction(title: NSLocalizedString("show_all_expenses", comment: ""), style: .default) { (action) in
            self.showAllExpenses()
        }
        
        alertView.addAction(receiptsWithImageAction)
        alertView.addAction(receiptsWithCommentAction)
        alertView.addAction(allReceiptsAction)
        present(alertView, animated: true, completion: nil)
    }
    
    // MARK: - Filters methods -
    
    private func showExpensesWithImages() {
        filteredExpenses = expenses.filter { $0.hasReceipts }
        filterApplied = true
        tableView.reloadData()
    }
    
    private func showExpensesWithComments() {
        filteredExpenses = expenses.filter { !$0.comment.isEmpty }
        filterApplied = true
        tableView.reloadData()
    }
    
    private func showAllExpenses() {
        filteredExpenses = expenses
        filterApplied = false
        tableView.reloadData()
    }
}

extension ExpensesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier) as? ExpenseTableViewCell else { return UITableViewCell() }
        cell.setupWithExpense(filteredExpenses[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    /**
     * This is a very simple solution to implement infinite scrolling since the API response is quite fast. A better solution would be to add a mock cell at the end with an activity indicator, and when that cell appears we load the next page. We could also use tableView:willDisplay:forRowAt: method.
     *
     * Note: Since the filters are applied locally, we only request more pages if we're showing all the expenses, otherwise we might have unexpected results like getting expenses from the API and not displaying anything because they're filtered.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !filterApplied {
            let actualPosition = scrollView.contentOffset.y
            let contentHeightTrigger = scrollView.contentSize.height - 100 - tableView.bounds.height
            if actualPosition >= contentHeightTrigger && ongoingRequest == nil && !limitReached {
                loadExpenses(offset: expenses.count)
            }
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
