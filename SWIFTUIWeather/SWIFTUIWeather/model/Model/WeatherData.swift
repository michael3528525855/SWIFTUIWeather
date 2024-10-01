//
//  WeatherData.swift
//  SWIFTUIWeather
//
//  Created by michael on 24/09/2024.
//

import Foundation
import Foundation
struct WeatherData :Codable{
    let name :String
    let main : Main
    let weather:[Weather]
}
struct Main :Codable{
    let temp:Double
}
struct Weather:Codable{
    let id : Int
    let description:String
}
