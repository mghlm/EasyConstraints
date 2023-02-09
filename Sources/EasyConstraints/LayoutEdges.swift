//
//  LayoutEdges.swift
//  
//
//  Created by Magnus Holm on 09/02/2023.
//

import Foundation

public struct LayoutEdges: OptionSet, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let leading = LayoutEdges(rawValue: 1 << 0)
    public static let trailing = LayoutEdges(rawValue: 1 << 1)
    public static let top = LayoutEdges(rawValue: 1 << 2)
    public static let bottom = LayoutEdges(rawValue: 1 << 3)

    public static let all: LayoutEdges = [.leading, .trailing, top, .bottom]
    public static let vertical: LayoutEdges = [.top, .bottom]
    public static let horizontal: LayoutEdges = [.leading, .trailing]
}
