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
    associatedtype SupplementaryViewContentType
    associatedtype CellContentType

    typealias DKCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    typealias SupplementaryViewContentProvider = (BoundaryElementKind?, String?, IndexPath) -> SupplementaryViewContentType
    typealias CellContentProvider = (ItemIdentifierType, IndexPath) -> CellContentType
    typealias SupplementaryViewProvider = DKCollectionViewDiffableDataSource.SupplementaryViewProvider
    typealias CellProvider = DKCollectionViewDiffableDataSource.CellProvider

    var supplementaryViewContentProvider: SupplementaryViewContentProvider? { get }
    var cellContentProvider: CellContentProvider { get }

    init(supplementaryViewContentProvider: SupplementaryViewContentProvider?,
         cellContentProvider: @escaping CellContentProvider)

    /// **Optional**: This method return nil by default.
    func makeSupplementaryViewProvider() -> SupplementaryViewProvider?
    func makeCellProvider() -> CellProvider
}

public extension DKDiffableDataSourceConfiguration {

    func makeSupplementaryViewProvider() -> SupplementaryViewProvider? {
        nil
    }
}
