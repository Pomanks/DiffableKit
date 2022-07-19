//
//  DKDiffableDataSourceUpdaterProviding.swift
//
//
//  Created by Antoine Barré on 7/19/22.
//

import Foundation

/// You should use this protocol with `DKDiffableDataSourceContainer` in order to automatically get some `diffableDataSourceUpdater` that matches your configuration.
public protocol DKDiffableDataSourceUpdaterProviding {
    associatedtype DataSourceConfiguration: DKDiffableDataSourceConfiguration

    var diffableDataSourceUpdater: DKDiffableDataSourceUpdater<DataSourceConfiguration> { get }
}
