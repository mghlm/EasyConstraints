//
//  LayoutOrigin.swift
//  
//
//  Created by Magnus Holm on 09/02/2023.
//

import Foundation

public struct LayoutOrigin: OptionSet, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let centerX = LayoutOrigin(rawValue: 1 << 0)
    public static let centerY = LayoutOrigin(rawValue: 1 << 1)

    public static let center: LayoutOrigin = [centerX, centerY]
}
