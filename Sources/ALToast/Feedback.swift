//
//  File.swift
//  
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public enum Feedback {
    
    case success
    case warning
    case info
    case silent
    
    private static let notification = UINotificationFeedbackGenerator()
    private static let impact = UIImpactFeedbackGenerator(style: .light)
    
    public func play() {
        switch self {
        case .success:
            Self.notification.notificationOccurred(.success)
        case .warning:
            Self.notification.notificationOccurred(.warning)
        case .info:
            Self.impact.impactOccurred()
        case .silent:
            break
        }
    }
}


#endif
