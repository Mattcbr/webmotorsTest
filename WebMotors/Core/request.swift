//
//  request.swift
//  WebMotors
//
//  Created by Matheus Queiroz on 5/12/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestDelegate: class{
    func didLoadCars(Cars: [Car])
    func didFailToLoadCars(withError error: Error)
}

class Request {
    
    weak var delegate: RequestDelegate?
    
    func requestInfo(pageNumber: Int) {
        
        //Makes a request with the page number
        let requestURL = "http://desafioonline.webmotors.com.br/api/OnlineChallenge/Vehicles?Page=\(pageNumber)"
        
        let p = Parser()
        
        Alamofire.request(requestURL).responseJSON{ response in
            switch response.result{
                
            case .success(let JSON):    //In case it succeds, it parses the received information and returns it to the shows collection view
                let carsArray = p.parseInfo(response: JSON)
                self.delegate?.didLoadCars(Cars: carsArray)
            case .failure(let error):   //In case of failure, return the error to the error handler in the shows collection view
                self.delegate?.didFailToLoadCars(withError: error)
            }
        }
    }
}
