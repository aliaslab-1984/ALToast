//
//  ALMessageView.swift
//  File
//
//  Created by Francesco Bianco on 20/07/21.
//

import Foundation
import ALConstraintKit
import MarqueeLabel
#if canImport(UIKit)
import UIKit

public final class ALToastMessageView: ALMessageView {
    
    override func setupBaseComponents() {
        vibrancyView.contentView.addSubview(label)
        
        if isProgress {
            vibrancyView.contentView.addSubview(activityIndictor)
            activityIndictor.trailingAnchor.anchor(to: vibrancyView.trailingAnchor, constant: -8)
            activityIndictor.mirrorVConstraints(from: vibrancyView)
            activityIndictor.widthAnchor.equal(to: vibrancyView.heightAnchor, multiplier: 0.8)
        } else {
            vibrancyView.contentView.addSubview(image)
            image.leadingAnchor.anchor(to: vibrancyView.leadingAnchor, constant: 8)
            image.mirrorVConstraints(from: vibrancyView, padding: .init(all: 8))
            image.widthAnchor.equal(to: vibrancyView.heightAnchor, multiplier: 0.8)
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            // HUD visualizzata
            
            let isPhone = UIDevice.current.userInterfaceIdiom == .phone
            
            let height: CGFloat = (Self.singlePadding * 2) + Self.labelHeight
            let superWidth = superview.frame.width * (isPhone ? 5/6 : 2/5)
            let width = min(superWidth, subViewsWidth())
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.specify(width: width, height: height)
            if origin != .center {
                self.mirrorVConstraints(from: superview,
                                        options: origin == .bottom ? .bottom : .top,
                                        padding: .init(all: 8),
                                        safeArea: true)
            } else {
                self.centerYAnchor.anchor(to: superview.centerYAnchor)
            }
            self.centerXAnchor.anchor(to: superview.centerXAnchor)
            
            vibrancyView.frame = self.bounds
            
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.textColor = textColor
            self.transform = .init(translationX: 0.0, y: origin == .bottom ? 200 : -200)
            
            if isProgress {
                activityIndictor.startAnimating()
            }
        }
    }
    
    override func subViewsWidth() -> CGFloat {
        let height: CGFloat = (Self.singlePadding * 2) + Self.labelHeight
        return max(image.frame.width, height) + label.frame.width + Self.labelHeight / 2
    }
    
    override func updateLabelFrame() -> CGRect {
        let paddingWidth = self.frame.height
        let labelOrigin = CGPoint(x: paddingWidth, y: 0.0)
        let tWidth = min(label.frame.width,
                         self.frame.width - paddingWidth )
        let labelSize = CGSize(width: tWidth,
                               height: self.frame.height)
        return CGRect(origin: labelOrigin,
                      size: labelSize)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
    }
}

#endif
