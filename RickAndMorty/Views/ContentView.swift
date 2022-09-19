import SwiftUI

struct ContentView: View {

    @State var injectionContainer = RickAndMortyAppDependencyContainer()

    var body: some View {

        CharacterListView(viewModel: injectionContainer.makeCharacterListViewModel())
    }
}
