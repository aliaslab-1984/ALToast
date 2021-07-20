//
//  File.swift
//  File
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation
import ALConstraintKit
#if canImport(UIKit)
import UIKit

public final class ALToast {
    
    /// Super important to assign the main window to this specific property when the scene is going to come in foreground.
    public static var rootPresentable: AnyArrangeable?
    
    @discardableResult
    public static func success(message: ALMessage,
                               tintColor: UIColor? = nil,
                               backgroundColor: SemanticColor = .success,
                               on view: AnyArrangeable? = nil,
                               onTap: (() -> Void)? = nil) -> ALToastMessageView? {
        
        return prepareAndShow(payload: message, tintColor: tintColor, backgroundColor: backgroundColor, on: view, isProgress: false, onTap: onTap)
    }
    
    @discardableResult
    public static func warning(message: ALMessage,tintColor: UIColor? = nil,
                               backgroundColor: SemanticColor = .warning,
                               on view: AnyArrangeable? = nil,
                               onTap: (() -> Void)? = nil) -> ALToastMessageView? {
        return prepareAndShow(payload: message, tintColor: tintColor, backgroundColor: backgroundColor, on: view, isProgress: false, onTap: onTap)
    }
    
    @discardableResult
    public static func info(message: ALMessage,
                            tintColor: UIColor? = nil,
                            backgroundColor: SemanticColor = .info,
                            on view: AnyArrangeable? = nil,
                            onTap: (() -> Void)? = nil) -> ALToastMessageView? {
        return prepareAndShow(payload: message, tintColor: tintColor, backgroundColor: backgroundColor, on: view, isProgress: false, onTap: onTap)
    }
    
    @discardableResult
    public static func progress(message: ALMessage,
                                tintColor: UIColor? = nil,
                                backgroundColor: SemanticColor = .info,
                                on view: AnyArrangeable? = nil,
                                onTap: (() -> Void)? = nil) -> ALToastMessageView? {
        return prepareAndShow(payload: message, tintColor: tintColor, backgroundColor: backgroundColor, on: view, isProgress: true, onTap: onTap)
    }
    
    private static func prepareAndShow(payload: ALMessage,
                                       tintColor: UIColor?,
                                       backgroundColor: SemanticColor,
                                       on view: AnyArrangeable?,
                                       isProgress: Bool,
                                       onTap: (() -> Void)?) -> ALToastMessageView? {
        let presentable: AnyArrangeable
        
        if let view = view {
            presentable = view
        } else if let root = rootPresentable {
            presentable = root
        } else {
            return nil
        }
        let message = ALToastMessageView(shadowing: false, isProgress: isProgress)
        message.text = payload.message
        if !isProgress {
            message.symbolName = payload.iconName
        }
        if let color = tintColor {
            message.tint = color
        } else {
            message.tint = backgroundColor.tintColor
        }
        message.contentView.backgroundColor = backgroundColor.color
        message.onPositiveButtonTap = onTap
        message.show(on: presentable, origin: .top, animated: true, hideAfter: payload.hideAfter)
        return message
    }
    
}

#endif
