import SwiftUI

@main
struct RickAndMortyApp: App {

    @State var injectionContainer = RickAndMortyAppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
