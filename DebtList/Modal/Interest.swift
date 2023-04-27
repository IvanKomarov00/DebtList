//
//  Interest.swift
//  DebtList
//
//  Created by Ivan Komarov on 21.04.2023.
//

import Foundation

struct Interest: Equatable, Codable{
    enum TimeState:String, Codable{
        case daily
        case mouthly
        case yearly
    }
    
    var state: TimeState
    var percent: Float
    
}

