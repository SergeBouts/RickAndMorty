import SwiftUI

struct ContentView: View {

    // Leverage State's reference-based storage under the hood to achieve a long-lived dependency:
    @State var injectionContainer = RickAndMortyAppDependencyContainer()

    var body: some View {

        CharacterListView(viewModel: injectionContainer.makeCharacterListViewModel())
    }
}
