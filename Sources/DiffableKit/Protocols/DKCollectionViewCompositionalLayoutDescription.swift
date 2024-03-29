//
//  DKCollectionViewCompositionalLayoutDescription.swift
//
//
//  Created by Antoine Barré on 5/19/22.
//

import Foundation
import UIKit

@MainActor
public protocol DKCollectionViewCompositionalLayoutDescription {
    associatedtype SectionIdentifierType: Hashable & RawRepresentable
    typealias SectionProvider = UICollectionViewCompositionalLayoutSectionProvider
    typealias SectionIdentifierAtSectionIndexProvider = (Int) -> SectionIdentifierType?

    var sectionIdentifierAtSectionIndexProvider: SectionIdentifierAtSectionIndexProvider { get }

    func sectionIdentifier(at sectionIndex: Int) -> SectionIdentifierType?
    func makeSectionProvider() -> SectionProvider
    func makeCompositionalLayoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration
    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout
}

public extension DKCollectionViewCompositionalLayoutDescription {

    func sectionIdentifier(at sectionIndex: Int) -> SectionIdentifierType? {
        sectionIdentifierAtSectionIndexProvider(sectionIndex)
    }

    func makeBoundarySupplementaryItem(ofKind elementKind: BoundaryElementKind,
                                       alignment: NSRectAlignment? = nil) -> NSCollectionLayoutBoundarySupplementaryItem {

        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44.0)
        )

        if let alignment {
            return .init(layoutSize: layoutSize, elementKind: elementKind.rawValue, alignment: alignment)
        }

        switch elementKind {
        case .layoutHeader,
             .sectionHeader:
            return .init(layoutSize: layoutSize, elementKind: elementKind.rawValue, alignment: .top)

        case .layoutFooter,
             .sectionFooter,
             .separator:
            return .init(layoutSize: layoutSize, elementKind: elementKind.rawValue, alignment: .bottom)

        case .uiKitHeader,
             .uiKitFooter:
            fatalError("""
            This value should only be used when using:
                - a compositional layout that contains only list sections with `UICollectionViewCompositionalLayout.list(using:)`
                - a list section with `NSCollectionLayoutSection.list(using:layoutEnvironment:)`
            """)
        }
    }

    func makeSupplementaryItem(ofKind elementKind: String,
                               containerAnchor: NSCollectionLayoutAnchor,
                               itemAnchor: NSCollectionLayoutAnchor? = nil) -> NSCollectionLayoutSupplementaryItem {

        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44.0)
        )

        guard let itemAnchor else {
            return .init(layoutSize: layoutSize, elementKind: elementKind, containerAnchor: containerAnchor)
        }
        return .init(layoutSize: layoutSize, elementKind: elementKind, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
    }
}
