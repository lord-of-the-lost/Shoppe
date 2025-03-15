//
//  LocationPresenterProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/15/25.
//


import UIKit
import PhotosUI

protocol LocationPresenterProtocol: AnyObject {
    func setupView(_ view: LocationViewProtocol)
}

// MARK: - Presenter
final class LocationPresenter: LocationPresenterProtocol {
    private weak var view: LocationViewProtocol?
    private let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: LocationViewProtocol) {
        self.view = view
    }
}

private extension LocationPresenter {
    
}
