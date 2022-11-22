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
    
    var layoutStartingOffset: CGFloat {
        let finalOffset: Double
        switch self {
        case let .top(offsetFromTop):
            finalOffset = offsetFromTop - 200
        case let .center(offset):
            finalOffset = offset + 200
        case let .bottom(offsetFromBottom):
            finalOffset = offsetFromBottom + 200
        }
        
        return finalOffset
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
