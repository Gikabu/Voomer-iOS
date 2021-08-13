// Copyright © 2021 Metabolist. All rights reserved.

import Foundation
import Alamofire
import SwiftyJSON

struct AuthClient {
    private let prefs = AuthClientPreferences()
    
    static let endpoint = "https://auth.voomer.co.ke/api/v1/"
    
    private var requestEmailOTP: String {
        return Self.endpoint + "email/otp"
    }
    
    private var verifyEmailOTP: String {
        return Self.endpoint + "verify/otp"
    }
    
    func requestEmailValidation(email: String, onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        prefs.setUnconfirmedEmail(email: email)
        
        let params: Parameters = [
            "email": email,
            "type": "2FA"
        ]
        
        AF.request(requestEmailOTP, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let valueDict = value as? [String:String], let verificationKey = valueDict["details"] {
                        self.prefs.setVerificationKey(value: verificationKey)
                        onSuccess()
                    } else {
                        onFailure()
                    }
                case let .failure(error):
                    print("requestEmailOTP failed: \(error)")
                    onFailure()
                }
        }
    }
    
    func validateOTP(otp: String, onSuccess: @escaping (ValidateOTPResponse) -> Void, onFailure: @escaping () -> Void) {
        let params: Parameters = [
            "otp": otp,
            "verification_key": prefs.getVerificationKey(),
            "check": prefs.getUnconfirmedEmail()
        ]
        
        AF.request(verifyEmailOTP, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let valueJson = JSON(value)
                    let validateResponse = ValidateOTPResponse(json: valueJson)
                    onSuccess(validateResponse)
                case let .failure(error):
                    print("validateOTP failed: \(error)")
                    onFailure()
                }
        }
    }
}

struct ValidateOTPResponse {
    var action: PostValidationAction
    var authKey: String
    var email: String
    
    init(json: JSON) {
        action = PostValidationAction(rawValue: json["data"]["type"].intValue) ?? .none
        authKey = json["data"]["authKey"].stringValue
        email = AuthClientPreferences().getUnconfirmedEmail()
    }
}

enum PostValidationAction: Int {
    case register = 0
    case login = 1
    case none = -1
}

fileprivate struct AuthClientPreferences {
    private let authDefaults = UserDefaults(suiteName: "AuthClientPreferences")
    
    func setUnconfirmedEmail(email: String) {
        authDefaults?.set(email, forKey: "AuthClientPreferences_Email")
    }
    
    func getUnconfirmedEmail() -> String {
        authDefaults?.string(forKey: "AuthClientPreferences_Email") ?? ""
    }
    
    func setVerificationKey(value: String) {
        authDefaults?.set(value, forKey: "AuthClientPreferences_VerificationKey")
    }
    
    func getVerificationKey() -> String {
        authDefaults?.string(forKey: "AuthClientPreferences_VerificationKey") ?? ""
    }
    
    func reset() {
        DispatchQueue.main.async {
            authDefaults?.removeSuite(named: "AuthClientPreferences_Email")
            authDefaults?.removeSuite(named: "AuthClientPreferences_VerificationKey")
        }
    }
}

