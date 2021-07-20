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

public final class ALToastMessageView: UIVisualEffectView {
    
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
        }
    }
    
    public var symbolName: String? {
        didSet {
            if let imageN = symbolName {
                if #available(iOSApplicationExtension 13.0, *) {
                    image.image = UIImage(systemName: imageN)
                } else {
                    // Fallback on earlier versions
                    image.image = UIImage(named: imageN)
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
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    private let image: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOSApplicationExtension 13.0, *) {
            label.tintColor = .label
        } else {
            // Fallback on earlier versions
            label.tintColor = .black
        }
        label.contentMode = .scaleAspectFit
        return label
    }()

    private let vibrancyView: UIVisualEffectView
    private let shadowning: Bool
    
    /**
     Initialize a progressHUD
     
     - Parameters:
        - text: what to display
        - shadowing: true to have a lighter dialog (usually because there is a shadowing view under it)
     */
    public init(shadowing: Bool = true) {
        let blurEffect = shadowing ? Self.lightStyle : Self.prominentStyle
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        self.shadowning = shadowing
        self.vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        let blurEffect = Self.prominentStyle
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        shadowning = false
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private static let activityIndicatorSize: CGFloat = 40
    private static let labelHeight: CGFloat = 40
    private static let singlePadding: CGFloat = 4
    
    lazy var stack: UIStackView = { [unowned self] in
        return ALConstraintMaker.makeStack(axis: .horizontal, views: [self.image, self.label], alignment: .leading, distribution: .fillProportionally)
    }()
    
    var onPositiveButtonTap: (() -> Void)?
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(stack)
        
        vibrancyView.fillSuperview()
        
        stack.fillSuperview(padding: .init([.horizontal: 8]))
        stack.spacing = 12
    
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(buttonDismiss))
        self.isUserInteractionEnabled = true
        addGestureRecognizer(gestureRec)
        
        image.widthAnchor.equal(to: stack.heightAnchor)
        
        if shadowning {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 10
        }
    }
    
    @objc private func buttonDismiss() {
        onPositiveButtonTap?()
        hide(animated: true)
    }
    
    private static var prominentStyle: UIBlurEffect {
        if #available(iOSApplicationExtension 13.0, *) {
            return UIBlurEffect(style: .systemChromeMaterial)
        } else {
            // Fallback on earlier versions
            return UIBlurEffect(style: .prominent)
        }
    }
    
    private static var lightStyle: UIBlurEffect {
        if #available(iOSApplicationExtension 13.0, *) {
            return UIBlurEffect(style: .systemUltraThinMaterial)
        } else {
            // Fallback on earlier versions
            return UIBlurEffect(style: .light)
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            // HUD visualizzata
            
            let isPhone = UIDevice.current.userInterfaceIdiom == .phone
            
            let height: CGFloat = (Self.singlePadding * 2) + Self.labelHeight
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.widthAnchor.equal(to: superview.widthAnchor, multiplier: isPhone ? 5/6 : 2/5)
          
            self.specify(width: nil, height: height)
            self.mirrorVConstraints(from: superview, options: origin == .bottom ? .bottom : .top, padding: .init(all: 8), safeArea: true)
            self.centerXAnchor.anchor(to: superview.centerXAnchor)
            
            vibrancyView.frame = self.bounds
            
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.textColor = textColor
            self.transform = .init(translationX: 0.0, y: origin == .bottom ? 200 : -200)
        }
    }
    
    public enum OriginSide {
        case bottom
        case top
    }
    
    var origin: OriginSide!
    
    var onDismiss: (() -> Void)?
    
    public func show(on view: AnyArrangeable,
                     origin: OriginSide = .bottom,
                     animated: Bool = true,
                     hideAfter: TimeInterval = 4.0) {
        
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
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) { [weak self] in
            self?.alpha = 1
            self?.transform = .identity
            self?.layoutIfNeeded()
        } completion: { [weak self] (completed) in
            if completed {
                self?.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter) { [weak self] in
                    self?.hide(animated: animated)
                }
            }
        }
    }
    
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
            self?.alpha = 0
            self?.transform = .init(translationX: 0.0, y: self?.origin == .bottom ? 200 : -200)
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
