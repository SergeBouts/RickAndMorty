import Foundation
import SwiftUI

enum Const {

    enum CharacterListView {

        static let isAnimated: Bool = true // Actually, the animation is weird, perhaps it's better disabled...

        static let thumbSize: CGSize = CGSize(width: 100, height: 100)

        static let avatarThumbCornerRadius: CGFloat = 5
    }

    enum CharacterDetailView {

        static let titleFont: Font = .largeTitle

        static let fieldTitleFont: Font = .headline
        static let fieldValueFont: Font = .subheadline

        static let fieldsVerticalSpacing: CGFloat = 15
        static let fieldsWidth: CGFloat = 300

        static let avatarVerticalPadding: CGFloat = 20
        static let avatarCornerRadius: CGFloat = 5
    }
}
