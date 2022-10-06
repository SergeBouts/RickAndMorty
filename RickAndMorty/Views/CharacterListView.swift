import SwiftUI

struct CharacterListView: View {

    @StateObject var viewModel: CharacterListViewModel
    @State private var showingCharacterDetailsScreen: CharacterModel?
    @Environment(\.dismiss) var dismiss

    var body: some View {

        let err = Binding.constant($viewModel.error.wrappedValue ?? nil)

        NavigationView {
            List {
                ForEach(viewModel.characters) { character in

                    Button {
                        showingCharacterDetailsScreen = character
                    } label: {
                        viewModel.cellViewForCharacter(character)
                    }
                    .task {
                        await viewModel.loadMoreCharactersIfNeeded(currentCharacter: character)
                    }
                }
                if viewModel.isLoading {
                    
                    ProgressView()
                }
            }
            .navigationBarTitle("Rick & Morty")
        }
        .searchable(
            text: $viewModel.searchFilter,
            placement: .automatic
        )
        .task {
            await viewModel.load()
        }
        .sheet(item: $showingCharacterDetailsScreen) { character in
            viewModel.detailViewForCharacter(character)
        }
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(2)
                        .allowsHitTesting(false)
                }
            }
        )
        .alert(isPresented: Binding.constant(err.wrappedValue != nil), content: {
            let error = err.wrappedValue!
            return Alert(
                title: Text("Error!"),
                message: Text(error.asString),
                dismissButton: .default(Text("OK"), action: {
                    dismiss()
                }))
        })
    }
}
