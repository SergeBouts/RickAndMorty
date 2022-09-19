import SwiftUI

struct CharacterListView: View {

    @ObservedObject var viewModel: CharacterListViewModel
    @State private var showingCharacterDetailsScreen: CharacterModel?

    var body: some View {
        
        List(viewModel.characters) { character in

            Button {
                showingCharacterDetailsScreen = character
            } label: {
                viewModel.cellViewForCharacter(character)
            }
        }
        .task {
            await viewModel.load()
        }
        .sheet(item: $showingCharacterDetailsScreen) { character in
            viewModel.detailViewForCharacter(character)
        }
    }
}
