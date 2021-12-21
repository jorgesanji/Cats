//
//  GetImages.swift
//  netquest
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import RxSwift

protocol GetImagesUseCase: AnyObject{
	func build()->BaseUseCase<DataResponse>
	func setParams(page : Int) -> GetImagesUseCase
}

final class GetImages: BaseUseCase<DataResponse>, GetImagesUseCase{
	
	private var page : Int!
		
	override func buildUseCaseObservable() -> Observable<DataResponse>? {
		return proxyService!.repository().getImages(page: page)?.map({ dataResponse in
			
			//Filtering items without images
			var responseFiltered = dataResponse
			responseFiltered.data = ImgurItem.filterNoValidItem(responseFiltered.data!)
			return responseFiltered
		})
	}
	
	func setParams(page: Int) -> GetImagesUseCase {
		self.page = page
		return self
	}
}

