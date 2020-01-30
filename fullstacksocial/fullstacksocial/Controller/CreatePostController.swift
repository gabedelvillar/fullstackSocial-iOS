//
//  CreatePostController.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/10/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class CreatePostController: UIViewController, UITextViewDelegate {
    
    let selectedImage: UIImage
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    lazy var postButton = UIButton(title: "Post", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0.1127949134, green: 0.5649430156, blue: 0.9994879365, alpha: 1), target: self, action: #selector(handlePost))
       
    let placeholderLabel = UILabel(text: "Enter your post body text...", font: .systemFont(ofSize: 14), textColor: .lightGray)
       
    let postBodyTextView = UITextView(text: nil, font: .systemFont(ofSize: 14))
    
    weak var homeController: HomeController?
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
        
        imageView.image = selectedImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // here is the layout of the UI
        
        postButton.layer.cornerRadius = 5
               
               view.stack(imageView.withHeight(300),
                          view.stack(postButton.withHeight(40),
                                     placeholderLabel,
                                     spacing: 16).padLeft(16).padRight(16),
                          UIView(),
                          spacing: 16)
               
               // setup UITextView on top of placeholder label, UITextView does not have a placeholder property
               view.addSubview(postBodyTextView)
               postBodyTextView.backgroundColor = .clear
               postBodyTextView.delegate = self
               postBodyTextView.anchor(top: placeholderLabel.bottomAnchor, leading: placeholderLabel.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -25, left: -6, bottom: 0, right: 16))
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.alpha = !textView.text.isEmpty ? 0 : 1
    }
    
    @objc fileprivate func handlePost(){
        let url = "http://localhost:1337/post"
              
              let hud = JGProgressHUD(style: .dark)
              hud.indicatorView = JGProgressHUDRingIndicatorView()
              hud.textLabel.text = "Uploading"
              hud.show(in: view)
              
              guard let text = postBodyTextView.text else { return }
              
              Alamofire.upload(multipartFormData: { (formData) in
                  
                  // post text
                  formData.append(Data(text.utf8), withName: "postBody")
                  
                  // post image
                  guard let imageData = self.selectedImage.jpegData(compressionQuality: 0.5) else { return }
                  formData.append(imageData, withName: "imagefile", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
                  
              }, to: url) { (res) in
                  
                  switch res {
                  case .failure(let err):
                      print("Failed to hit server:", err)
                  case .success(let uploadRequest, _, _):
                      
                      uploadRequest.uploadProgress { (progress) in
                          print("Upload progress: \(progress.fractionCompleted)")
                          hud.progress = Float(progress.fractionCompleted)
                          hud.textLabel.text = "Uploading\n\(Int(progress.fractionCompleted * 100))% Complete"
                      }
                      
                      uploadRequest.responseData { (dataResp) in
                          hud.dismiss()
                          
                          if let err = dataResp.error {
                              print("Failed to hit server:", err)
                              return
                          }
                          
                          if let code = dataResp.response?.statusCode, code >= 300 {
                              print("Failed upload with status: ", code)
                              return
                          }
                          
                          print("Successfully created post, here is the response:")
                          
                          self.dismiss(animated: true) {
                            self.refreshApplicationWithPosts()
                          }
                      }
                  }
              }
    }
    
    fileprivate func refreshApplicationWithPosts(){
        guard let mainTabBarController = (UIApplication.shared.keyWindow?.rootViewController) as? MainTabBarController else {return}
        
        mainTabBarController.refreshPosts()
    }
}
