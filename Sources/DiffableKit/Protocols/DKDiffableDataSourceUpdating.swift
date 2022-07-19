//
//  DKDiffableDataSourceUpdating.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import CoreData
import Foundation
import UIKit

@available(*, deprecated, renamed: "DKDiffableDataSourceUpdating")
public protocol DKDiffableUpdating: DKDiffableDataSourceUpdating {}

public protocol DKDiffableDataSourceUpdating {
    associatedtype SectionIdentifierType: Hashable & RawRepresentable
    associatedtype ItemIdentifierType: Hashable

//    typealias FetchResultsControllerSnapshotHandler = (NSFetchedResultsController<NSFetchRequestResult>, NSDiffableDataSourceSnapshotReference) -> Void
    typealias SnapshotHandler = (inout NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) -> Void
    typealias SectionSnapshotHandler = (inout NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>) -> Void

//    var fetchedResultsControllerDidChangeContentWithSnapshotHandler: FetchResultsControllerSnapshotHandler? { get set }
    var snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>? { get }
    var sectionSnapshots: [SectionIdentifierType: NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>] { get }

    // MARK: Updating Data

    func newSnapshot(handler: SnapshotHandler) -> Self
    func currentSnapshot(handler: SnapshotHandler) -> Self

    func apply(animatingDifferences: Bool, completion: (() -> Void)?)
    func applySnapshotUsingReloadData(animatingDifferences: Bool, completion: (() -> Void)?)

    func apply(_ snapshot: NSDiffableDataSourceSnapshotReference,
               animatingDifferences: Bool,
               completion: (() -> Void)?)

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
               animatingDifferences: Bool,
               completion: (() -> Void)?)

    // MARK: Updating Section Data

    func newSectionSnapshot(in section: SectionIdentifierType, handler: SectionSnapshotHandler) -> Self
    func currentSectionSnapshot(in section: SectionIdentifierType, handler: SectionSnapshotHandler) -> Self

    func apply(_ snapshot: NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
               to section: SectionIdentifierType,
               animatingDifferences: Bool,
               completion: (() -> Void)?)

    // MARK: Reloading Data

    func reloadItems(_ identifiers: [ItemIdentifierType]) -> Self
    func reconfigureItems(_ identifiers: [ItemIdentifierType]) -> Self
    func reconfigureItems(inSection identifier: SectionIdentifierType) -> Self
    func reconfigureItemsInSections(_ identifiers: [SectionIdentifierType]) -> Self

    func reloadSections(_ identifiers: [SectionIdentifierType]) -> Self

    func expandOrCollapse(item: ItemIdentifierType, shouldCollapseOtherItemsWhenExpanded: Bool) -> Self
    func expandOrCollapseParent(of item: ItemIdentifierType) -> Self
    func reloadSiblings(of item: ItemIdentifierType, includingParent flag: Bool) -> Self
}

// MARK: - Convenience

public extension DKDiffableDataSourceUpdating {

    func apply(_ snapshot: NSDiffableDataSourceSnapshotReference,
               animatingDifferences: Bool = true,
               completion: (() -> Void)? = nil) {

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
               animatingDifferences: Bool = true,
               completion: (() -> Void)? = nil) {

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func apply(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        apply(animatingDifferences: animatingDifferences, completion: completion)
    }

    func applySnapshotUsingReloadData(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        applySnapshotUsingReloadData(animatingDifferences: animatingDifferences, completion: completion)
    }

    func apply(_ snapshot: NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
               to section: SectionIdentifierType,
               animatingDifferences: Bool = true,
               completion: (() -> Void)? = nil) {

        apply(snapshot, to: section, animatingDifferences: animatingDifferences, completion: completion)
    }
}
