import SwiftUI

struct CharacterDetailView: View {

    let viewModel: CharacterDetailViewModel

    var body: some View {

        Text(viewModel.name)
    }
}
