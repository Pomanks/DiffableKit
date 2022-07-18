//
//  DKDiffableDataSourceUpdater+DKDiffableUpdating.swift
//
//
//  Created by Antoine Barré on 6/1/22.
//

import Foundation
import UIKit

// MARK: - DKDiffableDataSourceUpdating

extension DKDiffableDataSourceUpdater: DKDiffableDataSourceUpdating {
    public typealias SectionIdentifierType = Configuration.SectionIdentifierType
    public typealias ItemIdentifierType = Configuration.ItemIdentifierType

    // MARK: Updating Data

    public func newSnapshot(handler: @escaping SnapshotHandler) -> Self {
        var newSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()

        handler(&newSnapshot)

        snapshot = newSnapshot

        return self
    }

    public func currentSnapshot(handler: @escaping SnapshotHandler) -> Self {
        var currentSnapshot = snapshot ?? diffableDataSource.snapshot()

        handler(&currentSnapshot)

        snapshot = currentSnapshot

        return self
    }

    public func apply(_ snapshot: NSDiffableDataSourceSnapshotReference,
                      animatingDifferences: Bool = true,
                      completion: (() -> Void)? = nil) {

        let snapshot = snapshot as NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    public func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
                      animatingDifferences: Bool = true,
                      completion: (() -> Void)? = nil) {

        diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    public func apply(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        if let updatedSnapshot = snapshot {
            let animatingDifferences = sectionSnapshots.isEmpty ? animatingDifferences : false

            apply(updatedSnapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
        sectionSnapshots.forEach { section, snapshot in
            diffableDataSource.apply(snapshot, to: section, animatingDifferences: animatingDifferences)
        }
        cleanSnapshots()
    }

    public func applySnapshotUsingReloadData(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        guard #available(iOS 15.0, *) else {
            apply(animatingDifferences: animatingDifferences, completion: completion)

            return
        }
        if let updatedSnapshot = snapshot {
            diffableDataSource.applySnapshotUsingReloadData(updatedSnapshot, completion: completion)
        }
        sectionSnapshots.forEach { section, snapshot in
            apply(snapshot, to: section, animatingDifferences: animatingDifferences)
        }
        cleanSnapshots()
    }

    // MARK: Updating Section Data

    public func newSectionSnapshot(in section: SectionIdentifierType, handler: @escaping SectionSnapshotHandler) -> Self {
        var newSectionSnapshot = NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>()

        handler(&newSectionSnapshot)

        sectionSnapshots[section] = newSectionSnapshot

        return self
    }

    public func currentSectionSnapshot(in section: SectionIdentifierType,
                                       handler: @escaping SectionSnapshotHandler) -> Self {

        var currentSectionSnapshot = sectionSnapshots[section] ?? diffableDataSource.snapshot(for: section)

        handler(&currentSectionSnapshot)

        sectionSnapshots[section] = currentSectionSnapshot

        return self
    }

    public func apply(_ snapshot: NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>,
                      to section: SectionIdentifierType,
                      animatingDifferences: Bool = true,
                      completion: (() -> Void)? = nil) {

        diffableDataSource.apply(snapshot, to: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    // MARK: Reloading Data

    public func reloadItems(_ identifiers: [ItemIdentifierType]) -> Self {
        currentSnapshot { snapshot in
            let existingItemIdentifiers = identifiers.filter {
                snapshot.indexOfItem($0) != nil
            }
            snapshot.reloadItems(existingItemIdentifiers.isEmpty ? snapshot.itemIdentifiers : existingItemIdentifiers)
        }
    }

    public func reconfigureItems(_ identifiers: [ItemIdentifierType] = []) -> Self {
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

    public func reconfigureItems(inSection identifier: SectionIdentifierType) -> Self {
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

    public func reconfigureItemsInSections(_ identifiers: [SectionIdentifierType]) -> Self {
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

    public func reloadSections(_ identifiers: [SectionIdentifierType] = []) -> Self {
        currentSnapshot { snapshot in
            let existingSectionIdentifiers = identifiers.filter {
                snapshot.indexOfSection($0) != nil
            }
            snapshot.reloadSections(existingSectionIdentifiers.isEmpty ? snapshot.sectionIdentifiers : existingSectionIdentifiers)
        }
    }

    public func expandOrCollapse(item: ItemIdentifierType, shouldCollapseOtherItemsWhenExpanded: Bool = true) -> Self {
        let currentSnapshot = diffableDataSource.snapshot()

        guard let section = currentSnapshot.sectionIdentifier(containingItem: item) else {
            return self
        }
        return currentSectionSnapshot(in: section) { sectionSnapshot in
            if sectionSnapshot.isExpanded(item) {
                sectionSnapshot.collapse([item])
            }
            else {
                sectionSnapshot.expand([item])

                if shouldCollapseOtherItemsWhenExpanded {
                    sectionSnapshot.collapse(sectionSnapshot.rootItems.filter { $0 != item })
                }
            }
        }
    }

    public func expandOrCollapseParent(of item: ItemIdentifierType) -> Self {
        let currentSnapshot = diffableDataSource.snapshot()

        guard let section = currentSnapshot.sectionIdentifier(containingItem: item) else {
            return self
        }
        return currentSectionSnapshot(in: section) { sectionSnapshot in
            guard let parent = sectionSnapshot.parent(of: item) else {
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

    public func reloadSiblings(of item: ItemIdentifierType, includingParent flag: Bool) -> Self {
        currentSnapshot { [unowned self] snapshot in
            guard let section = snapshot.sectionIdentifier(containingItem: item) else {
                return
            }
            let sectionSnapshot = diffableDataSource.snapshot(for: section)

            if let parent = sectionSnapshot.parent(of: item) {
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

// MARK: - Helpers

private extension DKDiffableDataSourceUpdater {

    func cleanSnapshots() {
        snapshot = nil
        sectionSnapshots = [:]
    }
}
