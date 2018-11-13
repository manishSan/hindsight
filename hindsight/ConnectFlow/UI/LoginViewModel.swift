//
//  LoginViewModel.swift
//  hindsight
//
//  Created by Sanwal, Manish on 11/6/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import Foundation
import Swinject

typealias VoidClosure = () -> Void

protocol LoginViewModelProtocol {
    var container: Container {get}
    func connectFacebook()
}

struct LoginViewModel: LoginViewModelProtocol {

    let container: Container

    let facebookConnectClosure: VoidClosure

    func connectFacebook() {
        facebookConnectClosure()
    }
}
