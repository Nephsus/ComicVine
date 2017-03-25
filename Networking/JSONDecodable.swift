//
//  JSONDecodable.swift
//  ComicList
//
//  Created by Guille Gonzalez on 11/03/2017.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]

public enum JSONError: Error {
	case invalidData
	case notFound(String)
	case invalidValue(Any, String)
}

public protocol JSONDecodable {
	init(jsonDictionary: JSONDictionary) throws
}

public protocol JSONValueDecodable {
	associatedtype Value

	init?(jsonValue: Value)
}


public protocol NilTransformProtocol {
    static func transformNilValueToRawValue<T>(withValue rawValue: Any) -> T
}


extension String : NilTransformProtocol {
    public static func transformNilValueToRawValue<T>(withValue rawValue: Any) -> T{
        if( rawValue is NSNull ){
            return "" as! T
        }
        return rawValue as! T
    }
    
}


extension JSONValueDecodable where Self: RawRepresentable {

	public init?(jsonValue: Self.RawValue) {
		self.init(rawValue: jsonValue)
	}
}

extension URL: JSONValueDecodable {
	public init?(jsonValue: String) {
		self.init(string: jsonValue)
	}
}



public func decode<T: JSONDecodable>(jsonDictionary: JSONDictionary) throws -> T {
	return try T(jsonDictionary: jsonDictionary)
}

public func decode<T: JSONDecodable>(jsonArray: JSONArray) throws -> [T] {
	return try jsonArray.map(decode(jsonDictionary:))
}

public func decode<T: JSONDecodable>(data: Data) throws -> T {
    let datastring = String(data: data, encoding: .utf8)
    print("\(datastring)")
	let object = try JSONSerialization.jsonObject(with: data, options: [])

	guard let dictionary = object as? JSONDictionary else {
		throw JSONError.invalidData
	}

	return try decode(jsonDictionary: dictionary)
}

public func unpack<T>(from jsonDictionary: JSONDictionary, key: String) throws -> T {
	guard var rawValue = jsonDictionary[key] else {
		throw JSONError.notFound(key)
	}
    

    if T.self == String.self{
        rawValue = String.transformNilValueToRawValue(withValue: rawValue)
    }
    

	guard let value = rawValue as? T else {
         print("otro massss+++++++++++++++++++++++++++++++++ \(key) \(type(of: rawValue) )  \(type(of: T.self) )" )
		throw JSONError.invalidValue(rawValue, key)
	}

	return value
}

public func unpack<T: JSONValueDecodable>(from jsonDictionary: JSONDictionary, keyPath: String) throws -> T {
	
    guard let rawValue = (jsonDictionary as NSDictionary).value(forKeyPath: keyPath) else {
		throw JSONError.notFound(keyPath)
	}

	guard let value = rawValue as? T.Value,
		let decodedValue = T(jsonValue: value) else {
        
        print("lere lere+++++++++++++\(  type(of: rawValue) ) ")
          
           
                throw JSONError.invalidValue(rawValue, keyPath)
          
	}

	return decodedValue
}

public func unpackModel<T: JSONDecodable>(from jsonDictionary: JSONDictionary, key: String) throws -> T {
	let rawValue: JSONDictionary = try unpack(from: jsonDictionary, key: key)
	return try decode(jsonDictionary: rawValue)
}

public func unpackModels<T: JSONDecodable>(from jsonDictionary: JSONDictionary, key: String) throws -> [T] {
	let rawValues: JSONArray = try unpack(from: jsonDictionary, key: key)
	return try decode(jsonArray: rawValues)
}
