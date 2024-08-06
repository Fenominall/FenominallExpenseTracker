//
//  ColorSelectionViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 16.06.2024.
//

import Foundation

final class ColorSelectionViewModel {    
    var onColorSelected: ((String) -> Void)?
    var selectedColor: String?
    
    func selectColor(_ color: String) {
        selectedColor = color
        onColorSelected?(color)
    }
}
