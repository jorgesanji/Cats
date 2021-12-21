//
//  Credentials.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

/*{
	"access_token": "8d1e620d4323e80c934a635d39bc33deafdc938b",
	"expires_in": 315360000,
	"token_type": "bearer",
	"scope": null,
	"refresh_token": "fb9fcc94bd384c175a70ce88c379f6e702a732e6",
	"account_id": 158261808,
	"account_username": "jorgesanji2"
}*/

struct Credentials : Hashable, Codable{
	var access_token : String?
	var refresh_token : String?
}
