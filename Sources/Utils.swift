//
//  File.swift
//  
//
//  Created by Mike Mello on 6/29/24.
//

import Foundation

struct Utils {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
