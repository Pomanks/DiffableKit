//
//  DKDiffableDataSourceUpdater.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import CoreData
import Foundation
import UIKit

@available(*, deprecated, renamed: "DKDiffableDataSourceUpdater")
public final class DKDiffableUpdater {}

public final class DKDiffableDataSourceUpdater<Configuration>: NSObject, NSFetchedResultsControllerDelegate where Configuration: DKDiffableDataSourceConfiguration {

    // MARK: Members

    public var fetchedResultsControllerDidChangeContentWithSnapshotHandler: FetchResultsControllerSnapshotHandler?

    public internal(set) var snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>?
    public internal(set) var sectionSnapshots: [SectionIdentifierType: NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>] = [:]

    // MARK: Initializers

    private(set) var diffableDataSource: DKDiffableDataSource<Configuration>

    public init(diffableDataSource: DKDiffableDataSource<Configuration>) {
        self.diffableDataSource = diffableDataSource
    }

    // MARK: NSFetchedResultsControllerDelegate

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {

        fetchedResultsControllerDidChangeContentWithSnapshotHandler?(controller, snapshot)
    }
}
