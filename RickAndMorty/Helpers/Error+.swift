import Foundation

extension Error {

    var asString: String {

        if let error = self as? RepositoryError,
           case RepositoryError.rickAndMortyRepoError(let repoError) = error  {
            return repoError.localizedDescription
        } else {
            return self.localizedDescription
        }
    }
}
