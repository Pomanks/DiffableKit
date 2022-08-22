//
//  DKCollectionView.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

public final class DKCollectionView<LayoutDescription>: UICollectionView where LayoutDescription: DKCollectionViewCompositionalLayoutDescription {

    // MARK: Initializers

    public init(frame: CGRect, layout description: LayoutDescription) {
        let layout = description.makeCompositionalLayout()

        super.init(frame: frame, collectionViewLayout: layout)

        preservesSuperviewLayoutMargins = true
    }

    @available(*, unavailable)
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        fatalError("init(frame:collectionViewLayout:) has not been implemented")
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    public func configure(with parent: UIViewController) {
        delegate = parent as? UICollectionViewDelegate
        prefetchDataSource = parent as? UICollectionViewDataSourcePrefetching
        dragDelegate = parent as? UICollectionViewDragDelegate
        dropDelegate = parent as? UICollectionViewDropDelegate

        isPrefetchingEnabled = prefetchDataSource != nil
    }

    ///
    /// Adds `self` as a subview of the `superview` and sets its contraints to fill its superview.
    ///
    /// - Warning: This method sets `translatesAutoresizingMaskIntoConstraints` to `false`.
    ///
    public func add(to superview: UIView?) {
        guard let view = superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
