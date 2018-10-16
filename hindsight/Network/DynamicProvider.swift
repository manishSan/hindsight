//
//  DynamicProvider.swift
//  hindsight
//
//  Created by Sanwal, Manish on 10/16/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import Foundation
import Moya

/// The dynamic base URL provider
struct DynamicBaseURLProvider: TargetType {
    let baseURL: URL

    let target: TargetType

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
