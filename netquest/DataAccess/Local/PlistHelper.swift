//
//  PlistHelper.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation

struct PlistHelper{
	
	static func readPlist() -> (clientId:String, clientSecret:String, refreshToken:String){
		if let infoPlistPath = Bundle.main.path(forResource: "Data", ofType: "plist"),
		   let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: Any] {
			let credentials : [String: String] = dict["Crendentials"] as! [String : String]
			return (credentials["clientId"]! ,credentials["clientSecret"]!,
					credentials["refreshToken"]!)
		}
		return("", "", "")
	}
	
}
