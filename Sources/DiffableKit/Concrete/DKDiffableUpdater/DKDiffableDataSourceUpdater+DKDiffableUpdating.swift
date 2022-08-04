//
//  DKDiffableDataSourceUpdater+DKDiffableUpdating.swift
//
//
//  Created by Antoine Barré on 6/1/22.
//

import Foundation

// MARK: - DKDiffableDataSourceUpdating

extension DKDiffableDataSourceUpdater: DKDiffableDataSourceUpdating {
    public typealias SectionIdentifierType = Configuration.SectionIdentifierType
    public typealias ItemIdentifierType = Configuration.ItemIdentifierType

    // MARK: Updating Data

    public nonisolated func newSnapshot(handler: DKDiffableDataSourceSnapshotHandler) -> Self {
        var copy = self
        var newSnapshot = DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()

        handler(&newSnapshot)

        copy.snapshot = newSnapshot

        return copy
    }

    public nonisolated func currentSnapshot(handler: DKDiffableDataSourceSnapshotHandler) -> Self {
        var copy = self
        var currentSnapshot = snapshot ?? diffableDataSource.snapshot()

        handler(&currentSnapshot)

        copy.snapshot = currentSnapshot

        return copy
    }

    public nonisolated func apply(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                                  animatingDifferences: Bool) async {

        await diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    public nonisolated func apply(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                                  animatingDifferences: Bool = true,
                                  completion: (() -> Void)? = nil) {

        diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    public nonisolated func applySnapshotUsingReloadData(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) async {

        if #available(iOS 15.0, *) {
            await diffableDataSource.applySnapshotUsingReloadData(snapshot)
        }
        else {
            await diffableDataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    public nonisolated func applySnapshotUsingReloadData(_ snapshot: DKDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                                                         completion: (() -> Void)? = nil) {

        if #available(iOS 15.0, *) {
            diffableDataSource.applySnapshotUsingReloadData(snapshot, completion: completion)
        }
        else {
            diffableDataSource.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    public nonisolated func apply(animatingDifferences: Bool = true) async {
        if let snapshot = snapshot {
            let animatingDifferences = sectionSnapshots.isEmpty ? animatingDifferences : false

            await apply(snapshot, animatingDifferences: animatingDifferences)
        }

        for (section, sectionSnapshot) in sectionSnapshots {
            await diffableDataSource.apply(sectionSnapshot, to: section, animatingDifferences: animatingDifferences)
        }
    }

    public nonisolated func apply(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        if let snapshot = snapshot {
            let animatingDifferences = sectionSnapshots.isEmpty ? animatingDifferences : false

            apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }

        for (section, sectionSnapshot) in sectionSnapshots {
            diffableDataSource.apply(sectionSnapshot, to: section, animatingDifferences: animatingDifferences)
        }
    }

    // MARK: Updating Section Data

    public nonisolated func newSectionSnapshot(in section: SectionIdentifierType, handler: DKDiffableDataSourceSectionSnapshotHandler) -> Self {
        var copy = self
        var newSectionSnapshot = DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>()

        handler(&newSectionSnapshot)

        copy.sectionSnapshots[section] = newSectionSnapshot

        return copy
    }

    public nonisolated func currentSectionSnapshot(in section: SectionIdentifierType,
                                                   handler: DKDiffableDataSourceSectionSnapshotHandler) -> Self {

        var copy = self
        var currentSectionSnapshot = sectionSnapshots[section] ?? diffableDataSource.snapshot(for: section)

        handler(&currentSectionSnapshot)

        copy.sectionSnapshots[section] = currentSectionSnapshot

        return copy
    }

    public nonisolated func apply(_ snapshot: DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
                                  to section: SectionIdentifierType,
                                  animatingDifferences: Bool = true) async {

        await diffableDataSource.apply(snapshot, to: section, animatingDifferences: animatingDifferences)
    }

    public nonisolated func apply(_ snapshot: DKDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
                                  to section: SectionIdentifierType,
                                  animatingDifferences: Bool = true,
                                  completion: (() -> Void)? = nil) {
        diffableDataSource.apply(snapshot, to: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    // MARK: Reloading Data

    public nonisolated func reloadItems(_ identifiers: [ItemIdentifierType]) -> Self {
        currentSnapshot { snapshot in
            let existingItemIdentifiers = identifiers.filter {
                snapshot.indexOfItem($0) != nil
            }
            snapshot.reloadItems(existingItemIdentifiers.isEmpty ? snapshot.itemIdentifiers : existingItemIdentifiers)
        }
    }

    public nonisolated func reconfigureItems(_ identifiers: [ItemIdentifierType] = []) -> Self {
        currentSnapshot { snapshot in
            let existingItemIdentifiers = identifiers.filter {
                snapshot.indexOfItem($0) != nil
            }

            if #available(iOS 15.0, *) {
                snapshot.reconfigureItems(existingItemIdentifiers.isEmpty ? snapshot.itemIdentifiers : existingItemIdentifiers)
            }
            else {
                snapshot.reloadItems(existingItemIdentifiers.isEmpty ? snapshot.itemIdentifiers : existingItemIdentifiers)
            }
        }
    }

    public nonisolated func reconfigureItems(inSection identifier: SectionIdentifierType) -> Self {
        currentSnapshot { snapshot in
            let items = snapshot.itemIdentifiers(inSection: identifier)

            if #available(iOS 15.0, *) {
                snapshot.reconfigureItems(items)
            }
            else {
                snapshot.reloadItems(items)
            }
        }
    }

    public nonisolated func reconfigureItemsInSections(_ identifiers: [SectionIdentifierType]) -> Self {
        currentSnapshot { snapshot in
            for identifier in identifiers where snapshot.sectionIdentifiers.contains(identifier) {
                let items = snapshot.itemIdentifiers(inSection: identifier)

                if #available(iOS 15.0, *) {
                    snapshot.reconfigureItems(items)
                }
                else {
                    snapshot.reloadItems(items)
                }
            }
        }
    }

    public nonisolated func reloadSections(_ identifiers: [SectionIdentifierType] = []) -> Self {
        currentSnapshot { snapshot in
            let existingSectionIdentifiers = identifiers.filter {
                snapshot.indexOfSection($0) != nil
            }
            snapshot.reloadSections(existingSectionIdentifiers.isEmpty ? snapshot.sectionIdentifiers : existingSectionIdentifiers)
        }
    }

    public nonisolated func expandOrCollapse(itemIdentifier: ItemIdentifierType, shouldCollapseOtherItemsWhenExpanded: Bool = true) -> Self {
        let currentSnapshot = snapshot ?? diffableDataSource.snapshot()

        guard let section = currentSnapshot.sectionIdentifier(containingItem: itemIdentifier) else {
            return self
        }
        return currentSectionSnapshot(in: section) { sectionSnapshot in
            if sectionSnapshot.isExpanded(itemIdentifier) {
                sectionSnapshot.collapse([itemIdentifier])
            }
            else {
                sectionSnapshot.expand([itemIdentifier])

                if shouldCollapseOtherItemsWhenExpanded {
                    sectionSnapshot.collapse(sectionSnapshot.rootItems.filter { $0 != itemIdentifier })
                }
            }
        }
    }

    public nonisolated func expandOrCollapseParent(of itemIdentifier: ItemIdentifierType) -> Self {
        let currentSnapshot = snapshot ?? diffableDataSource.snapshot()

        guard let section = currentSnapshot.sectionIdentifier(containingItem: itemIdentifier) else {
            return self
        }
        return currentSectionSnapshot(in: section) { sectionSnapshot in
            guard let parent = sectionSnapshot.parent(of: itemIdentifier) else {
                return
            }
            if sectionSnapshot.isExpanded(parent) {
                sectionSnapshot.collapse([parent])
            }
            else {
                sectionSnapshot.expand([parent])
            }
        }
    }

    public nonisolated func reloadSiblings(of itemIdentifier: ItemIdentifierType, includingParent flag: Bool) -> Self {
        currentSnapshot { snapshot in
            guard let section = snapshot.sectionIdentifier(containingItem: itemIdentifier) else {
                return
            }
            let sectionSnapshot = diffableDataSource.snapshot(for: section)

            if let parent = sectionSnapshot.parent(of: itemIdentifier) {
                let childSnapshot = sectionSnapshot.snapshot(of: parent, includingParent: flag)

                if #available(iOS 15.0, *) {
                    snapshot.reconfigureItems(childSnapshot.items)
                }
                else {
                    snapshot.reloadItems(childSnapshot.items)
                }
            }
        }
    }
}
