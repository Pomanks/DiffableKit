//
//  DKDiffableDataSourceUpdating.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import CoreData
import Foundation

@available(*, deprecated, renamed: "DKDiffableDataSourceUpdating")
public protocol DKDiffableUpdating: DKDiffableDataSourceUpdating {}

public protocol DKDiffableDataSourceUpdating {
    associatedtype SectionIdentifierType: Hashable & RawRepresentable
    associatedtype ItemIdentifierType: Hashable

    typealias DKDiffableDataSourceSnapshotHandler = (inout DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) -> Void
    typealias DKDiffableDataSourceSectionSnapshotHandler = (inout DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>) -> Void

    var snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>? { get }
    var sectionSnapshots: [SectionIdentifierType: DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>] { get }

    // MARK: Updating Data

    nonisolated func newSnapshot(handler: DKDiffableDataSourceSnapshotHandler) -> Self
    nonisolated func currentSnapshot(handler: DKDiffableDataSourceSnapshotHandler) -> Self

    nonisolated func apply(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                           animatingDifferences: Bool) async

    nonisolated func apply(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                           animatingDifferences: Bool,
                           completion: (() -> Void)?)

    nonisolated func applySnapshotUsingReloadData(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) async
    nonisolated func applySnapshotUsingReloadData(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                                                  completion: (() -> Void)?)

    nonisolated func apply(animatingDifferences: Bool) async
    nonisolated func apply(animatingDifferences: Bool, completion: (() -> Void)?)

    // MARK: Updating Section Data

    nonisolated func newSectionSnapshot(in section: SectionIdentifierType,
                                        handler: DKDiffableDataSourceSectionSnapshotHandler) -> Self

    nonisolated func currentSectionSnapshot(in section: SectionIdentifierType,
                                            handler: DKDiffableDataSourceSectionSnapshotHandler) -> Self

    nonisolated func apply(_ snapshot: DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
                           to section: SectionIdentifierType,
                           animatingDifferences: Bool) async

    nonisolated func apply(_ snapshot: DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
                           to section: SectionIdentifierType,
                           animatingDifferences: Bool,
                           completion: (() -> Void)?)

    // MARK: Reloading Data

    nonisolated func reloadItems(_ identifiers: [ItemIdentifierType]) -> Self
    nonisolated func reconfigureItems(_ identifiers: [ItemIdentifierType]) -> Self
    nonisolated func reconfigureItems(inSection identifier: SectionIdentifierType) -> Self
    nonisolated func reconfigureItemsInSections(_ identifiers: [SectionIdentifierType]) -> Self

    nonisolated func reloadSections(_ identifiers: [SectionIdentifierType]) -> Self

    nonisolated func expandOrCollapse(itemIdentifier: ItemIdentifierType, shouldCollapseOtherItemsWhenExpanded: Bool) -> Self
    nonisolated func expandOrCollapseParent(of itemIdentifier: ItemIdentifierType) -> Self
    nonisolated func reloadSiblings(of itemIdentifier: ItemIdentifierType, includingParent flag: Bool) -> Self
}

// struct Foo: Hashable {
//
//    let string: String?
//    let int: Int?
// }
//
// struct Bar: Hashable {
//
//    let double: Double?
//    let float: Float?
// }
//
// enum FooBar: Hashable {
//    case foo(Foo)
//    case bar(Bar)
// }
