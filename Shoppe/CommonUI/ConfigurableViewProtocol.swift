//
//  ConfigurableViewProtocol.swift
//  Shoppe
//
//  Created by Николай Игнатов on 05.03.2025.
//

protocol ConfigurableViewProtocol {
    associatedtype ConfigurableModel
    func configure(with model: ConfigurableModel)
}
