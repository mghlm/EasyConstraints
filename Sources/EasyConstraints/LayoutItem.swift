//
//  LayoutItem.swift
//  
//
//  Created by Magnus Holm on 09/02/2023.
//

import UIKit

public protocol LayoutItem {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }

    var heightAnchor: NSLayoutDimension { get }
    var widthAnchor: NSLayoutDimension { get }

    var layoutContainer: LayoutItem? { get }
    func disableAutomaticConstraints()
}

public extension LayoutItem {
    @discardableResult func layout(in container: LayoutItem,
                                   insets: InsetProvider = UIEdgeInsets.zero,
                                   edges: LayoutEdges = .all,
                                   priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        self.disableAutomaticConstraints()
        let leadingInset, trailingInset, topInset, bottomInset: CGFloat
        leadingInset = insets.directionalEdgeInsets.leading
        trailingInset = insets.directionalEdgeInsets.trailing
        topInset = insets.directionalEdgeInsets.top
        bottomInset = insets.directionalEdgeInsets.bottom
        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.leading) {
            constraints.append(self.leadingAnchor.constraint(equalTo: container.leadingAnchor,
                                                             constant: leadingInset))
        }
        if edges.contains(.trailing) {
            constraints.append(container.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                                   constant: trailingInset))
        }
        if edges.contains(.top) {
            constraints.append(self.topAnchor.constraint(equalTo: container.topAnchor,
                                                         constant: topInset))
        }
        if edges.contains(.bottom) {
            constraints.append(container.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                                 constant: bottomInset))
        }
        constraints.setPriority(to: priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func layoutInSuperview(insets: InsetProvider = UIEdgeInsets.zero,
                                              edges: LayoutEdges = .all,
                                              priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        guard let container = self.layoutContainer else {
            assertionFailure("Constraint Failure: No container found for \(self)")
            return []
        }
        return self.layout(in: container,
                           insets: insets,
                           edges: edges,
                           priority: priority)
    }

    @discardableResult func match(_ layoutItem: LayoutItem,
                                  on dimensions: LayoutDimension,
                                  multiplier: CGFloat = 1,
                                  offset: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        self.disableAutomaticConstraints()
        var constraints: [NSLayoutConstraint] = []
        if dimensions.contains(.width) {
            constraints.append(self.widthAnchor.constraint(equalTo: layoutItem.widthAnchor,
                                                           multiplier: multiplier,
                                                           constant: offset))
        }
        if dimensions.contains(.height) {
            constraints.append(self.heightAnchor.constraint(equalTo: layoutItem.heightAnchor,
                                                            multiplier: multiplier,
                                                            constant: offset))
        }
        constraints.setPriority(to: priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func match(_ layoutItem: LayoutItem,
                                  at origin: LayoutOrigin,
                                  offset: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        self.disableAutomaticConstraints()
        var constraints: [NSLayoutConstraint] = []
        if origin.contains(.centerX) {
            constraints.append(self.centerXAnchor.constraint(equalTo: layoutItem.centerXAnchor,
                                                             constant: offset))
        }
        if origin.contains(.centerY) {
            constraints.append(self.centerYAnchor.constraint(equalTo: layoutItem.centerYAnchor,
                                                             constant: offset))
        }
        constraints.setPriority(to: priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func match(_ constant: CGFloat,
                                  on dimensions: LayoutDimension,
                                  multiplier: CGFloat = 1,
                                  priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return self.match(CGSize(width: constant, height: constant),
                          on: dimensions,
                          multiplier: multiplier,
                          priority: priority)
    }

    @discardableResult func match(_ size: CGSize,
                                  on dimensions: LayoutDimension,
                                  multiplier: CGFloat = 1,
                                  priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        self.disableAutomaticConstraints()
        var constraints: [NSLayoutConstraint] = []
        if dimensions.contains(.width) {
            constraints.append(self.widthAnchor.constraint(equalToConstant: size.width * multiplier))
        }
        if dimensions.contains(.height) {
            constraints.append(self.heightAnchor.constraint(equalToConstant: size.height * multiplier))
        }
        constraints.setPriority(to: priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func matchSuperview(on dimensions: LayoutDimension,
                                           multiplier: CGFloat = 1,
                                           offset: CGFloat = 0,
                                           priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        guard let container = self.layoutContainer else {
            assertionFailure("Constraint Failure: No container found for \(self)")
            return []
        }
        return self.match(container, on: dimensions, multiplier: multiplier, offset: offset, priority: priority)
    }

    @discardableResult func matchSuperview(at origin: LayoutOrigin,
                                           offset: CGFloat = 0,
                                           priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        guard let container = self.layoutContainer else {
            assertionFailure("Constraint Failure: No container found for \(self)")
            return []
        }
        return self.match(container, at: origin, offset: offset, priority: priority)
    }

    @discardableResult func setAspectRatio(to size: CGSize,
                                           offset: CGFloat = 0,
                                           priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.disableAutomaticConstraints()
        let constraint = self.widthAnchor.constraint(equalTo: self.heightAnchor,
                                                     multiplier: size.width / size.height,
                                                     constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
}

public extension Collection where Element == LayoutItem {
    @discardableResult func stackVertically(spacing: CGFloat = 0,
                                            priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        for item in self {
            item.disableAutomaticConstraints()
        }
        let constraints = zip(self, self.dropFirst()).reduce(into: [NSLayoutConstraint]()) { result, items in
            let (top, bottom) = (items.0, items.1)
            result.append(bottom.topAnchor.constraint(equalTo: top.bottomAnchor, constant: spacing))
        }
        constraints.setPriority(to: priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func stackHorizontally(spacing: CGFloat = 0,
                                              priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        for item in self {
            item.disableAutomaticConstraints()
        }
        let constraints = zip(self, self.dropFirst()).reduce(into: [NSLayoutConstraint]()) { result, items in
            let (leading, trailing) = (items.0, items.1)
            result.append(trailing.leadingAnchor.constraint(equalTo: leading.trailingAnchor, constant: spacing))
        }
        constraints.setPriority(to: priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func layout(in container: LayoutItem,
                                   insets: InsetProvider = UIEdgeInsets.zero,
                                   edges: LayoutEdges = .all,
                                   priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return self.flatMap { item in
            return item.layout(in: container,
                               insets: insets,
                               edges: edges,
                               priority: priority)
        }
    }
}

private extension Array where Element == NSLayoutConstraint {
    func setPriority(to priority: UILayoutPriority) {
        for constraint in self {
            constraint.priority = priority
        }
    }
}

extension UIView: LayoutItem {
    public var layoutContainer: LayoutItem? { return self.superview }
    public func disableAutomaticConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILayoutGuide: LayoutItem {
    public var layoutContainer: LayoutItem? { return self.owningView }
    public func disableAutomaticConstraints() {}
}
