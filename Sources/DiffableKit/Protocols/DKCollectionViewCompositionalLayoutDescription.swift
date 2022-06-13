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
    associatedtype SectionLayoutKind

    typealias SectionProvider = UICollectionViewCompositionalLayoutSectionProvider

    func makeSectionProvider() -> SectionProvider
    func makeCompositionalLayoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration
    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout
}
