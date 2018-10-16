//
//  UserEndpoint.swift
//  hindsight
//
//  Created by manish on 10/14/18.
//  Copyright © 2018 hindsight-inc. All rights reserved.
//

import Foundation
import Moya

struct DynamicProvider: TargetType {
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


enum AuthService {
    case register(userName: String, password: String)
    case login(userName: String, password: String)
    case refresh(
}

extension AuthService: TargetType {
    var baseURL: URL {
        return "http://localhost:8080/"
    }
    
    var path: String {
        ""
    }
    
    var method: Moya.Method {
        <#code#>
    }
    
    var sampleData: Data {
        <#code#>
    }
    
    var task: Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
