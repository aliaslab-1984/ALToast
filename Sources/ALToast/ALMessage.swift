//
//  File.swift
//  
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

/// Represents a generic image resource that could be displayed inside the Toast.
public enum ImageResource {
    /// An SFSymbol name.
    case symbol(name: String)
    /// A generic optional UIImage (it will be resized to match the toast size).
    case image(image: UIImage?)
}

/// Represents a message that is going to be displayed inside a toast. It also specifies the semantic meaning of the message,
/// whether it's a success, an info, an error or a progress.
public struct ALMessage {
    /// The text message that will be displayed inside the toast.
    let message: String?
    /// The optional image that will be displayed inside the toast.
    let imageResource: ImageResource?
    /// A time interval after which the toast view will disappear.
    let hideAfter: TimeInterval?
    /// Where the toast view will be presented.
    let origin: OriginSide
    /// The semantic color used (success, progress, info...)
    let color: SemanticColor
    /// The required haptic feedback that will be performed, according to the semantic.
    let feedbackType: Feedback
    /// Tells wheter the message is a progress or not.
    let isProgress: Bool
    
    public static var defaultHideInterval: TimeInterval = 2.0
  
    init(message: String?,
         resource: ImageResource? = nil,
         hideAfter: TimeInterval? = 2.0,
         color: SemanticColor,
         origin: OriginSide = .top(offsetFromTop: 0),
         progress: Bool = false,
         feedback: Feedback) {
        self.message = message
        self.imageResource = resource
        self.hideAfter = hideAfter
        self.origin = origin
        self.color = color
        self.feedbackType = feedback
        self.isProgress = progress
    }
    
    public static func success(message: String?,
                               icon: ImageResource? = .symbol(name: "checkmark.circle"),
                               hideAfter: TimeInterval? = Self.defaultHideInterval,
                               origin: OriginSide = .top(offsetFromTop: 0)) -> ALMessage {
        return ALMessage(message: message, resource: icon, hideAfter: hideAfter, color: .success, origin: origin, feedback: .success)
    }
    
    public static func warning(message: String?,
                               icon: ImageResource? = .symbol(name: "exclamationmark.triangle"),
                               hideAfter: TimeInterval? = Self.defaultHideInterval,
                               origin: OriginSide = .top(offsetFromTop: 0.0)) -> ALMessage {
        return ALMessage(message: message, resource: icon, hideAfter: hideAfter, color: .warning, origin: origin, feedback: .warning)
    }
    
    public static func info(message: String?,
                            icon: ImageResource? = .symbol(name: "info.circle"),
                            hideAfter: TimeInterval? = Self.defaultHideInterval,
                            origin: OriginSide = .top(offsetFromTop: 0.0)) -> ALMessage {
        return ALMessage(message: message, resource: icon, hideAfter: hideAfter, color: .info, origin: origin, feedback: .info)
    }
    
    public static func custom(message: String?,
                              icon: ImageResource?,
                              color: UIColor,
                              hideAfter: TimeInterval? = Self.defaultHideInterval,
                              origin: OriginSide = .top(offsetFromTop: 0.0),
                              feedback: Feedback) -> ALMessage {
        return ALMessage(message: message, resource: icon, hideAfter: hideAfter, color: .custom(color: color), origin: origin, feedback: feedback)
    }
    
    public static func progress(message: String?,
                                origin: OriginSide = .center(offset: 0.0),
                                hideAfter: TimeInterval? = nil) -> ALMessage {
        return ALMessage(message: message, resource: nil, hideAfter: hideAfter, color: .info, origin: origin, progress: true, feedback: .info)
    }
}

#endif
