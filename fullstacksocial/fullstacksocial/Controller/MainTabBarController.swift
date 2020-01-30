//
//  MainTabBarController.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/17/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools


class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    var homeController = HomeController()
    var profileController = ProfileController(userId: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .white
        
        let vc = UIViewController()
       
        
        
        viewControllers = [
            createNavController(viewController: homeController, tabBarImage: #imageLiteral(resourceName: "home")),
            createNavController(viewController: vc, tabBarImage: #imageLiteral(resourceName: "plus")),
            createNavController(viewController: profileController, tabBarImage: #imageLiteral(resourceName: "user"))
        ]
        
        tabBar.tintColor = .black
    }
    
    func refreshPosts(){
        homeController.fetchPosts()
        
        profileController.fetchUserProfile()
    }
    
    fileprivate func createNavController(viewController: UIViewController, tabBarImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.image = tabBarImage
        
        return navController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewControllers?.firstIndex(of: viewController) == 1 {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true)
            return false
        }
        
        return true
    }
}

extension MainTabBarController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                let createPostController = CreatePostController(selectedImage: image)
                
                self.present(createPostController, animated: true)
                
                
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
