//
//  SettingViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import Foundation

final class SettingViewModel {
    var sections: [SettingSection] {
        return SettingSection.allCases
    }
}
