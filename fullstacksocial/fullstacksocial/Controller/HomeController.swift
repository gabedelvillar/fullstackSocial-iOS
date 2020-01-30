//
//  ViewController.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/6/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit
import WebKit
import LBTATools
import Alamofire
import SDWebImage


class HomeController: LBTAListController<UserPostCell, Post>, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchPosts()
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItems = [
            .init(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(handleSearch)),
//            .init(title: "Search", style: .plain, target: self, action: #selector(handleSearch)),
//            .init(title: "Create post", style: .plain, target: self, action: #selector(createPost))
        ]
        
        navigationItem.leftBarButtonItem = .init(title: "Log In", style: .plain, target: self, action: #selector(handleLogin))
        
        let rc = UIRefreshControl()
        
        rc.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        self.collectionView.refreshControl = rc
    }
    
  
    @objc fileprivate func handleSearch() {
        let navController = UINavigationController(rootViewController: UsersSearchController())
        
        present(navController, animated: true)
    }
    
    @objc fileprivate func createPost() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        
        dismiss(animated: true) {
           
            let createPostController = CreatePostController(selectedImage: image)
            createPostController.homeController = self
            
            self.present(createPostController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleLogin(){
        print("Show login and sign up pages")
        
        let navController = UINavigationController(rootViewController: LoginController())
        
        present(navController, animated: true)
    }
    
    @objc func fetchPosts(){
        Service.shared.fetchPosts { (res) in
            self.collectionView.refreshControl?.endRefreshing()
            switch res {
            case .failure(let err):
                print("Failed to fetch posts: ", err)
            case .success(let posts):
                self.items = posts
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
}

extension HomeController: PostDelegate {
    func showLikes(post: Post) {
        let likesController = LikesController(postId: post.id)
        navigationController?.pushViewController(likesController, animated: true)
    }
    
    func showComments(post: Post) {
        let postDetailsController = PostDetailsController(postId: post.id)
        navigationController?.pushViewController(postDetailsController, animated: true)
    }
    
    func showOptions(post: Post) {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(.init(title: "Remove From Feed", style: .destructive, handler: { (_) in
            let url = "\(Service.shared.baseUrl)/feeditem/\(post.id)"
            Alamofire.request(url, method: .delete)
                .validate(statusCode: 200..<300)
                .response { (dataResp) in
                    if let err = dataResp.error{
                        print("Failed to delete: ", err)
                        return
                    }
                    
                    guard let index = self.items.firstIndex(where: {$0.id == post.id}) else {return}
                    
                    self.items.remove(at: index)
                    
                    self.collectionView.deleteItems(at: [[0, index]])
                    
            }
        }))
        
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
    
    func handleLike(post: Post) {
        
        let hasLiked = post.hasLiked == true
        
        let string = hasLiked ? "dislike" : "like"
        
        let url = "\(Service.shared.baseUrl)/\(string)/\(post.id)"
        
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { (dataResp) in
                // completion
                
                guard let indexOfPost = self.items.firstIndex(where: {$0.id == post.id}) else {return}
                
                self.items[indexOfPost].hasLiked?.toggle()
                
                self.items[indexOfPost].numLikes += hasLiked ? -1 : 1
                
                let indexPath = IndexPath(item: indexOfPost, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    
}

