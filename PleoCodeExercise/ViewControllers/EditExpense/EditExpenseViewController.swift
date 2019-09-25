//
//  EditExpenseViewController.swift
//  PleoCodeExercise
//
//  Created by Lucas on 24/09/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import PleoCore

class EditExpenseViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var expenseId : String!
    var imagePath : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPicture)))
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let comment = textField.text {
            APIManager.updateExpense(id: expenseId, comment: comment) { (response) in
                self.uploadPictureIfNeeded()
            }
        } else {
            uploadPictureIfNeeded()
        }
    }
    
    @objc func selectPicture() {
        let alertView = UIAlertController(title: NSLocalizedString("edit_expense", comment: ""), message: nil, preferredStyle: .actionSheet)
        let addPhotoFromCameraAction = UIAlertAction(title: NSLocalizedString("add_receipt_camera", comment: ""), style: .default) { (action) in
            print("Add Photo from Camera")
        }
        let addPhotoFromLibraryAction = UIAlertAction(title: NSLocalizedString("add_receipt_library", comment: ""), style: .default) { (action) in
            print("Add Photo from Library")
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive) { (action) in
            print("cancel")
        }
        alertView.addAction(addPhotoFromCameraAction)
        alertView.addAction(addPhotoFromLibraryAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
    
    private func uploadPictureIfNeeded() {
        if let imagePath = imagePath {
            APIManager.uploadImageToExpense(id: expenseId, imageFilePath: imagePath) { (response) in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension EditExpenseViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
