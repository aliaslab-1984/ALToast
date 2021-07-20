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

final class ALToast {
    
    /// Super important to assign the main window to this specific property when the scene is going to come in foreground.
    static var rootPresentable: AnyArrangeable?
    
    static func success(with text: String? = nil,
                        image: String? = nil,
                        tintColor: UIColor? = nil,
                        backgroundColor: SemanticColor = .success,
                        on view: AnyArrangeable? = nil,
                        onTap: (() -> Void)? = nil) {
        
        prepareAndShow(with: text, image: image, tintColor: tintColor, backgroundColor: backgroundColor, on: view, onTap: onTap)
    }
    
    static func warning(with text: String? = nil,
                        image: String? = nil,
                        tintColor: UIColor? = nil,
                        backgroundColor: SemanticColor = .warning,
                        on view: AnyArrangeable? = nil,
                        onTap: (() -> Void)? = nil) {
        prepareAndShow(with: text, image: image, tintColor: tintColor, backgroundColor: backgroundColor, on: view, onTap: onTap)
    }
    
    static func info(with text: String? = nil,
                     image: String? = nil,
                     tintColor: UIColor? = nil,
                     backgroundColor: SemanticColor = .info,
                     on view: AnyArrangeable? = nil,
                     onTap: (() -> Void)? = nil) {
        prepareAndShow(with: text, image: image, tintColor: tintColor, backgroundColor: backgroundColor, on: view, onTap: onTap)
    }
    
    private static func prepareAndShow(with text: String?,
                                image: String?,
                                tintColor: UIColor?,
                                backgroundColor: SemanticColor,
                                on view: AnyArrangeable?,
                                onTap: (() -> Void)?) {
        let presentable: AnyArrangeable
        
        if let view = view {
            presentable = view
        } else if let root = rootPresentable {
            presentable = root
        } else {
            return
        }
        let message = ALToastMessageView(shadowing: false)
        message.text = text
        message.symbolName = image
        if let color = tintColor {
            message.tint = color
        } else {
            message.tint = backgroundColor.tintColor
        }
        message.contentView.backgroundColor = backgroundColor.color
        message.onPositiveButtonTap = onTap
        message.show(on: presentable, origin: .top, animated: true, hideAfter: 1.5)
    }
    
}

#endif
