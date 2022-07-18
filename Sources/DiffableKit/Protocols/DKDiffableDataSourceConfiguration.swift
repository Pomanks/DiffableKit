//
//  DKDiffableDataSourceConfiguration.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

@available(*, deprecated, renamed: "DKDiffableDataSourceConfiguration")
public protocol DKDiffableConfiguration: DKDiffableDataSourceConfiguration {}

@MainActor
public protocol DKDiffableDataSourceConfiguration {
    associatedtype SectionIdentifierType: Hashable & RawRepresentable
    associatedtype ItemIdentifierType: Hashable
    associatedtype ContentType

    typealias DKCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    typealias ContentProvider = (ItemIdentifierType, IndexPath) -> ContentType
    typealias SupplementaryViewProvider = DKCollectionViewDiffableDataSource.SupplementaryViewProvider
    typealias CellProvider = DKCollectionViewDiffableDataSource.CellProvider

    var contentProvider: ContentProvider { get }

    init(contentProvider: @escaping ContentProvider)

    /// **Optional**: This method return nil by default.
    func makeSupplementaryViewProvider() -> SupplementaryViewProvider?
    func makeCellProvider() -> CellProvider
}

public extension DKDiffableDataSourceConfiguration {

    func makeSupplementaryViewProvider() -> SupplementaryViewProvider? {
        nil
    }
}
