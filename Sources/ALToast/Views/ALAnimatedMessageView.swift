//
//  File.swift
//  
//
//  Created by Francesco Bianco on 21/12/21.
//

import Foundation
import ALConstraintKit
import MarqueeLabel
#if canImport(UIKit)
import UIKit

/// A diffrent message that is shown on the center of the presenting window, and can alternate different states before being hidden.
public final class ALAnimatedMessageView: ALMessageView {
    
    private let successMessage: ALMessage
    private let progressMessage: ALMessage
    private let warningMessage: ALMessage
    private let horizontalPadding: CGFloat = 24
    private let verticalPadding: CGFloat = 24
    
    private var state: State {
        didSet {
            display(state: state)
        }
    }
    
    public enum State {
        case progress
        case success
        case warning
    }
    
    public init(success: ALMessage = .success(message: "Success!", icon: .symbol(name: "checkmark.circle"), hideAfter: ALMessage.defaultHideInterval, origin: .center(offset: 0.0)),
                warning: ALMessage = .warning(message: "Something went wrong..", icon: .symbol(name: "xmark.circle"), hideAfter: ALMessage.defaultHideInterval, origin: .center(offset: 0.0)),
                progress: ALMessage = .info(message: "Progress..", icon: nil, hideAfter: ALMessage.defaultHideInterval, origin: .center(offset: 0.0)),
                initialState: State = .progress) {
        self.successMessage = success
        self.warningMessage = warning
        self.progressMessage = progress
        self.state = initialState
        super.init(shadowing: true, isProgress: false, hideAfter: 0)
        if #available(iOS 13.0, *) {
            self.activityIndictor.style = .large
        }
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 2
        display(state: initialState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBaseComponents() {
        vibrancyView.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.mirrorVConstraints(from: vibrancyView, options: .bottom, padding: .init(all: verticalPadding))
        label.mirrorHConstraints(from: vibrancyView, padding: .init(all: horizontalPadding))
        label.heightAnchor.apply(constant: 60)
        // The view starts with a progress, with a callback you can specify whether an error, a success or a new progress has occurred.
        constraintAccessories()
    }
    
    private func display(state: State) {
        switch state {
        case .progress:
            self.tintColor = progressMessage.color.tintColor.withAlphaComponent(0.7)
            self.contentView.backgroundColor = progressMessage.color.color?.withAlphaComponent(0.7)
            self.feedback = progressMessage.feedbackType
            label.text = progressMessage.message
        case .success:
            self.tintColor = successMessage.color.tintColor.withAlphaComponent(0.7)
            self.contentView.backgroundColor = successMessage.color.color?.withAlphaComponent(0.7)
            self.feedback = successMessage.feedbackType
            self.symbolName = successMessage.imageResource
            label.text = successMessage.message
        case .warning:
            self.tintColor = warningMessage.color.tintColor.withAlphaComponent(0.7)
            self.contentView.backgroundColor = warningMessage.color.color?.withAlphaComponent(0.7)
            self.feedback = warningMessage.feedbackType
            self.symbolName = warningMessage.imageResource
            label.text = warningMessage.message
        }
    }
    
    private func constraintAccessories() {
        if state == .progress {
            if activityIndictor.superview == nil {
                vibrancyView.contentView.addSubview(activityIndictor)
                activityIndictor.mirrorVConstraints(from: vibrancyView, options: .top, padding: .init(all: verticalPadding))
                activityIndictor.mirrorHConstraints(from: vibrancyView, padding: .init(all: horizontalPadding))
                activityIndictor.bottomAnchor.anchor(to: label.topAnchor, constant: -verticalPadding)
                image.removeFromSuperview()
                image.deactivateAllConstraints()
            }
        } else {
            if image.superview == nil {
                vibrancyView.contentView.addSubview(image)
                image.mirrorVConstraints(from: vibrancyView, options: .top, padding: .init(all: verticalPadding))
                image.bottomAnchor.anchor(to: label.topAnchor, constant: -verticalPadding)
                image.mirrorHConstraints(from: vibrancyView, padding: .init(all: horizontalPadding))
                activityIndictor.removeFromSuperview()
                activityIndictor.deactivateAllConstraints()
            }
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            // The Toast is visible.
            self.translatesAutoresizingMaskIntoConstraints = false

            self.specify(width: 200, height: 200)
            
            self.centerYAnchor.anchor(to: superview.centerYAnchor)
            self.centerXAnchor.anchor(to: superview.centerXAnchor)
            
            vibrancyView.frame = self.bounds
            
            layer.masksToBounds = true
            label.textAlignment = NSTextAlignment.center
            
            self.transform = .init(translationX: 0.0, y: origin.originStart)
            
            if state == .progress {
                activityIndictor.startAnimating()
            }
        }
    }
    
    override func layoutLabel() {
        label.fadeLength = abs(self.frame.height - 10)
    }
    
    override func updateLabelFrame() -> CGRect {
        let ypoint = max(abs(image.frame.maxY), abs(activityIndictor.frame.maxY))
        let labelOrigin = CGPoint(x: 0.0, y: ypoint)
        return CGRect(origin: labelOrigin, size: CGSize(width: self.frame.width, height: self.frame.height - ypoint))
    }
    
    @MainActor
    public func update(_ state: State, shouldDismiss: Bool = false) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.state = state
        } completion: { [weak self] _ in
            self?.feedback.play()
        }
        
        constraintAccessories()
        
        if shouldDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.hide(animated: true)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 5
    }
}

#endif


