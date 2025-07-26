//
//  ImageViewController.swift
//  SnapNote
//
//  Created by chaitanya on 25/05/25.
//

import Foundation
import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
       let saveButton =  UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveImage)
            )
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @IBAction func takePhotoTapped(_ sender: UIButton) {
        openCamera()
    }

    @IBAction func chooseFromGalleryTapped(_ sender: UIButton) {
        openGallery()
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage // or image display view

            // Enable the Save button
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func saveImage() {
        guard let imageToSave = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
   @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Save error: \(error.localizedDescription)")
        } else {
            print("Image successfully saved!")
        }
    }
}
