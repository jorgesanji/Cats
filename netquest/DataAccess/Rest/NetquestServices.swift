//
//  NetquestServices.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation
import Moya

enum NetquestServices {
	case authorize(refreshToken : String?, clientId : String?, clientSecret : String?)
	case getImages(page : Int, clientId : String)
}

extension NetquestServices: TargetType{
	
	static let boundary = "Boundary-\(UUID().uuidString)"
	
	var baseURL: URL {
		let path = "https://api.imgur.com"

		guard let url = URL(string: path) else { fatalError("baseURL could not be configured") }
		return url
	}
	
	var path: String {
		switch self {
		case .authorize:
			return "/oauth2/token"
		case .getImages(let page, _):
				return "/3/gallery/search/top/top/\(page)"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .authorize:
			return .post
		case .getImages:
			return .get
		}
	}
	
	var sampleData: Data {
		switch self {
		case .getImages:
			return Data()
		case .authorize:
			return Data()
		}
	}
	
	var task: Task {
		switch self {
		case .getImages:
			return .requestParameters(parameters: ["q_exactly": "cats", "q_type": "jpg"], encoding: URLEncoding.queryString)
		case .authorize:
			return .requestData(body!)
		}
	}
	
	var body: Data?{
		switch self {
		case .authorize(let refreshToken, let clientId, let clientSecret):
			let parameters = [
			  [
				"key": "refresh_token",
				"value": refreshToken!,
				"type": "text"
			  ],
			  [
				"key": "client_id",
				"value": clientId!,
				"type": "text"
			  ],
			  [
				"key": "client_secret",
				"value": clientSecret!,
				"type": "text"
			  ],
			  [
				"key": "grant_type",
				"value": "refresh_token",
				"type": "text"
			  ]] as [[String : String]]

			var body = ""
			for param in parameters {
			  if param["disabled"] == nil {
				let paramName = param["key"]!
				  body += "--\(NetquestServices.boundary)\r\n"
				body += "Content-Disposition:form-data; name=\"\(paramName)\""
				if param["contentType"] != nil {
					body += "\r\nContent-Type: \(param["contentType"] ?? "")"
				}
				let paramType = param["type"]
				if paramType == "text" {
				  let paramValue = param["value"]
					body += "\r\n\r\n\(paramValue ?? "")\r\n"
				} else {
					let paramSrc = param["src"]!
					do{
						let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
						let fileContent = String(data: fileData, encoding: .utf8)!
						body += "; filename=\"\(paramSrc)\"\r\n"
						+ "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
					}catch let error{
						print(error.localizedDescription)
					}
				}
			  }
			}
			body += "--\(NetquestServices.boundary)--\r\n";

			return body.data(using: .utf8)

		case .getImages:
			return nil
		}
	}
		
	var headers: [String : String]? {
		var headers:[String:String] = [:]
		headers["Accept"] = "*/*"
		headers["Accept-Encoding"] = "gzip, deflate, br"
		headers["Connection"] = "keep-alive"
		headers["Cache-Control"] = "no-cache"

		switch self {
		case .authorize(let refreshToken, let clientId, let clientSecret):
			headers["Content-Type"] = "multipart/form-data; boundary=\(NetquestServices.boundary)"
			headers["grant_type"] = "refresh_token"
			headers["client_id"] = clientId
			headers["client_secret"] = clientSecret
			headers["refresh_token"] = refreshToken
			return headers
		case .getImages(_, let clientId):
			headers["Authorization"] = "Client-ID "+clientId
			return headers
		}
	}
	
	var validationType: ValidationType {
		return .successCodes
	}
	
	var parameterEncoding: ParameterEncoding {
		switch self {
		case .getImages:
			return JSONEncoding()
		case .authorize:
			return JSONEncoding()
		}
	}
}

extension NetquestServices : AccessTokenAuthorizable{
	
	var authorizationType: AuthorizationType?{
		switch self {
		case .getImages, .authorize:
			return .bearer
		}
	}
}
