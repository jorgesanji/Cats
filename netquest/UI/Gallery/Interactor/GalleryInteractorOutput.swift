//
//  GalleryInteractorOutput.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol GalleryInteractorOutput : AnyObject {
	func initSessionSuccess()
	func initSessionError(_ error: Error)
	func getCredentialsSuccess()
	func getCredentialsError(_ error: Error)
	func getImagesSuccess(response:DataResponse)
	func getImagesError(_ error: Error)

}
