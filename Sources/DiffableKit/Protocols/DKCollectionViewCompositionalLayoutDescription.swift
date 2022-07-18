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

    var sectionIdentifierAtSectionIndexProvider: SectionIdentifierAtSectionIndexProvider? { get }

    init(sectionIdentifierAtSectionIndexProvider: SectionIdentifierAtSectionIndexProvider?)

    func sectionIdentifier(at sectionIndex: Int) -> SectionIdentifierType?
    func makeSectionProvider() -> SectionProvider
    func makeCompositionalLayoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration
    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout
}

public extension DKCollectionViewCompositionalLayoutDescription {

    func sectionIdentifier(at sectionIndex: Int) -> SectionIdentifierType? {
        sectionIdentifierAtSectionIndexProvider?(sectionIndex)
    }
}
