//
//  ViewController.swift
//  MyJournal
//
//  Created by Gabriel Del VIllar De Santiago on 1/3/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit

struct Post: Decodable {
    let id: Int
    let title, body: String
}

class Service: NSObject {
    static let shared = Service()
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:1337/posts") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            DispatchQueue.main.async {
                if let err = err {
                        print("Failed to fetch posts: ", err)
                        return
                    }
                    
                    guard let data = data else {return}
                    
                    do {
                        let posts = try JSONDecoder().decode([Post].self, from: data )
                        completion(.success(posts))
                    } catch {
                        completion(.failure(error))
                    }
            }
            
            
        }.resume()
    }
    
    func createPost(title: String, body: String, @escaping completion: (Error?) -> () ){
        guard let url = URL(string: "http://localhost:1337/post") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let params = ["title": title, "postBody":body]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlRequest.httpBody = data
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
                  
                  URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                      guard let data = data else {return}
                      completion(nil)
                      
                  }.resume()
        } catch {
            completion(error)
        }
        
      
    }
    
    func deletePost(id: Int, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string:  "http://localhost:1337/post/\(id)") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            
            DispatchQueue.main.async {
                 if let err = err{
                    completion(err)
                    return
                }
                
                if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    completion(NSError(domain: "", code: resp.statusCode, userInfo: [NSLocalizedDescriptionKey : errorString]))
                    
                    return
                }
                           
                completion(nil)
                           
            }
            
        }.resume()
    }
}

class ViewController: UITableViewController {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchPosts()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = .init(title: "Create Post", style: .plain, target: self, action: #selector(handleCreatePost))
    }
    
    fileprivate func fetchPosts(){
        Service.shared.fetchPosts { (res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch post ", err)
            
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
                
            }
        }
    }
    
 
    @objc fileprivate func handleCreatePost(){
        Service.shared.createPost(title: "IOS TITLE", body: "IOS POST BODY") { (err) in
            if let err = err {
                print("Failed to create post object", err)
                return
            }
            
            print("Finished creating post")
            self.fetchPosts()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleteing post")
            let post = self.posts[indexPath.row]
            Service.shared.deletePost(id: post.id) { (err) in
                if let err = err {
                    print("Failed to delete", err)
                    return
                }
                
                print("Successfully deleted post from server")
                self.posts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

}

