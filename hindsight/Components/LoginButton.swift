//
//  LoginButton.swift
//  hindsight
//
//  Created by Wei-Ting Lin on 11/12/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol LoginButtonStateProtocol {
    /// The `Variable` represents the button text in the current state
    var text: String {get}
    /// The `UIColor` represents the button textColor in the current state
    var textColor: UIColor {get}
    /// The `UIColor` represents the button backgroundColor in the current state
    var backgroundColor: UIColor {get}
    /// The `UIImage` represents the button image in the current state
    var image: UIImage? {get}
}

struct LoginButtonState: LoginButtonStateProtocol {
    /// The `Variable` represents the button text in the current state
    let text: String
    /// The `UIColor` represents the button textColor in the current state
    let textColor: UIColor
    /// The `UIColor` represents the button backgroundColor in the current state
    let backgroundColor: UIColor
    /// The `UIImage` represents the button image in the current state
    let image: UIImage?
    /// The `Function` to construct the struct
    init(text: String, textColor: UIColor, backgroundColor: UIColor, image: UIImage?) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.image = image
    }
}

protocol LoginButtonProtocol {

    var buttonState: Variable<LoginButtonStateProtocol> { get }

    func didSelect()

    func didCancel()

    func didRelease()
}

struct LoginButtonViewModel: LoginButtonProtocol {
    
    /// The `Variable` represents a RxSwift `Observable` which will be observed for button state changes
    let buttonState: Variable<LoginButtonStateProtocol>
    /// The `LoginButtonStateProtocol` represents button normal state
    let normalState: LoginButtonStateProtocol
    /// The `LoginButtonStateProtocol` represents button highlight state
    let highlightState: LoginButtonStateProtocol?
    /// The `VoidClosure` delegates the button tapped action
    let didSelectClosure: VoidClosure

    init(normalState: LoginButtonStateProtocol,
         highlightState: LoginButtonStateProtocol?,
         didSelectClosure: @escaping VoidClosure) {
        self.normalState = normalState
        self.highlightState = highlightState
        self.didSelectClosure = didSelectClosure
        self.buttonState = Variable(normalState)
    }

    func didSelect() {
        if let hs = highlightState {
            buttonState.value = hs
        }
    }

    func didCancel() {
        buttonState.value = normalState
    }

    func didRelease() {
        buttonState.value = normalState
        didSelectClosure()
    }
}

/// This UIView is created to match the design and can be reused in the future
/// - Ex: Google Login, Instagram Login
class HindsightLoginButton: UIView {

    let viewModel: LoginButtonProtocol

    let disposeBag = DisposeBag()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    init(viewModel: LoginButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpUI()
        setUpConstraints()
        bindView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleLongPressGestureRecognizer(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.viewModel.didSelect()
        case .cancelled:
            self.viewModel.didCancel()
        case .ended:
            self.viewModel.didRelease()
        default:
            break
        }
    }

    func bindView() {
        viewModel
            .buttonState
            .asDriver()
            .drive(onNext: { [unowned self] state in
            self.update(to: state)
        })
            .disposed(by: disposeBag)
    }

    func update(to state: LoginButtonStateProtocol) {
        backgroundColor = state.backgroundColor
        titleLabel.textColor = state.textColor
        titleLabel.text = state.text
        imageView.image = state.image
    }

    func setUpUI() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(self.handleLongPressGestureRecognizer))
        longPressGestureRecognizer.minimumPressDuration = 0
        addSubview(titleLabel)
        addSubview(imageView)
        addGestureRecognizer(longPressGestureRecognizer)
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
