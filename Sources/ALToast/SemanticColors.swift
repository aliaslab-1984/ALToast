//
//  File.swift
//  File
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation
#if canImport(UIKit)
import UIKit


public enum SemanticColor {
    
    case success
    case warning
    case info
    case custom(color: UIColor)

    public var color: UIColor? {
        switch self {
        case .success:
            if #available(iOS 13.0, *) {
                return .systemGreen
            } else {
                return .green
            }
        case .warning:
            if #available(iOS 13.0, *) {
                return .systemOrange
            } else {
                return .orange
            }
        case .info:
            return nil
        case let .custom(color):
            return color
        }
    }
    
    public var tintColor: UIColor {
        switch self {
        case .success:
            return .white
        case .warning:
            return .white
        case .info:
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        case .custom:
            return .white
        }
    }
}

#endif
