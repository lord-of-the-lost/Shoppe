//
//  SearchBarView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func placeholderTapped()
    func showProducts(_ query: String)
    func clearSearchTapped()
}

extension SearchViewDelegate {
    func placeholderTapped() {}
    func showProducts(_ query: String) {}
    func clearSearchTapped() {}
}

final class SearchView: UIView {
    weak var delegate: SearchViewDelegate?
    private var state: SearchState = .placeholder
    
    enum SearchState {
        case placeholder
        case active
        case searchResult(String)
    }
    
    private lazy var searchField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Search"
        textField.font = Fonts.ralewayMedium16
        textField.textColor = .customBlack
        textField.backgroundColor = .customLightGray
        textField.layer.cornerRadius = 18
        textField.delegate = self
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var searchResultView: SearchTextView = {
        let view = SearchTextView()
        view.delegate = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        updateState()
        setupGestures()
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchState(_ state: SearchState) {
        self.state = state
        updateState()
    }
}

// MARK: - UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            delegate?.showProducts(text)
            setSearchState(.searchResult(text))
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - SearchTextViewDelegate
extension SearchView: SearchTextViewDelegate {
    func didTapCross() {
        delegate?.clearSearchTapped()
        setSearchState(.active)
    }
}

// MARK: - Private Methods
private extension SearchView {
    func setupView() {
        addSubview(searchField)
        addSubview(searchResultView)
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: topAnchor),
            searchField.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchResultView.topAnchor.constraint(equalTo: topAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchResultView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func updateState() {
        switch state {
        case .placeholder:
            searchField.isUserInteractionEnabled = false
            searchField.backgroundColor = UIColor.customLightGray
            searchField.text = nil
            searchField.layer.borderWidth = 0
            searchResultView.isHidden = true
            
        case .active:
            searchField.isUserInteractionEnabled = true
            searchField.backgroundColor = .white
            searchField.placeholder = ""
            searchField.layer.borderColor = UIColor.customLightGray.cgColor
            searchField.layer.borderWidth = 1
            searchResultView.isHidden = true
            
        case .searchResult(let text):
            searchField.isUserInteractionEnabled = false
            searchField.backgroundColor = UIColor.customLightGray
            searchField.layer.borderWidth = 0
            searchField.placeholder = ""
            searchField.text = ""
            searchResultView.isHidden = false
            searchResultView.setSearchText(text)
        }
    }
    
    @objc func handleTap() {
        guard case .placeholder = state else { return }
        delegate?.placeholderTapped()
    }
}

