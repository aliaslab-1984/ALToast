//
//  File.swift
//  
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public struct ALMessage {
    
    let message: String?
    let iconName: String?
    let hideAfter: TimeInterval?
    let origin: ALToastMessageView.OriginSide
    let color: SemanticColor
    let feedbackType: Feedback
    
    public static var defaultHideInterval: TimeInterval = 2.0
  
    init(message: String?,
         icon: String? = nil,
         hideAfter: TimeInterval? = 2.0,
         color: SemanticColor,
         origin: ALToastMessageView.OriginSide = .top,
         feedback: Feedback) {
        self.message = message
        self.iconName = icon
        self.hideAfter = hideAfter
        self.origin = origin
        self.color = color
        self.feedbackType = feedback
    }
    
    public static func success(message: String?,
                               icon: String? = "checkmark",
                               hideAfter: TimeInterval? = Self.defaultHideInterval,
                               origin: ALToastMessageView.OriginSide = .top) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, color: .success, origin: origin, feedback: .success)
    }
    
    public static func warning(message: String?,
                               icon: String? = "exclamationmark.triangle",
                               hideAfter: TimeInterval? = Self.defaultHideInterval,
                               origin: ALToastMessageView.OriginSide = .top) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, color: .warning, origin: origin, feedback: .warning)
    }
    
    public static func info(message: String?,
                            icon: String? = "info.circle",
                            hideAfter: TimeInterval? = Self.defaultHideInterval,
                            origin: ALToastMessageView.OriginSide = .top) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, color: .info, origin: origin, feedback: .info)
    }
    
    public static func custom(message: String?,
                              icon: String?,
                              color: UIColor,
                              hideAfter: TimeInterval? = Self.defaultHideInterval,
                              origin: ALToastMessageView.OriginSide = .top,
                              feedback: Feedback) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, color: .custom(color: color), origin: origin, feedback: feedback)
    }
    
    public static func progress(message: String?,
                                origin: ALToastMessageView.OriginSide = .center,
                                hideAfter: TimeInterval? = nil) -> ALMessage {
        return ALMessage(message: message, icon: nil, hideAfter: hideAfter, color: .info, origin: origin, feedback: .info)
    }
}

#endif
