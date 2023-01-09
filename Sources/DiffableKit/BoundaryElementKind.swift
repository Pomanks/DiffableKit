//
//  BoundaryElementKind.swift
//
//
//  Created by Antoine Barré on 8/4/22.
//

import Foundation
import UIKit

///
/// The `BoundaryElementKind` enum provides a safe type for creating supplementary items and registering them using a supplementary registration (please refer to [UICollectionView.SupplementaryRegistration](https://developer.apple.com/documentation/uikit/uicollectionview/supplementaryregistration) for more information).
///
/// The following example creates a supplementary item for a custom layout header (using the helper method from ``DKCollectionViewCompositionalLayoutDescription``) and associates it with the compositional layout configuration declared inside your implementation of `makeCompositionalLayoutConfiguration()`.
///
/// ```
/// func makeCompositionalLayoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
///     let configuration = UICollectionViewCompositionalLayoutConfiguration()
///     let layoutHeader = makeBoundarySupplementaryItem(ofKind: .layoutHeader)
///
///     configuration.boundarySupplementaryItems = [layoutHeader]
///
///     // configure additional properties…
///
///     return configuration
/// }
/// ```
///
/// After you create a supplementary item, you need provide its registration which you call from your layout descriptor's `makeSupplementaryViewProvider()`.
/// Thanks to the enum, it's even easier to declare the custom registration in a type-safe way.
///
/// ```
/// func layoutHeaderRegistration(ofKind elementKind: BoundaryElementKind) -> UICollectionView.SupplementaryRegistration<LayoutHeader> {
///     .init(elementKind: elementKind.rawValue) { supplementaryView, string, indexPath in
///         // configure your supplementary view
///     }
/// }
/// ```
///
/// Within your implementation of `makeSupplementaryViewProvider()`, you can retrieve the `BoundaryElementKind` case associated to the rawValue `elementKind` like in the following example.
///
/// ```
/// func makeSupplementaryViewProvider() -> SupplementaryViewProvider? {
///     let layoutHeaderRegistration = layoutHeaderRegistration(ofKind: .layoutHeader)
///
///     return { collectionView, elementKind, indexPath in
///         let kind = BoundaryElementKind(rawValue: elementKind)
///
///         switch kind {
///         case .layoutHeader:
///             return collectionView.dequeueConfiguredReusableSupplementary(using: layoutHeaderRegistration, for: indexPath)
///
///         default:
///             return nil
///         }
///     }
/// }
/// ```
/// - Note: If you need to provide additional supplementary items that don't match the default covered cases, you will need to handle them separately.
///
public enum BoundaryElementKind: String {
    // Global Header/Footer
    case layoutHeader
    case layoutFooter

    // Section Header/Footer
    case sectionHeader
    case sectionFooter

    // Custom Separator item
    case separator

    case uiKitHeader
    case uiKitFooter

    public var rawValue: String {
        switch self {
        case .layoutHeader:
            return "layout-header-element-kind"

        case .layoutFooter:
            return "layout-footer-element-kind"

        case .sectionHeader:
            return "section-header-element-kind"

        case .sectionFooter:
            return "section-footer-element-kind"

        case .separator:
            return "separator-element-kind"

        case .uiKitHeader:
            return UICollectionView.elementKindSectionHeader

        case .uiKitFooter:
            return UICollectionView.elementKindSectionFooter
        }
    }

    public init?(rawValue: String) {
        switch rawValue {
        case "layout-header-element-kind":
            self = .layoutHeader

        case "layout-footer-element-kind":
            self = .layoutFooter

        case "section-header-element-kind":
            self = .sectionHeader

        case "section-footer-element-kind":
            self = .sectionFooter

        case "separator-element-kind":
            self = .separator

        case UICollectionView.elementKindSectionHeader:
            self = .uiKitHeader

        case UICollectionView.elementKindSectionFooter:
            self = .uiKitFooter

        default:
            return nil
        }
    }
}
