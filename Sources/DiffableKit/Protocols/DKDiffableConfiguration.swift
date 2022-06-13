//
//  DKDiffableConfiguration.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

@MainActor
public protocol DKDiffableConfiguration {
    associatedtype SectionIdentifierType: Hashable & RawRepresentable
    associatedtype ItemIdentifierType: Hashable
    associatedtype ContentType

    typealias DKCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    typealias ContentProvider = (IndexPath) -> ContentType
    typealias SupplementaryViewProvider = DKCollectionViewDiffableDataSource.SupplementaryViewProvider
    typealias CellProvider = DKCollectionViewDiffableDataSource.CellProvider

    var contentProvider: ContentProvider { get set }

    init(contentProvider: @escaping ContentProvider)

    /// **Optional**: This method return nil by default.
    func makeSupplementaryViewProvider() -> SupplementaryViewProvider?
    func makeCellProvider() -> CellProvider
}

public extension DKDiffableConfiguration {

    func makeSupplementaryViewProvider() -> SupplementaryViewProvider? {
        nil
    }
}
