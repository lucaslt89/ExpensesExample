//
//  ExpenseTableViewCell.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol ExpenseTableViewCellDelegate: class {
    func didTapExpenseSlideshow(imageSlideshow: ImageSlideshow)
    func didTapExpenseEdit(expenseID: String)
}

class ExpenseTableViewCell: UITableViewCell {
    
    static let identifier = "ExpenseTableViewCellIdentifier"
    
    private var expenseViewModel : ExpenseViewModel!
    
    weak var delegate : ExpenseTableViewCellDelegate?
    
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func setupWithExpense(_ expense: ExpenseViewModel) {
        expenseViewModel = expense
        titleLabel.text = expense.merchantName
        amountLabel.text = "\(expense.amountString) - \(expense.dateString)"
        userLabel.text = expense.userDetails
        commentLabel.text = expense.comment
        imageSlideshow.setImageInputs(expense.receiptsURLs.map{SDWebImageSource(url: $0)})
        imageSlideshow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullScreenSlideshow)))
    }
    
    @objc func showFullScreenSlideshow() {
        delegate?.didTapExpenseSlideshow(imageSlideshow: imageSlideshow)
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        delegate?.didTapExpenseEdit(expenseID: expenseViewModel.expense.id)
    }
    
}
