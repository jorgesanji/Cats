//
//  Image.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation

struct Image : Hashable, Codable{
	var id : String
	var title : String?
	var description : String?
	var type : String
	var link : String
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.title = try container.decodeIfPresent(String.self, forKey: .title)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		self.type = try container.decode(String.self, forKey: .type)
		self.link = try container.decode(String.self, forKey: .link)
	}
}
