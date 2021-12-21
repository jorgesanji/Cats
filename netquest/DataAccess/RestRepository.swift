//
//  RestRepository.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift
import Moya
import Alamofire

final class RestRepository : RestRepositoryService{
	
	fileprivate final let provider:MoyaProvider<NetquestServices>
	fileprivate final let localPrivateStore: LocalDataPrivate
	fileprivate var retryPolicyHandler: RetryPolicyHandler!
	fileprivate var authPlugin: AccessTokenPlugin!

	init(localPrivateStore: LocalDataPrivate) {
		self.localPrivateStore = localPrivateStore
		self.retryPolicyHandler = RetryPolicyHandler()
		self.provider = MoyaProvider<NetquestServices>(
			session: Alamofire.Session.manager(interceptor: retryPolicyHandler),
			plugins: [NetworkLoggerPlugin()])
		
		initPolicyHandler()
	}
	
	fileprivate func initPolicyHandler(){
		retryPolicyHandler.oAuthHandler = self
	}
	
	func getCredentials() -> Observable<Credentials>? {
		return provider.rx
			.request(.authorize(refreshToken: localPrivateStore.getRefreshToken(), clientId: localPrivateStore.getClientId(), clientSecret: localPrivateStore.getClientSecret()))
			.filterSuccessfulStatusAndRedirectCodes()
			.map(Credentials.self)
			.asObservable()
	}
	
	func getImages(page: Int) -> Observable<DataResponse>? {
		return provider.rx
			.request(.getImages(page: page, clientId: localPrivateStore.getClientId()!))
			.filterSuccessfulStatusAndRedirectCodes()
			.map(DataResponse.self)
			.asObservable()
	}
}

extension RestRepository: OAuthHandler{
	
	func renewTokenCredentials() {
		
	}
}

final class RetryPolicyHandler : Alamofire.RequestInterceptor{

	private let DELAY_TIME_TO_RETRY:TimeInterval = 5.0
	
	weak var oAuthHandler: OAuthHandler?
	private var status:Status = .WORKING

	func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
		if  let error = error as? AFError{
			if error.responseCode == HttpCodes.HTTP_UNAUTHORIZED.rawValue{
				if status != .UPDATING {
					self.status = .UPDATING
					oAuthHandler?.renewTokenCredentials()
				}
				completion(.retryWithDelay(DELAY_TIME_TO_RETRY))
			}else{
				completion(.doNotRetry)
			}
		}else{
			completion(.doNotRetry)
		}
	}
	
	func tokenUpdatingDone(){
		self.status = .WORKING
	}
}

extension Alamofire.Session{
	
	private static let REQUEST_TIME_OUT:TimeInterval = 150.0
	private static let RESOURCE_TIME_OUT:TimeInterval = 150.0
	
	static func manager(interceptor: RetryPolicyHandler) -> Alamofire.Session{
		let configuration = URLSessionConfiguration.af.default
		configuration.timeoutIntervalForRequest = REQUEST_TIME_OUT
		configuration.timeoutIntervalForResource = RESOURCE_TIME_OUT
		let sessionManager = Alamofire.Session(configuration: configuration, interceptor: interceptor)
		return sessionManager
	}
}

enum HttpCodes: Int {
	case HTTP_UNAUTHORIZED = 401
	case HTTP_INTERNAL_SERVER = 500
	case HTTP_INTERNET_ERROR = 1009
}

enum Status : Int{
	case UPDATING = 1
	case WORKING = 2
}

protocol OAuthHandler: AnyObject {
	func renewTokenCredentials()
}
