//
//  GalleryInteractorInput.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol GalleryInteractorInput : AnyObject {
	func initSession()
	func getCredentials()
	func getImages(page : Int)
}
