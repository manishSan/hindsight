//
//  LoginButton.swift
//  hindsight
//
//  Created by Wei-Ting Lin on 11/12/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginButtonStateProtocol {
    /// The `Variable` represents the button text in the current state
    var text: String? {get}
    /// The `UIColor` represents the button textColor in the current state
    var textColor: UIColor? {get}
    /// The `UIColor` represents the button backgroundColor in the current state
    var backgroundColor: UIColor? {get}
    /// The `UIImage` represents the button image in the current state
    var image: UIImage? {get}
}

struct LoginButtonState: LoginButtonStateProtocol {
    /// The `Variable` represents the button text in the current state
    var text: String?
    /// The `UIColor` represents the button textColor in the current state
    var textColor: UIColor?
    /// The `UIColor` represents the button backgroundColor in the current state
    var backgroundColor: UIColor?
    /// The `UIImage` represents the button image in the current state
    var image: UIImage?
    /// The `Function` to construct the struct
    init(text: String? = nil, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, image: UIImage? = nil) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.image = image
    }
}

protocol LoginButtonProtocol {
    /// The `LoginButtonStateProtocol` represents button in normal state
    var normalState: LoginButtonStateProtocol {get}
    /// The `LoginButtonStateProtocol` represents button in highlight state
    var highlightState: LoginButtonStateProtocol? {get}
    /// The `Closure` delegates the button tapped action
    var didSelectClosure: () -> Void {get}
}

struct LoginButtonViewModel: LoginButtonProtocol {
    /// The `LoginButtonStateProtocol` represents button normal state
    var normalState: LoginButtonStateProtocol
    /// The `LoginButtonStateProtocol` represents button highlight state
    var highlightState: LoginButtonStateProtocol?
    /// The `Closure` delegates the button tapped action
    var didSelectClosure: () -> Void
}

/// This UIView is created to match the design and can be reused in the future
/// - Ex: Google Login, Instagram Login
class HindsightLoginButton: UIView {

    var viewModel: LoginButtonProtocol

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: LoginButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpUI()
        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleLongPressGestureRecognizer(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            update(to: viewModel.highlightState ?? viewModel.normalState)
        case .cancelled:
            update(to: viewModel.normalState)
        case .ended:
            update(to: viewModel.normalState)
            viewModel.didSelectClosure()
        default:
            break
        }
    }

    func update(to state: LoginButtonStateProtocol) {
        backgroundColor = state.backgroundColor ?? viewModel.normalState.backgroundColor
        titleLabel.textColor = state.textColor ?? viewModel.normalState.textColor
        titleLabel.text = state.text ?? viewModel.normalState.text
        imageView.image = state.image ?? viewModel.normalState.image
    }

    func setUpUI() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(self.handleLongPressGestureRecognizer))
        longPressGestureRecognizer.minimumPressDuration = 0
        addSubview(titleLabel)
        addSubview(imageView)
        addGestureRecognizer(longPressGestureRecognizer)
        update(to: viewModel.normalState)
        layer.cornerRadius = 5
        isUserInteractionEnabled = true
        clipsToBounds = true
    }

    func setUpConstraints() {
        let margin = 10
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(margin)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(imageView.snp.height)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(margin)
            make.trailing.equalTo(self.snp.trailing).offset(-margin)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
