import SwiftUI

struct CharacterDetailView: View {

    @StateObject var viewModel: CharacterDetailViewModel

    var body: some View {

        VStack(spacing: Const.CharacterDetailView.fieldsVerticalSpacing) {

            Text(viewModel.name)
                .font(Const.CharacterDetailView.titleFont)
                .foregroundColor(.primary)

            Group {
                if let avatar = viewModel.avatar {

                    Image(uiImage: avatar)
                        .interpolation(.medium)
                        .cornerRadius(Const.CharacterDetailView.avatarCornerRadius)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
                    
                } else {

                    ProgressView()
                }
            }
            .padding(.vertical, Const.CharacterDetailView.avatarVerticalPadding)

            HStack {

                Text("Status")
                    .font(Const.CharacterDetailView.fieldTitleFont)
                    .foregroundColor(.primary)

                Spacer()

                Text(viewModel.status)
                    .font(Const.CharacterDetailView.fieldValueFont)
                    .foregroundColor(.primary)
            }

            HStack {

                Text("Species")
                    .font(Const.CharacterDetailView.fieldTitleFont)
                    .foregroundColor(.primary)

                Spacer()

                Text(viewModel.species)
                    .font(Const.CharacterDetailView.fieldValueFont)
                    .foregroundColor(.primary)
            }

            HStack {

                Text("Gender")
                    .font(Const.CharacterDetailView.fieldTitleFont)
                    .foregroundColor(.primary)

                Spacer()

                Text(viewModel.gender)
                    .font(Const.CharacterDetailView.fieldValueFont)
                    .foregroundColor(.primary)
            }

            HStack {

                Text("Current location")
                    .font(Const.CharacterDetailView.fieldTitleFont)
                    .foregroundColor(.primary)

                Spacer()

                Text(viewModel.currentLocation)
                    .font(Const.CharacterDetailView.fieldValueFont)
                    .foregroundColor(.primary)
            }


            Spacer()
        }
        .frame(width: Const.CharacterDetailView.fieldsWidth)
        .padding()
        .task {

            await viewModel.loadAvatar()
        }
    }
}
