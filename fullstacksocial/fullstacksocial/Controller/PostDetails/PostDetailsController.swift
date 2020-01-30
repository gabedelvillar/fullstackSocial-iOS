//
//  PostDetailsController.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/21/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class PostDetailsController: LBTAListController<CommentCell, Comment> {
    
    let postId: String
    
    init(postId: String){
        self.postId = postId
        super.init()
    }
    
    lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y:0, width: view.frame.width, height: 80))
        
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return civ
    }() 
    
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        
        collectionView.keyboardDismissMode = .interactive
        
        setupAcitivityIndicatorView()
        fetchPostDetails()
    }
    
    func fetchPostDetails() {
        let url = "\(Service.shared.baseUrl)/post/\(postId)"
        
        Alamofire.request(url).response { (dataResp) in
            self.activityIndicator.stopAnimating()
            
            guard let data = dataResp.data else {return}
            
            do{
                let post = try JSONDecoder().decode(Post.self, from: data)
                self.items = post.comments ?? []
                self.collectionView.reloadData()
            } catch {
                print("Failed to parse post: ", error)
            }
        }
    }
    
    @objc fileprivate func handleSend() {
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = "Submitting..."
        
        hud.show(in: view)
        
        let params = ["text": customInputView.textView.text ?? ""]
        
        let url = "\(Service.shared.baseUrl)/comment/post/\(postId))"
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                hud.dismiss()
                self.customInputView.textView.text = nil
                self.customInputView.placeholderLabel.isHidden = false
                self.fetchPostDetails()
        }
    }
    
    fileprivate func setupAcitivityIndicatorView() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}

extension PostDetailsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
