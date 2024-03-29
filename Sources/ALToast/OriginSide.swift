//
//  OriginSide.swift
//  
//
//  Created by Francesco Bianco on 21/12/21.
//

import Foundation
import UIKit

public enum OriginSide: Equatable {
    case bottom(offsetFromBottom: Double)
    case center(offset: Double)
    case top(offsetFromTop: Double)
    
    public static func ==(lhs: OriginSide, rhs: OriginSide) -> Bool {
        switch (lhs, rhs) {
        case let (bottom(offsetFromBottom1), bottom(offsetFromBottom2)):
            return offsetFromBottom1 == offsetFromBottom2
        case let (top(offsetFromBottom1), top(offsetFromBottom2)):
            return offsetFromBottom1 == offsetFromBottom2
        case let (center(offsetFromBottom1), center(offsetFromBottom2)):
            return offsetFromBottom1 == offsetFromBottom2
        default:
            return false
        }
    }
    
    var originStart: CGFloat {
        if !self.isTop, !self.isCenter {
            // bottom
            return 200
        } else {
            // center and top
            return -200
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .bottom(let offsetFromBottom):
            return CGFloat(offsetFromBottom)
        case .center(let offset):
            return CGFloat(offset)
        case .top(let offsetFromTop):
            return CGFloat(offsetFromTop)
        }
    }
    
    var isCenter: Bool {
        switch self {
        case .bottom, .top:
            return false
        case .center:
            return true
        }
    }
    
    var isTop: Bool {
        switch self {
        case .bottom, .center:
            return false
        case .top:
            return true
        }
    }
}
