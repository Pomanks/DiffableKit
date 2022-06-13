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

    var collectionView: DKCollectionView<LayoutDescriptor> { get }
    var diffableDataSource: DKDiffableDataSource<Configuration> { get }
}
