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

public class ALMessageView: UIVisualEffectView {
    
    public var textColor: UIColor {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .black
        }
    }
    
    public var text: String? {
        didSet {
            label.text = text
            label.sizeToFit()
        }
    }
    
    public var symbolName: ImageResource? {
        didSet {
            if let imageN = symbolName {
                
                switch imageN {
                case let .symbol(stringName):
                    if #available(iOS 13.0, *) {
                        image.image = UIImage(systemName: stringName)
                    } else {
                        // Fallback on earlier versions
                        image.image = UIImage(named: stringName)
                    }
                case let .image(optionaImage):
                    image.image = optionaImage
                }
            } else {
                image.image = nil
            }
        }
    }
    
    public var tint: UIColor = .black {
        didSet {
            label.textColor = tint
            image.tintColor  = tint
        }
    }
    
    var feedback: Feedback = .silent
    
    lazy var label: MarqueeLabel = { [unowned self] in
        let label = MarqueeLabel(frame: CGRect.zero, duration: self.hideAfter, fadeLength: 30)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            imageView.tintColor = .label
        } else {
            // Fallback on earlier versions
            imageView.tintColor = .black
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var activityIndictor: UIActivityIndicatorView = { [unowned self] in
        let style: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            style = .medium
        } else {
            style = .gray
        }
        let activityView = UIActivityIndicatorView(style: style)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            activityView.color = .label
        }
        return activityView
    }()

    let vibrancyView: UIVisualEffectView
    let shadowning: Bool
    let isProgress: Bool
    let hideAfter: TimeInterval
    /**
     Initialize a progressHUD
     
     - Parameters:
        - text: what to display
        - shadowing: true to have a lighter dialog (usually because there is a shadowing view under it)
     */
    @MainActor
    public init(shadowing: Bool = true,
                isProgress: Bool = false,
                hideAfter: TimeInterval) {
        let blurEffect = shadowing ? Self.lightStyle : Self.prominentStyle
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        self.shadowning = shadowing
        self.isProgress = isProgress
        self.vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        self.hideAfter = hideAfter
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        let blurEffect = Self.prominentStyle
        self.isProgress = false
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        shadowning = false
        self.hideAfter = 2.0
        super.init(coder: aDecoder)
        self.setup()
    }
    
    static let activityIndicatorSize: CGFloat = 40
    static let labelHeight: CGFloat = 40
    static let singlePadding: CGFloat = 4
    
    var onPositiveButtonTap: (() -> Void)?
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.fillSuperview()
        
        setupBaseComponents()
    
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(buttonDismiss))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(buttonDismiss))
        swipeGesture.direction = .up
        self.isUserInteractionEnabled = true
        addGestureRecognizer(gestureRec)
        addGestureRecognizer(swipeGesture)
        
        if shadowning {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 10
        }
    }
    
    func setupBaseComponents() { }
    
    func subViewsWidth() -> CGFloat {
        return self.layer.frame.width
    }
    
    @objc func buttonDismiss() {
        onPositiveButtonTap?()
        hide(animated: true)
    }
    
    static var prominentStyle: UIBlurEffect {
        if #available(iOS 13.0, *) {
            return UIBlurEffect(style: .systemThickMaterial)
        } else {
            // Fallback on earlier versions
            return UIBlurEffect(style: .prominent)
        }
    }
    
    static var lightStyle: UIBlurEffect {
        if #available(iOS 13.0, *) {
            return UIBlurEffect(style: .systemUltraThinMaterial)
        } else {
            // Fallback on earlier versions
            return UIBlurEffect(style: .light)
        }
    }
    
    func updateLabelFrame() -> CGRect {
        let labelSize = CGSize(width: self.frame.width,
                               height: self.frame.height)
        return CGRect(origin: CGPoint.zero, size: labelSize)
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layoutLabel()
    }
    
    func layoutLabel() {
        label.frame = updateLabelFrame()
        label.fadeLength = abs(self.frame.height - 10)
    }
    
    var origin: OriginSide!
    
    var onDismiss: (() -> Void)?
    
    @MainActor
    public func show(on view: AnyArrangeable,
                     origin: OriginSide = .bottom(offsetFromBottom: 0.0),
                     animated: Bool = true,
                     hideAfter: TimeInterval? = 4.0) {
        
        guard superview == nil else {
            return
        }
        
        self.origin = origin
        
        guard animated else {
            self.isHidden = false
            return
        }
        
        view.viewToConstraint.addSubview(self)
        self.didMoveToSuperview()
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) { [weak self] in
            self?.alpha = 1
            self?.transform = .identity
            self?.layoutIfNeeded()
        } completion: { [weak self] (completed) in
            if completed {
                self?.isHidden = false
                
                self?.feedback.play()
                guard let after = hideAfter else {
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
                    self?.hide(animated: animated)
                }
            }
        }
    }
    
    @MainActor
    public func hide(animated: Bool = true) {
        
        guard let _ = superview else {
            return
        }
        
        guard animated else {
            self.isHidden = true
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: { [weak self] in
            guard let self else {
                return
            }
            self.alpha = 0
            self.transform = .init(translationX: 0.0, y: self.origin.layoutStartingOffset)
        }, completion: { [weak self] (completed) in
            if completed {
                self?.isHidden = true
                self?.deactivateAllConstraints()
                self?.removeFromSuperview()
                self?.onDismiss?()
                
                do {
                    self?.onDismiss = nil
                    self?.removeFromSuperview()
                }
            }
        })
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
    }
}

#endif

