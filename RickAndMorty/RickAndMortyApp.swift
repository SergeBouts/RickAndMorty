import SwiftUI

@main
struct RickAndMortyApp: App {

    var body: some Scene {

        WindowGroup {

            ContentView()
        }
    }

    init() {

        suppressUnsatisviableConstrantsWarning()
    }

    func suppressUnsatisviableConstrantsWarning() {
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}
