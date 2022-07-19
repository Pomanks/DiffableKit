//
//  DKDiffableDataSourceUpdater.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import CoreData
import Foundation

@available(*, deprecated, renamed: "DKDiffableDataSourceUpdater")
public final class DKDiffableUpdater {}

public struct DKDiffableDataSourceUpdater<Configuration> where Configuration: DKDiffableDataSourceConfiguration {

    // MARK: Members

    public internal(set) var snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>?
    public internal(set) var sectionSnapshots: [SectionIdentifierType: DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>] = [:]

    // MARK: Initializers

    private(set) var diffableDataSource: DKDiffableDataSource<Configuration>

    public init(diffableDataSource: DKDiffableDataSource<Configuration>) {
        self.diffableDataSource = diffableDataSource
    }
}
