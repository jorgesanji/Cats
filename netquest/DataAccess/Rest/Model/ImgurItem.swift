//
//  ImgurItem.swift
//  netquest
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import Foundation
import SwiftUI

struct ImgurItem : Hashable, Codable{
	var id : String
	var title : String
	var description : String?
	var views : Int64
	var viewsFormatted : String
	var images : [Image]?
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		self.views = try container.decode(Int64.self, forKey: .views)
		self.images =  try container.decodeIfPresent([Image].self, forKey: .images)
		
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		self.viewsFormatted = formatter.number(from: views.description)!.doubleValue.kmFormatted
	}
}

extension ImgurItem {
	
	func isNeedToFilter() -> Bool{
		return self.images == nil
	}
	
	static func filterNoValidItem(_ items:[ImgurItem]) -> [ImgurItem]{
		return items.filter { item in
			return !item.isNeedToFilter()
		}
	}
}
