//
//  Car.swift
//  WebMotors
//
//  Created by Matheus Queiroz on 5/12/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

import Foundation
import UIKit

struct Car {
    
    let color : String
    let imageLink : String
    let km : Int
    let make : String
    let model : String
    let price : String
    let version : String
    let yearFab : Int
    let yearModel : Int
    var image: UIImage
    var hasLoadedImage: Bool
    
    init(color: String, imageLink: String, km: Int, make: String, model: String, price: String, version: String, yearFab: Int, yearModel: Int) {
        self.color = color
        self.imageLink = imageLink
        self.km = km
        self.make = make
        self.model = model
        self.price = price
        self.version = version
        self.yearFab = yearFab
        self.yearModel = yearModel
        self.image = UIImage(named: "logo-webmotors")!
        self.hasLoadedImage = false
    }
}
