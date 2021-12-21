//
//  GalleryInteractor.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

final class GalleryInteractor{
	
	weak var output : GalleryInteractorOutput!
	
	fileprivate final let getImagesUC : GetImagesUseCase
	fileprivate final let initSessionUC : InitSessionUseCase
	fileprivate final let getCredentialsUC : GetCredentialsUseCase
	
	init(initSessionUC : InitSessionUseCase, getCredentialsUC : GetCredentialsUseCase, getImagesUC : GetImagesUseCase){
		self.initSessionUC = initSessionUC
		self.getCredentialsUC = getCredentialsUC
		self.getImagesUC = getImagesUC
	}
}

extension GalleryInteractor : GalleryInteractorInput{
	
	func initSession(){
		initSessionUC.build().subscribe {[weak self] _ in
			self?.output.initSessionSuccess()
		} onError: {[weak self]  error in
			self?.output.initSessionError(error)
		}
	}
	
	func getCredentials(){
		getCredentialsUC.build().subscribe {[weak self] in
			self?.output.getCredentialsSuccess()
		} onError: {[weak self] error in
			self?.output.getCredentialsError(error)
		}
	}
	
	func getImages(page: Int){
		getImagesUC.setParams(page: page).build().subscribe {[weak self]  dataResponse in
			self?.output.getImagesSuccess(response: dataResponse)
		} onError: {[weak self]  error in
			self?.output.getImagesError(error)
		}
	}
}
