//
//  UserRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

struct NewPasswordContainer {
    var oldPassword: String
    var newPassword: String
    var repeatPassword: String
    
    var validPasswordContainer: Bool {
        if oldPassword.isEmpty { return false }
        if newPassword.isEmpty { return false }
        if repeatPassword.isEmpty { return false }
        return true
    }
}

enum UserRequest {
    case registerUser(phone: String, password: String, passwordConfirm: String, smsCode: String)
    case validateUser(phone: String, password: String, passwordConfirm: String)
    
    case getUser(token: String)
    case updateUserInfo(token: String, userInfo: UserInfo?, passwordInfo: NewPasswordContainer?)
    case changePassword(token: String, oldPassword: String, newPassword: String, newPasswordConfirm: String)
    
    case passwordRestore(phone: String, password: String, passwordConfirm: String, smsCode: String)
    case sendSms(phone: String)
    
    case logIn(phone: String, password: String)
    case updateToken(token: String)
    case logOut(token: String)
}

// MARK: - TargetType Protocol Implementation
extension UserRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .registerUser: return "/api/user"
        case .validateUser: return "/api/user/validate"
            
        case .getUser: return "/api/user"
        case .updateUserInfo: return "/api/user"
        case .changePassword: return "/api/user"
        
        case .passwordRestore: return "/api/user/restore-password"
        case .sendSms: return "/sms/send-code"
        
        case .logIn: return "/api/auth/login"
        case .updateToken: return "/api/auth/refresh-token"
        case .logOut: return "/api/auth/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
            
        case .sendSms,
             .validateUser,
             .registerUser,
             .logOut,
             .logIn,
             .updateToken,
             .passwordRestore:
            return .post
            
        case .updateUserInfo, .changePassword:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getUser, .logOut, .updateToken:
            return .requestPlain
            
        case let .registerUser(phone, password, passwordConfirm, smsCode):
            return .requestParameters(
                parameters: [
                    "phone": phone,
                    "password": password,
                    "password_confirmation": passwordConfirm,
                    "sms_code": smsCode
                ],
                encoding: JSONEncoding.default)
            
        case let .validateUser(phone, password, passwordConfirm):
            return .requestParameters(
                parameters: [
                    "phone": phone,
                    "password": password,
                    "password_confirmation": passwordConfirm
                    ],
                encoding: JSONEncoding.default)
            
        case let .sendSms(phone):
            return .requestParameters(
                parameters: ["phone": phone],
                encoding: JSONEncoding.default)
            
        case let .logIn(phone, password):
            return .requestParameters(
                parameters: ["phone": phone, "password": password],
                encoding: JSONEncoding.default)
            
        case let .passwordRestore(phone, password, passwordConfirm, smsCode):
            return .requestParameters(
                parameters: [
                    "phone": phone,
                    "password": password,
                    "password_confirmation": passwordConfirm,
                    "sms_code": smsCode
                ],
            encoding: JSONEncoding.default)
            
        case let .updateUserInfo(_, userInfo, passwordInfo):
            var dictionary: [String: Any] = [:]
            
            if let userInfo = userInfo {
                dictionary["firstname"] = userInfo.firstName ?? ""
                dictionary["surname"] = userInfo.middleName ?? ""
                dictionary["lastname"] = userInfo.lastName ?? ""
                dictionary["email"] = userInfo.email ?? ""
                dictionary["is_notify"] = userInfo.receivePromo
            }
            
            if let passwordInfo = passwordInfo {
                if passwordInfo.validPasswordContainer {
                    dictionary["password"] = passwordInfo.newPassword
                    dictionary["password_confirmation"] = passwordInfo.repeatPassword
                    dictionary["old_password"] = passwordInfo.oldPassword
                }
            }
            
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.httpBody )
            
        case let .changePassword(_, oldPassword, newPassword, newPasswordConfirm):
            return .requestParameters(
                parameters: [
                    "password": newPassword,
                    "password_confirmation": newPasswordConfirm,
                    "old_password": oldPassword
                ],
                encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data { return "".toData() }
    
    var headers: [String: String]? {
        
        var header: [String: String] = ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
        
        switch self {

        case let .getUser(token):
            header["Authorization"] = token
            
        case let .updateUserInfo(token, _, _):
            header["Authorization"] = token
            
        case let .changePassword(token, _, _, _):
            header["Authorization"] = token
            
        case let .updateToken(token):
            header["Authorization"] = token
            
        case let .logOut(token):
            header["Authorization"] = token
            
        default: break
        }
        
        switch self {
        case .updateUserInfo, .changePassword:
            header["Content-Type"] = "application/x-www-form-urlencoded"
            header["X-Requested-With"] = "XMLHttpRequest"
            
        default: break
        }
        
        return header
    }
}
