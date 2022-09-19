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
    }

    func suppressUnsatisfiableConstrantsWarning() {
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}
