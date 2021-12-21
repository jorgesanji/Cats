//
//  GetAccessToken.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift

protocol GetCredentialsUseCase: AnyObject{
	func build()->BaseUseCase<Void>
}

final class GetCredentials: BaseUseCase<Void>, GetCredentialsUseCase{
	
	fileprivate final let localPrivateStore: LocalDataPrivate

	init(proxyService:ProxyService, localPrivateStore: LocalDataPrivate) {
		self.localPrivateStore = localPrivateStore
		super.init(proxyService: proxyService)
	}
		
	override func buildUseCaseObservable() -> Observable<Void>? {
		return proxyService!.repository().getCredentials()?.map({[weak self] credentials in

			//Updating tokens in keychain
			_ = self?.localPrivateStore.saveTokens(accessToken: credentials.access_token!, refreshToken: credentials.refresh_token!)
		})
	}
}

