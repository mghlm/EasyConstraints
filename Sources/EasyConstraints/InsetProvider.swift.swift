//
//  InsetProvider.swift.swift
//  
//
//  Created by Magnus Holm on 09/02/2023.
//

import UIKit

public protocol InsetProvider {
    var directionalEdgeInsets: NSDirectionalEdgeInsets { get }
}

extension UIEdgeInsets: InsetProvider {
    public var directionalEdgeInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: self.top,
                                       leading: self.left,
                                       bottom: self.bottom,
                                       trailing: self.right)
    }
}

extension CGFloat: InsetProvider {
    public var directionalEdgeInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: self,
                                       leading: self,
                                       bottom: self,
                                       trailing: self)
    }
}

extension Int: InsetProvider {
    public var directionalEdgeInsets: NSDirectionalEdgeInsets { return CGFloat(self).directionalEdgeInsets }
}

extension Float: InsetProvider {
    public var directionalEdgeInsets: NSDirectionalEdgeInsets { return CGFloat(self).directionalEdgeInsets }
}
