//
//  DKDiffableDataSource.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

public final class DKDiffableDataSource<Configuration>: UICollectionViewDiffableDataSource<Configuration.SectionIdentifierType, Configuration.ItemIdentifierType> where Configuration: DKDiffableDataSourceConfiguration {

    public init(collectionView: UICollectionView, configuration: Configuration) {
        let cellProvider = configuration.makeCellProvider()

        super.init(collectionView: collectionView, cellProvider: cellProvider)

        supplementaryViewProvider = configuration.makeSupplementaryViewProvider()
    }
}
