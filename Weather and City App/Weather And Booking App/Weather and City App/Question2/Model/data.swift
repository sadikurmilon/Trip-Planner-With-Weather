//
//  data.swift
//  prt
//
//  Created by User on 2021-04-16.
//  Copyright © 2021 Seneca. All rights reserved.
//

import Foundation

struct weatherinfo : Decodable {
    let main : Main
    let weather : [Weather]
    
}
struct Main : Decodable{
    let temp : Double
    let temp_max : Double
    
}
struct Weather : Decodable{
   let icon: String
    let main: String
}
