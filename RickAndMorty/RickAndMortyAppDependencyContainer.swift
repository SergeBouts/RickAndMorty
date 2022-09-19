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

    // MARK: - API

    func makeCharacterListViewModel() -> CharacterListViewModel {

        CharacterListViewModel(
            rickAndMortyRemoteRepository: rickAndMortyRemoteRepository,
            cellViewForCharacter: { [unowned self] in
                CharacterCellView(viewModel: self.makeCharacterCellViewModel(for: $0))
            },
            detailViewForCharacter: { [unowned self] in
                CharacterDetailView(viewModel: self.makeCharacterDetailViewModel(for: $0))
            }
        )
    }

    func makeCharacterCellViewModel(for character: CharacterModel) -> CharacterCellViewModel {

        CharacterCellViewModel(characterModel: character, avatarThumbLoader: { [unowned self] in
            
            try? await self.rickAndMortyRemoteRepository.avatarImageThumb(at: character.image)
        })
    }

    func makeCharacterDetailViewModel(for character: CharacterModel) -> CharacterDetailViewModel {

        CharacterDetailViewModel(characterModel: character, avatarLoader: { [unowned self] in

            try? await self.rickAndMortyRemoteRepository.avatarImage(at: character.image)
        })
    }
}
