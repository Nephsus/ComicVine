//
//  String+NilProtocol.swift
//  ComicList
//
//  Created by David on 22/3/17.
//  Copyright © 2017 Guille Gonzalez. All rights reserved.
//

import Foundation


 extension String {

     static  public func transformNilValuePepe(withValue rawValue: Any) -> String{
    
        if( rawValue is NSNull ){
           return "" as! String
        }
    
        return rawValue as! String
    }
    
    
    

}
