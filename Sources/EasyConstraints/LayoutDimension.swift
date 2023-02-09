//
//  LayoutDimension.swift
//  
//
//  Created by Magnus Holm on 09/02/2023.
//

import Foundation

public struct LayoutDimension: OptionSet, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let width = LayoutDimension(rawValue: 1 << 0)
    public static let height = LayoutDimension(rawValue: 1 << 1)
    public static let size: LayoutDimension = [.width, .height]
}
