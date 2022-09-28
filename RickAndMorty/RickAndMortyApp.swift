import SwiftUI

@main
struct RickAndMortyApp: App {

    var body: some Scene {

        WindowGroup {

            ContentView()
        }
    }

    init() {

        suppressUnsatisfiableConstrantsWarning()
        removeAllCachedResponses()
    }

    func suppressUnsatisfiableConstrantsWarning() {
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    func removeAllCachedResponses() {

        URLCache.shared.removeAllCachedResponses()
    }
}
