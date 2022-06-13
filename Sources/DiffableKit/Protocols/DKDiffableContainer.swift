//
//  DKDiffableContainer.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

public protocol DKDiffableContainer: UIViewController {
    associatedtype LayoutDescriptor: DKCollectionViewCompositionalLayoutDescription
    associatedtype Configuration: DKDiffableConfiguration

    /// The `collectionView`'s layout description
    var descriptor: LayoutDescriptor { get }
    var collectionView: DKCollectionView<LayoutDescriptor> { get }

    /// The `diffableDataSource`'s associated configuration
    var configuration: Configuration { get }
    var diffableDataSource: DKDiffableDataSource<Configuration> { get }
}
