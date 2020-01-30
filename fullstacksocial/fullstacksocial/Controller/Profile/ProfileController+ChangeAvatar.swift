//
//  ProfileController+ChangeAvatar.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/17/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

extension ProfileController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func chageProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.uploadUserProfileImage(image: selectedImage)
            }
        } else {
            dismiss(animated: true)
        }
        
        dismiss(animated: true)
    }
    
    
    fileprivate func uploadUserProfileImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = "Updating profile"
        
        hud.show(in: view)
        
        let url = "\(Service.shared.baseUrl)/profile"
                       
               Alamofire.upload(multipartFormData: { (formData) in
                   
                   guard let user = self.user else { return }
                   
                   formData.append(Data(user.fullName.utf8), withName: "fullName")
                   let bioData = Data((user.bio ?? "").utf8)
                   formData.append(bioData, withName: "bio")
                   
                   guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                   formData.append(imageData, withName: "imagefile", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
                   
               }, to: url) { (res) in
                   switch res {
                   case .failure(let err):
                       print("Failed to update profile:", err)
                   case .success(let req, _, _):
                       req.responseData { (dataResp) in
                           hud.dismiss()
                           
                           if let err = dataResp.error {
                               print("Failed to hit server:", err)
                               return
                           }
                           
                           if let code = dataResp.response?.statusCode, code >= 300 {
                               print("Failed upload with status: ", code)
                               return
                           }
                           
                           print("Successfully updated user profile")
                           
                           self.fetchUserProfile()
                       }
                   }
               }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
}
