import Foundation

final class RickAndMortyAppDependencyContainer {

    // MARK: - Properties

    // Long-lived dependencies
    let rickAndMortyRemoteRepository: RickAndMortyRemoteRepository

    init() {

        func makeRickAndMortyRemoteRepository() -> RickAndMortyRemoteRepository {

            let remoteAPI = RickAndMortyRemoteAPIAdapter()
            return RickAndMortyRemoteAPIRepository(remoteAPI: remoteAPI)
        }

        self.rickAndMortyRemoteRepository = makeRickAndMortyRemoteRepository()
    }
}
