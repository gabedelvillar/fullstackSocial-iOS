//
//  Service.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/9/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Alamofire

class Service: NSObject {
    static let shared = Service()
    
    let baseUrl = "http://localhost:1337"
    
    func searchForUsers(completion: @escaping (Result<[User]>) -> ()) {
        let url = "\(baseUrl)/search"
        
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    completion(.failure(err))
                    return
                }
                
                do {
                    let data = dataResponse.data ?? Data()
                    let users = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(users))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Data>) -> ()) {
        print("Performing login")
        let params = ["emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/login"
        Alamofire.request(url, method: .put, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                } else {
                    completion(.success(dataResp.data ?? Data()))
                }
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[Post]>) -> ()) {
        let url = "\(baseUrl)/post"
        Alamofire.request(url)
        .validate(statusCode: 200..<300)
        .responseData { (dataResp) in
        if let err = dataResp.error {
            completion(.failure(err))
            return
        }
        
        guard let data = dataResp.data else {return}
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(posts))
        } catch {
            completion(.failure(error))
        }
        
        }
    }
    
    func signUp(fullName: String, emailAddress: String, password: String, completion: @escaping (Result<Data>) -> ()){
        let params = ["fullName": fullName, "emailAddress": emailAddress, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/signup"
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataRep) in
                if let err = dataRep.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(dataRep.data ?? Data()))
                
        }
    }
}
