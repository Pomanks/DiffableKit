//
//  DKDiffableContainer.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

@available(*, deprecated, renamed: "DKDiffableDataSourceContainer")
public protocol DKDiffableContainer: DKDiffableDataSourceContainer {}

public protocol DKDiffableDataSourceContainer: UIViewController {
    associatedtype LayoutDescriptor: DKCollectionViewCompositionalLayoutDescription
    associatedtype DataSourceConfiguration: DKDiffableDataSourceConfiguration

    /// The `collectionView`'s layout description
    var descriptor: LayoutDescriptor { get }
    var collectionView: DKCollectionView<LayoutDescriptor> { get }

    /// The `diffableDataSource`'s associated configuration
    var dataSourceConfiguration: DataSourceConfiguration { get }
    var diffableDataSource: DKDiffableDataSource<DataSourceConfiguration> { get }
}

public extension DKDiffableDataSourceContainer where Self: DKDiffableDataSourceUpdaterProviding {

    /// This property will automatically be computed from your configuration.
    var diffableDataSourceUpdater: DKDiffableDataSourceUpdater<DataSourceConfiguration> {
        .init(diffableDataSource: diffableDataSource)
    }
}
