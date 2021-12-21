//
//  LocalDataPrivateImpl.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import KeychainSwift

protocol LocalDataPrivate: AnyObject{
	func saveDateUser(clientId:String, clientSecret:String, refreshToken:String)  -> Bool
	func saveTokens(accessToken:String, refreshToken:String) -> Bool
	func getRefreshToken() -> String?
	func getAccessToken() -> String?
	func getClientId() -> String?
	func getClientSecret() -> String?
	func clearData()
	func sanitizingSession()
}

final class LocalDataPrivateImpl{
	
	enum LocalDataPrivateKey: String {
		case access_token, refresh_token, client_id, client_secret
	}
	
	let keychain = KeychainSwift()
	
	private func get(key:LocalDataPrivateKey) ->Data?{
		if let value = keychain.getData(key.rawValue) {
			return value
		}
		return nil
	}
	
	private func get(key:LocalDataPrivateKey) ->String?{
		if let value = keychain.get(key.rawValue) {
			return value
		}
		return nil
	}
	
	private func set(_ value:String, key:LocalDataPrivateKey)-> Bool{
		return keychain.set(value, forKey: key.rawValue, withAccess:.accessibleAfterFirstUnlock)
	}
	
	private func set(_ value:Data, key:LocalDataPrivateKey)-> Bool{
		return keychain.set(value, forKey: key.rawValue, withAccess:.accessibleAfterFirstUnlock)
	}
}

extension LocalDataPrivateImpl: LocalDataPrivate{
	
	func saveDateUser(clientId: String, clientSecret: String, refreshToken: String) -> Bool {
		return set(clientId, key: .client_id) && set(clientSecret, key: .client_secret)
		&& set(refreshToken, key: .refresh_token)
	}
	
	func saveTokens(accessToken: String, refreshToken: String) -> Bool {
		return set(accessToken, key: .access_token) && set(refreshToken, key: .refresh_token)
	}
	
	func getRefreshToken() -> String? {
		get(key: .refresh_token)
	}
	
	func getAccessToken() -> String? {
		get(key: .access_token)
	}
	
	func getClientId() -> String? {
		get(key: .client_id)
	}
	
	func getClientSecret() -> String? {
		get(key: .client_secret)
	}
	
	func clearData() {
		keychain.clear()
	}
	
	func sanitizingSession() {
		if !UserDefaults.standard.appFirstTimeLaunch{
			
			clearData()
			UserDefaults.standard.appFirstTimeLaunch = true
			
			let credentials = PlistHelper.readPlist()
			_ = saveDateUser(clientId: credentials.clientId, clientSecret: credentials.clientSecret, refreshToken: credentials.refreshToken)
		}
	}
}

extension UserDefaults {
	
	enum UserDefaultsKey: String {
		case appFirstTimeLaunch
	}
	
	// MARK: - Utility
	
	func setValue(_ value: Any?, forKey key: UserDefaultsKey) {
		setValue(value, forKey: key.rawValue)
	}
	
	func value(forKey key: UserDefaultsKey) -> Any? {
		return value(forKey: key.rawValue)
	}
	
	var appFirstTimeLaunch : Bool {
		get {
			return (value(forKey: .appFirstTimeLaunch) as? Bool) ?? false
		}
		set(newVal) {
			setValue(newVal, forKey: .appFirstTimeLaunch)
		}
	}
}
