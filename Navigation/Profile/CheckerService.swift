//
//  CheckerService.swift
//  Navigation
//
//  Created by Евгений Дроздов on 20.04.2023.
//

import Foundation
import FirebaseAuth
import UIKit

typealias handler = (Result<User, Error>) -> Void

protocol CheckerServiceProtocol {
    func signUp(for email: String, and password: String, completionFor completion: @escaping handler)

    func checkCredentials(for email: String, and password: String, completionFor completion: @escaping handler)

}

class CheckerService: CheckerServiceProtocol {
    func signUp(for email: String, and password: String, completionFor completion: @escaping handler) {

        Auth.auth().createUser(withEmail: email, password: password) { autDataResult, error in
            if error == nil {
                let user = User(login: "Ivan", fullName: "Ivanov", avatarImage: UIImage(named: "Ivan")!, status: "Hello world!!")
                print("User creaded by checkerService ", user)
                completion(.success(user))
            } else {
                completion(.failure(error!))
            }
        }
    }


    func checkCredentials(for email: String, and password: String, completionFor completion: @escaping handler) {

        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if error == nil {

                let user = User(login: "Kate", fullName: "Middleton", avatarImage: UIImage(named: "Kate")!, status: "Hello Firebase!")
                print("User checked in checkerService ", user)
                completion(.success(user))
            } else {
                completion(.failure(error!))
            }
        }
    }
}
