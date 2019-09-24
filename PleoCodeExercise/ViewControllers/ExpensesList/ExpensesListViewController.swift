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

class ExpensesListViewController: UIViewController {
    
    var expenses : [ExpenseViewModel] = []
    let pageSize : Int = 10
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: UIViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExpenses()
    }
    
    // MARK: Private Helpers
    
    private func loadExpenses() {
        APIManager.getExpenses(limit: pageSize, offset: expenses.count) { (response) in
            switch response.result {
            case let .success(expenseReport):
                let expensesViewModels = expenseReport.expenses!.map{ExpenseViewModel(expense: $0)}
                self.expenses += expensesViewModels
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
    
}

extension ExpensesListViewController : ExpenseTableViewCellDelegate {
    func didTapExpenseSlideshow(imageSlideshow: ImageSlideshow) {
        guard let fullScreenVC = storyboard?.instantiateViewController(identifier: "FullScreenImagesViewController") as? FullScreenImagesViewController else { return }
        fullScreenVC.images = imageSlideshow.images
        present(fullScreenVC, animated: true, completion: nil)
    }
    
    func didTapExpenseEdit(expenseID: String) {
        print("Edit Expense: \(expenseID)")
    }
    
}
