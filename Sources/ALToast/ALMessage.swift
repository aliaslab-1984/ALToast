//
//  File.swift
//  
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation

public struct ALMessage {
    
    let message: String?
    let iconName: String?
    let hideAfter: TimeInterval?
    let origin: ALToastMessageView.OriginSide
    
    public static var defaultHideInterval: TimeInterval = 2.0
  
    init(message: String?,
         icon: String? = nil,
         hideAfter: TimeInterval? = 2.0,
         origin: ALToastMessageView.OriginSide = .top) {
        self.message = message
        self.iconName = icon
        self.hideAfter = hideAfter
        self.origin = origin
    }
    
    public static func success(message: String?,
                        icon: String? = "checkmark",
                        hideAfter: TimeInterval? = Self.defaultHideInterval,
                        origin: ALToastMessageView.OriginSide = .top) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, origin: origin)
    }
    
    public static func warning(message: String?,
                        icon: String? = "exclamationmark.triangle",
                        hideAfter: TimeInterval? = Self.defaultHideInterval,
                        origin: ALToastMessageView.OriginSide = .top) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, origin: origin)
    }
    
    public static func info(message: String?,
                     icon: String? = "info.circle",
                     hideAfter: TimeInterval? = Self.defaultHideInterval,
                     origin: ALToastMessageView.OriginSide = .top) -> ALMessage {
        return ALMessage(message: message, icon: icon, hideAfter: hideAfter, origin: origin)
    }
    
    public static func progress(message: String?,
                         origin: ALToastMessageView.OriginSide = .center,
                         hideAfter: TimeInterval? = nil) -> ALMessage {
        return ALMessage(message: message, icon: nil, hideAfter: hideAfter, origin: origin)
    }
}
