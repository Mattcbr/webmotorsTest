//
//  parser.swift
//  WebMotors
//
//  Created by Matheus Queiroz on 5/12/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

import Foundation

class Parser {
    
    func parseInfo(response: Any) -> [Car]{
        let JSONresponse = response as? [[String : Any]]
//        print(JSONresponse!)
        
        var carsArray = [Car]()
        
        JSONresponse?.forEach { vehicle in
            
            //Colects information of each show
            let color = vehicle["Color"] as? String
            let imageLink = vehicle["Image"] as? String
            let km = vehicle["KM"] as? Int
            let make = vehicle["Make"] as? String
            let model = vehicle["Model"] as? String
            let price = vehicle["Price"] as? String
            let version = vehicle["Version"] as? String
            let yearFab = vehicle["YearFab"] as? Int
            let yearModel = vehicle["YearModel"] as? Int
            
            //Create a "car" object
            let newCar = Car(color: color!,
                             imageLink: imageLink!,
                             km: km!,
                             make: make!,
                             model: model!,
                             price: price!,
                             version: version!,
                             yearFab: yearFab!,
                             yearModel: yearModel!)
            
            carsArray.append(newCar)
        }
        return carsArray
    }
}
