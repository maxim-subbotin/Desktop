//
//  WiFiProvider.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation

class WifiProvider {
    enum WifiError: Error {
        case networkAccessError
    }
    
    func getWifiInfo(callback: @escaping (Result<String, Error>) -> ())  {
        // TODO: get real network data
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0, execute: {
            let f = Int.random(in: 0...10)
            if f > 3 {
                callback(.success("14A04-5ghz"))
            } else {
                callback(.failure(WifiError.networkAccessError))
            }
        })

    }
}
