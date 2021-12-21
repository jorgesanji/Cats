//
//  GalleryAssemblyContainer.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Swinject
import SwinjectStoryboard

final class GalleryAssemblyContainer: Assembly {
	
	func assemble(container: Container) {
		
		container.register(InitSessionUseCase.self) { r in
			let initSessionUseCase = InitSession(proxyService: r.resolve(ProxyService.self)!)
			return initSessionUseCase
		}
		
		container.register(GetCredentialsUseCase.self) { r in
			let localPrivateStore = r.resolve(LocalDataPrivate.self)!
			let getAccessTokenUseCase = GetCredentials(proxyService: r.resolve(ProxyService.self)!, localPrivateStore: localPrivateStore)
			return getAccessTokenUseCase
		}
		
		container.register(GetImagesUseCase.self) { r in
			let getImagesUseCase = GetImages(proxyService: r.resolve(ProxyService.self)!)
			return getImagesUseCase
		}
		container.register(GalleryInteractorInput.self) { (r, presenter: GalleryPresenter) in
			let initSession = r.resolve(InitSessionUseCase.self)!
			let getCredentialsUseCase = r.resolve(GetCredentialsUseCase.self)!
			let getImagesUseCase = r.resolve(GetImagesUseCase.self)!
			let interactor = GalleryInteractor(initSessionUC: initSession, getCredentialsUC: getCredentialsUseCase, getImagesUC: getImagesUseCase)
			interactor.output = presenter
			
			return interactor
		}
		
		container.register(GalleryRouterInput.self) { (r, viewController: GalleryViewController) in
			let router = GalleryRouter(transitionHandler: viewController)
			return router
		}
		
		container.register(GalleryViewOutput.self) { (r, view: GalleryViewController) in
			let router = r.resolve(GalleryRouterInput.self, argument: view)!
			let presenter = GalleryPresenter(view:view, router: router)
			presenter.interactor = r.resolve(GalleryInteractorInput.self, argument: presenter)
			return presenter
		}
		
		container.storyboardInitCompleted(GalleryViewController.self) {r, viewController in
			viewController.output = r.resolve(GalleryViewOutput.self, argument: viewController)
		}
	}
}
