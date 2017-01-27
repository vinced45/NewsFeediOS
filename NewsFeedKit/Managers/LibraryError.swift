//
//  NewsFeedError.swift
//  NewsFeediOS
//
//  Created by Vince on 1/21/17.
//  Copyright © 2017 Vince Davis. All rights reserved.
//

import Foundation

/**
 Used to error data.
 */
class NewsFeedError: NSObject, Error {
    
    // MARK: - Properties
    
    /**
     The localized error description.
     */
    let localizedDescription: String
    /**
     The error code.
     */
    let code: Int
    
    // MARK: - Lifecycle
    
    /**
     The initializer.
     
     - parameter error: String
     */
    init(error: String) {
        localizedDescription = error
        code = 0
    }
    init(string: String, code: Int) {
        localizedDescription = string
        self.code = code
    }
    init(errorType: Error) {
        localizedDescription = errorType.localizedDescription
        if let nserror = errorType as NSError? {
            code = nserror.code
        } else {
            code = 0
        }
    }
}

protocol NSErrorConvertible {
    func toError() -> Error
}

extension NewsFeedError: NSErrorConvertible {
    func toError() -> Error {
        return NSError(domain: "ChicagoLibraryKit", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription]) as Error
    }
}

extension NewsFeedError {
    static func `default`(code: Int = 0) -> NewsFeedError {
        return NewsFeedError(string: "Please contact Vince Davis.", code: code)
    }
    static func realmInsufficientAddressSpace() -> NewsFeedError {
        return NewsFeedError(string: "There is insufficient available address space.", code: 0)
    }
    static func permissions() -> NewsFeedError {
        return NewsFeedError(string: "You don't have your info.plist permissions setup", code: 0)
    }
    override var description: String {
        get {
            return toError().localizedDescription
        }
    }
}
