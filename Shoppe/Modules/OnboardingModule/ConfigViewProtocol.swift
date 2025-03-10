//
//  ConfigViewProtocol.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 10.03.2025.
//

import Foundation

protocol ConfigViewProtocol {
    associatedtype ConfigModel
    func configure(with model: ConfigModel)
}
