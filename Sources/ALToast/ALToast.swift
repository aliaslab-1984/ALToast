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
    public static func show(message: ALMessage,
                            on view: AnyArrangeable? = nil,
                            onTap: (() -> Void)? = nil,
                            onDismiss: (() -> Void)? = nil) -> ALToastMessageView? {
        return prepareAndShow(payload: message, tintColor: message.color.tintColor, backgroundColor: message.color, on: view, isProgress: false, onTap: onTap, onDismiss: onDismiss)
    }
    
    @discardableResult
    public static func progress(message: ALMessage,
                                tintColor: UIColor? = nil,
                                backgroundColor: SemanticColor = .info,
                                on view: AnyArrangeable? = nil,
                                onTap: (() -> Void)? = nil,
                                onDismiss: (() -> Void)? = nil) -> ALToastMessageView? {
        return prepareAndShow(payload: message, tintColor: tintColor, backgroundColor: backgroundColor, on: view, isProgress: true, onTap: onTap, onDismiss: onDismiss)
    }
    
    private static func prepareAndShow(payload: ALMessage,
                                       tintColor: UIColor?,
                                       backgroundColor: SemanticColor,
                                       on view: AnyArrangeable?,
                                       isProgress: Bool,
                                       onTap: (() -> Void)?,
                                       onDismiss: (() -> Void)? = nil) -> ALToastMessageView? {
        let presentable: AnyArrangeable
        
        if let view = view {
            presentable = view
        } else if let root = rootPresentable {
            presentable = root
        } else {
            return nil
        }
        let message = ALToastMessageView(shadowing: false, isProgress: isProgress, hideAfter: payload.hideAfter ?? 2.0)
        message.text = payload.message
        if !isProgress {
            message.symbolName = payload.imageResource
        }
        if let color = tintColor {
            message.tint = color
        } else {
            message.tint = backgroundColor.tintColor
        }
        message.contentView.backgroundColor = backgroundColor.color?.withAlphaComponent(0.7)
        message.onPositiveButtonTap = onTap
        message.onDismiss = onDismiss
        message.feedback = payload.feedbackType
        message.show(on: presentable, origin: payload.origin, animated: true, hideAfter: payload.hideAfter)
        return message
    }
    
}

#endif
