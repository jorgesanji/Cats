//
//  Repository.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift

let unknown_error:String = "Unknown error"
let network_error:String = "Network error"
let deflocalError = NQError(statusCode: -1, code: -1, message: unknown_error)
let networkError = NQError(statusCode: HttpCodes.HTTP_INTERNET_ERROR.rawValue, code: HttpCodes.HTTP_INTERNET_ERROR.rawValue, message: network_error)

protocol Repository : AnyObject{
	
	func initSession() -> Observable<Void>?
	
	func getCredentials() -> Observable<Credentials>?
	
	func getImages(page : Int) -> Observable<DataResponse>?
}

struct NQError : Error{
	
	var statusCode:Int?
	var code:Int?
	var message:String?
	
	init(statusCode:Int? = -1, code:Int? = -1, message:String? = unknown_error) {
		self.statusCode =  statusCode
		self.code =  code
		self.message =  message
	}
}

extension Repository{
	
	func initSession() -> Observable<Void>?{
		return Observable.error(deflocalError)
	}
	
	func getCredentials() -> Observable<Credentials>?{
		return Observable.error(deflocalError)
	}
	
	func getImages(page: Int) -> Observable<DataResponse>? {
		return Observable.error(deflocalError)
	}
}

protocol LocalRepositoryService: Repository {}

protocol MockRepositoryService: Repository {}

protocol RestRepositoryService: Repository {}


