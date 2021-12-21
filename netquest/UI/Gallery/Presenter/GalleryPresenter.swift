//
//  GalleryPresenter.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation

final class GalleryPresenter{
	
	fileprivate weak final var view: GalleryViewInput!
	fileprivate final let router: GalleryRouterInput!
	
	var interactor: GalleryInteractorInput!
	
	fileprivate var images : [ImgurItem] = []
	fileprivate var page : Int = 0
	fileprivate var loading : Bool = false
	
	init(view: GalleryViewInput, router: GalleryRouterInput) {
		self.view = view
		self.router = router
	}
	
	fileprivate	func retrieveMoreItemsIfNeeded(at:Int) {
		if at > abs(images.count)/2 && !loading{
			getImages()
		}
	}
	
	fileprivate func getImages(){
		self.loading = true
		interactor.getImages(page: self.page)
	}
}

extension GalleryPresenter : GalleryViewOutput{
	
	func initData(){
		interactor.initSession()
	}
	
	func clearAndReload(){
		self.page = 0
		self.loading = true
		images.removeAll()
		view.reloadData()
		interactor.getImages(page: self.page)
	}
}

extension GalleryPresenter : DataSource{
	
	func getItemCount() -> Int {
		return images.count
	}
	
	func getItem(at: Int) -> (title : String, views : String, image : String){
		
		retrieveMoreItemsIfNeeded(at: at)
		
		let item = images[at]
		let title = item.title
		let views = "total_views".localized(with: [item.viewsFormatted])
		let link = item.images![0].link
		
		return (title, views, link)
	}
}

extension GalleryPresenter : GalleryInteractorOutput{
	
	func initSessionSuccess() {
		interactor.getCredentials()
	}
	
	func initSessionError(_ error: Error){
		view.showError(message: "error_loading_cats".localized)
	}
	
	func getCredentialsSuccess(){
		getImages()
	}
	
	func getCredentialsError(_ error : Error){
		view.showError(message: "error_loading_cats".localized)
	}
	
	func getImagesSuccess(response: DataResponse) {
		if response.success{
			self.page += 1
			self.loading = false
			if images.isEmpty{
				images.append(contentsOf: response.data!)
				view.reloadData()
				view.endRefreshing()
			}else{
				let from = images.count
				images.append(contentsOf:response.data!)
				let to = images.count - 1
				if to > from{
					view.insertItems(from: from, to: to)
				}
			}
		}
	}
	
	func getImagesError(_ error: Error) {
		self.loading = false
		view.endRefreshing()
		view.showError(message: "error_loading_cats".localized)
	}
}
