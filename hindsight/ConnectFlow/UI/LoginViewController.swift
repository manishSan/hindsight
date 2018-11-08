//
//  LoginViewController.swift
//  hindsight
//
//  Created by Sanwal, Manish on 11/5/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    lazy var facebookConnect: UIButton = {
        let button = UIButton()
        button.setTitle("Connect With Facebook", for: .normal)
        button.backgroundColor = ColorName.hindsightBlue.color
        return button
    }()

    let viewModel: LoginViewModelProtocol

    let disposeBag = DisposeBag()

    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        view.addSubview(facebookConnect)
    }

    func bindViews() {
        facebookConnect.rx.tap.bind { [unowned self] in
            self.viewModel.connectFacebook()
        }.disposed(by: disposeBag)
    }

    func setupConstraints() {
        let margin = 20
        let buttonHeight = 50
        facebookConnect.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(margin)
            make.trailing.equalTo(view.snp.trailing).offset(-margin)
            make.bottom.equalTo(view.snp.bottom).offset(-margin)
            make.height.equalTo(buttonHeight)
        }
    }
}
