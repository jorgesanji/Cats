//
//  DataResponse.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation
import Moya

struct DataResponse : Hashable, Codable{
	
	var data:[ImgurItem]?
	var success: Bool =  false
	var status: Int?
	
	private enum CodingKeys : String, CodingKey {
		case data = "data"
		case success = "success"
		case status = "status"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.status = try container.decodeIfPresent(Int.self, forKey: .status)
		if status == HttpCodes.HTTP_INTERNAL_SERVER.rawValue{
			self.data = []
			self.success = false
		}else{
			self.data = try container.decodeIfPresent([ImgurItem].self, forKey: .data)
			self.success = true
		}
	}
}
