//
//  Resource+ComicVine.swift
//  ComicList
//
//  Created by Guille Gonzalez on 12/03/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation
import Networking

let apiKey = "4c2f7f8c0970eb7da39688593fe0908c20d6a4a1"
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
