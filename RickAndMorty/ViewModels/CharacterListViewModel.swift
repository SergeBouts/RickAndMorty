import Foundation

final class CharacterListViewModel: ObservableObject {

    // MARK: - Properties

    let rickAndMortyRemoteRepository: RickAndMortyRemoteRepository

    let cellViewForCharacter: (CharacterModel) -> CharacterCellView
    let detailViewForCharacter: (CharacterModel) -> CharacterDetailView

    @Published @MainActor var characters: [CharacterModel] = []

    // MARK: - Initialization

    init(
        rickAndMortyRemoteRepository: RickAndMortyRemoteRepository,
        cellViewForCharacter: @escaping (CharacterModel) -> CharacterCellView,
        detailViewForCharacter: @escaping (CharacterModel) -> CharacterDetailView
    ) {

        self.rickAndMortyRemoteRepository = rickAndMortyRemoteRepository
        self.cellViewForCharacter = cellViewForCharacter
        self.detailViewForCharacter = detailViewForCharacter
    }

    // MARK: - API

    func load() async {

        let characters = try! await rickAndMortyRemoteRepository.characters()
        await MainActor.run {
            self.characters = characters
        }
    }
}
