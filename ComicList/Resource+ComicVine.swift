//
//  Resource+ComicVine.swift
//  ComicList
//
//  Created by Guille Gonzalez on 12/03/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

let apiKey = "75d580a0593b7320727309feb6309f62def786cd"
private let apiURL = URL(string: "http://www.comicvine.com/api")!

extension Resource where M: JSONDecodable {

	init(comicVinePath path: String, parameters: [String: String]) {
		self.init(
			url: apiURL.appendingPathComponent(path),
			parameters: parameters,
			decode: decode(data:)
		)
	}
}
