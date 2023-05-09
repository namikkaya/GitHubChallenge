//
//  KError.swift
//  GitHubChallenge
//
//  Created by namik kaya on 8.05.2023.
//

import Foundation

enum KErrorCode: Int, CaseIterable {
    case general = 1001
    case serverError = 1002 // Add more error cases if needed
    case wordValidError = 998
    case wordIsEmpty = 997
    
    var errorDescription: String {
        switch self {
        case .general:
            return NSLocalizedString("An error occurred.", comment: "")
        case .serverError:
            return NSLocalizedString("Server error occurred.", comment: "")
        case .wordValidError:
            return ""
        case .wordIsEmpty:
            return ""
        }
    }
}

struct KError: Error {
    var errorCode: KErrorCode
    var message: String?
    
    init(errorCode: KErrorCode, message: String? = nil) {
        self.errorCode = errorCode
        self.message = message ?? KErrorCode.general.errorDescription
    }
}
