import SwiftUI

struct CharacterCellView: View {

    let viewModel: CharacterCellViewModel

    var body: some View {
        
        Text(viewModel.name)
    }
}
