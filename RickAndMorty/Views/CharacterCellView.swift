import SwiftUI

struct CharacterCellView: View {

    @StateObject var viewModel: CharacterCellViewModel

    var body: some View {

        HStack {

            Group {
                if let thumb = viewModel.avatarThumb {

                    Image(uiImage: thumb)
                        .interpolation(.medium)
                        .cornerRadius(Const.CharacterListView.avatarThumbCornerRadius)
                } else {

                    ProgressView()
                }
            }
            .frame(
                width: Const.CharacterListView.thumbSize.width,
                height: Const.CharacterListView.thumbSize.height
            )

            VStack(alignment: .leading) {

                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(viewModel.episodesCount) episode\(viewModel.episodesCount == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .task {

            await viewModel.loadAvatarThumb()
        }
    }
}
