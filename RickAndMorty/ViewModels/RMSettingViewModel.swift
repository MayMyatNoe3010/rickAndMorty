//
//  RMSettingViewModel.swift
//  RickAndMorty
//
//  Created by User on 16/04/2025.
//

import Foundation
import Combine
class RMSettingViewModel : ObservableObject{
    @Published var settingsOptions: [RMSettingsOption] = RMSettingsOption.allCases
}
