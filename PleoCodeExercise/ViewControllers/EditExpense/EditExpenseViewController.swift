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
    
    // MARK: - UIView Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPicture)))
    }
    
    // MARK: - Button Actions -
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let comment = textField.text, !comment.isEmpty {
            APIManager.updateExpense(id: expenseId, comment: comment) { (response) in
                self.uploadPictureIfNeeded()
            }
        } else {
            uploadPictureIfNeeded()
        }
    }
    
    // MARK: - Helpers -
    
    private func uploadPictureIfNeeded() {
        if let imagePath = imagePath {
            APIManager.uploadImageToExpense(id: expenseId, imageFilePath: imagePath) { (response) in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectPicture() {
        let alertView = UIAlertController(title: NSLocalizedString("edit_expense", comment: ""), message: nil, preferredStyle: .actionSheet)
        let addPhotoFromCameraAction = UIAlertAction(title: NSLocalizedString("add_receipt_camera", comment: ""), style: .default) { (action) in
            let imagePickerView = UIImagePickerController()
            imagePickerView.delegate = self
            imagePickerView.sourceType = .camera
            self.present(imagePickerView, animated: true, completion: nil)
        }
        let addPhotoFromLibraryAction = UIAlertAction(title: NSLocalizedString("add_receipt_library", comment: ""), style: .default) { (action) in
            let imagePickerView = UIImagePickerController()
            imagePickerView.delegate = self
            imagePickerView.sourceType = .photoLibrary
            self.present(imagePickerView, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive, handler: nil)
        
        alertView.addAction(addPhotoFromCameraAction)
        alertView.addAction(addPhotoFromLibraryAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
    
}

extension EditExpenseViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension EditExpenseViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        
        if let imagePath = info[.imageURL] as? URL {
            self.imagePath = imagePath
        } else {
            let path = URL(fileURLWithPath: NSTemporaryDirectory() + "image.jpeg")
            let imageToSave = image.jpegData(compressionQuality: 0.8)
            try! imageToSave?.write(to: path, options: .atomic)
            self.imagePath = path
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
