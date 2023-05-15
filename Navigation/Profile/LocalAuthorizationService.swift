//
//  LocalAuth.swift
//  Navigation
//
//  Created by Евгений Дроздов on 15.05.2023.
//

import UIKit
import LocalAuthentication

class LocalAuthorizationService {
    enum BiometricType {
        case none
        case touchID
        case faceID
        case unknown
    }
    enum BiometricError: LocalizedError {
        case authenticationFailed
        case userCancel
        case userFallback
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .authenticationFailed:
                return "There was a problem verifying your identity."
            case .userCancel:
                return "You pressed cancel."
            case .userFallback:
                return "You pressed password."
            case .biometryNotAvailable:
                return "Face ID/Touch ID is not available."
            case .biometryNotEnrolled:
                return "Face ID/Touch ID is not set up."
            case .biometryLockout:
                return "Face ID/Touch ID is locked."
            case .unknown:
                return "Face ID/Touch ID may not be configured"
            }
        }
    }
    var currenttype: BiometricType = .none
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    private var error: NSError?
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics, localizedReason: String = "Verify your Identity", localizedFallbackTitle: String = "Enter password") {
        self.policy = policy
        self.localizedReason = localizedReason
        context.localizedFallbackTitle = localizedFallbackTitle
        context.localizedCancelTitle = "Touch me not"
    }
    
    func canEvaluate(completion: (Bool, BiometricType, BiometricError?) -> Void) {
        guard context.canEvaluatePolicy(policy, error: &error) else {
            let type = biometricType(for: context.biometryType)
            currenttype = type
            guard error != nil else {
                completion(false, type, biometricError(from: error! as NSError))
                return
            }
            completion(false, type, biometricError(from: error! as NSError))
            return
        }
        completion(true, currenttype, nil)
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        context.evaluatePolicy(policy, localizedReason: localizedReason) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    authorizationFinished(true)
                } else {
                    guard error != nil else { return }
                    authorizationFinished(false)
                }
            }
        }
    }
    
    private func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .unknown
        }
    }
    
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        return error
    }
}
