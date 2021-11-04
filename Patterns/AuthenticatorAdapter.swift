//
//  AuthenticatorAdapter.swift
//  Patterns
//
//  Created by Кристина Перегудова on 04.11.2021.
//

import SwiftUI

protocol AuthService {
  func login(email: String,
             password: String,
             success: @escaping (User, String) -> Void,
             failure: @escaping (Error?) -> Void)
}

struct User {
  let email: String
  let password: String
}

struct GoogleUser {
  var email: String
  var password: String
  var token: String
}

class GoogleAuthenticator {
  func login(email: String,
             password: String,
             completion: @escaping (GoogleUser?, Error?) -> Void) {
    let token = UUID().uuidString
    let user = GoogleUser(email: email, password: password, token: token)
    completion(user, nil)
  }
}

class GoogleAuthenticatorAdapter: AuthService {
  var authenticator = GoogleAuthenticator()
  
  func login(email: String,
             password: String,
             success: @escaping (User, String) -> Void,
             failure: @escaping (Error?) -> Void) {
    authenticator.login(email: email, password: password) { (googleUser, error) in
      guard  let googleUser = googleUser else {
        failure(error)
        return
      }
      let user = User(email: email, password: password)
      let token = googleUser.token
      success(user, token)
    }
  }
}

class AuthViewModel {
  let authService: AuthService = GoogleAuthenticatorAdapter()
  
  func login(email: String = "user@example.com",
             password: String = "password") {
    authService.login(email: email,
                      password: password,
                      success: { user, token in
      print("Auth succeeded: \(user.email), \(token)")
    }, failure: { error in
      // handle error
    })
  }
}
