//
//  DynamicProvider.swift
//  hindsight
//
//  Created by Sanwal, Manish on 10/16/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import Foundation
import Moya
import RxSwift

/// The dynamic base URL provider
struct DynamicTarget: TargetType {
    let baseURL: URL

    let target: TargetType

    init(baseURL: URL, target: TargetType) {
        self.baseURL = baseURL
        self.target = target
    }

    var path: String {
        return target.path
    }

    var method: Moya.Method {
        return target.method
    }

    var sampleData: Data {
        return target.sampleData
    }

    var task: Task {
        return target.task
    }

    var headers: [String : String]? {
        return target.headers
    }
}

class DynamicProvider: MoyaProvider<DynamicTarget> {
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

extension Reactive where Base: DynamicProvider {
    func request(_ token: TargetType, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        let dynamicTarget = DynamicTarget(baseURL: base.baseURL, target: token)
        let provider = MoyaProvider<DynamicTarget>()
        return provider.rx.request(dynamicTarget, callbackQueue: callbackQueue)
    }

    func requestWithProgress(_ token: TargetType, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        let dynamicTarget = DynamicTarget(baseURL: base.baseURL, target: token)
        let provider = MoyaProvider<DynamicTarget>()
        return provider.rx.requestWithProgress(dynamicTarget, callbackQueue: callbackQueue)
    }
}




