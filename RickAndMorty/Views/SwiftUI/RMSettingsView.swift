//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by User on 16/04/2025.
//

import SwiftUI


struct RMSettingsView: View {
    @StateObject private var viewModel = RMSettingViewModel()
    var onTap:(RMSettingsOption) -> Void = { _ in}
    var body: some View {
        NavigationView {
            List(viewModel.settingsOptions, id: \.self) { option in
                HStack(spacing: 16) {
                    if let image = option.iconImage {
                        Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(8)
                            .background(Color(option.iconContainerColor))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text(option.displayTitle)
                        .foregroundColor(.primary)

                    Spacer()
                }
                .padding(.vertical, 4)
                .onTapGesture {
                    onTap(option)
                }
            }
            //.navigationTitle("Settings")
        }
    }
}


#Preview {
    RMSettingsView{option in
        print("Tapped: \(option.displayTitle)")
    }
}
