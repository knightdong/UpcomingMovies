//
//  AuthenticationManager.swift
//  UpcomingMovies
//
//  Created by Alonso on 3/24/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import Foundation
import KeychainSwift

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private var userStore: PersistenceStore<User>!
    private lazy var keychain = KeychainSwift()
    
    // MARK: - Initializers
    
    init() {
        setupStores()
    }
    
    // MARK: - Private
    
    private func setupStores() {
        let context = PersistenceManager.shared.mainContext
        userStore = PersistenceStore(context)
    }
    
    // MARK: - Public
    
    func saveCurrentUser(_ sessionId: String, accountId: Int) {
        saveSessionId(sessionId)
        saveUserAccountId(accountId)
    }
    
    func deleteCurrentUser() {
        deleteSessionId()
        deleteUserAccountId()
    }
    
    // MARK: - Session Id
    
    private func saveSessionId(_ sessionId: String) {
        keychain.set(sessionId, forKey: Constants.sessionIdKey)
    }
    
    private func deleteSessionId() {
        keychain.delete(Constants.sessionIdKey)
    }
    
    private func retrieveSessionId() -> String? {
        return keychain.get(Constants.sessionIdKey)
    }
    
    // MARK: - User Account Id
    
    private func saveUserAccountId(_ userId: Int) {
        keychain.set(String(userId), forKey: Constants.currentUserIdKey)
    }
    
    private func deleteUserAccountId() {
        keychain.delete(Constants.sessionIdKey)
    }
    
    private func retrieveUserAccountId() -> Int? {
        guard let userAccountIdString = keychain.get(Constants.currentUserIdKey) else {
            return nil
        }
        return Int(userAccountIdString)
    }
    
    // MARK: - Credentials
    
    func userCredentials() -> (sessionId: String, accountId: Int)? {
        guard let sessionId = retrieveSessionId(),
            let accountId = retrieveUserAccountId() else {
                return nil
        }
        return (sessionId: sessionId, accountId: accountId)
    }
    
    // MARK: - Authentitacion Persistence
    
    func currentUser() -> User? {
        guard let credentials = userCredentials() else { return nil }
        return userStore.find(with: credentials.accountId)
    }
    
    func isUserSignedIn() -> Bool {
        return currentUser() != nil
    }
    
}

extension AuthenticationManager {
    
    struct Constants {
        static let sessionIdKey = "UpcomingMoviesSessionId"
        static let currentUserIdKey = "UpcomingMoviesUserId"
    }
    
}
