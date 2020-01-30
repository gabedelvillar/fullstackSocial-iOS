//
//  PostCell.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/10/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Alamofire

protocol PostCellOptionsDelegate: class {
    func handleOptions(cell: PostCell)
}

extension HomeController: PostCellOptionsDelegate {
    func handleOptions(cell: PostCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else {return}
//
//        let post = self.posts[indexPath.row]
//
//        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
//
//        alertController.addAction(.init(title: "Delete post", style: .destructive, handler: { (_) in
//             let url = "\(Service.shared.baseUrl)/post/\(post.id)"
//              Alamofire.request(url, method: .delete)
//                      .validate(statusCode: 200..<300)
//                      .responseData { (dataResponse) in
//                          if let err = dataResponse.error {
//                              print("Failed to delte: ", err)
//                              return
//                          }
//
//                          self.posts.remove(at: indexPath.row)
//                          self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                  }
//        }))
//        
//        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
//
//        present(alertController, animated: true)
    }
}

class PostCell: UITableViewCell {
//    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15))
//    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
//    let postTextLabel = UILabel(text: "Post text spanning multiple lines", font: .systemFont(ofSize: 15), numberOfLines: 0)
//    
//    weak var delegate: PostCellOptionsDelegate?
//    
//    lazy var optionsButton = UIButton(image: #imageLiteral(resourceName: "post_options"), tintColor: .black, target: self, action: #selector(handleOptions))
//    
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        // make image square
//        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
//        
//        stack(hstack(usernameLabel, UIView(), optionsButton.withWidth(34)).padLeft(16).padRight(16),
//              postImageView,
//              stack(postTextLabel).padLeft(16).padRight(16),
//              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
//              
//        
//    }
//    
//    @objc fileprivate func handleOptions(){
//        print("Handle delete options on post cell")
//        delegate?.handleOptions(cell: self)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
