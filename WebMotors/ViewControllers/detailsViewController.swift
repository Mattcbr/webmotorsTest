//
//  ViewController.swift
//  WebMotors
//
//  Created by Matheus Queiroz on 5/12/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

import UIKit
//import Alamofire
//import AlamofireImage

class detailsViewController: UIViewController {
    
    // MARK: Creating the Outlets and Variables neccessary
    @IBOutlet weak var carPictureImageView: UIImageView!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var carMakerLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carVersionLabel: UILabel!
    @IBOutlet weak var carKMLabel: UILabel!
    @IBOutlet weak var carColorLabel: UILabel!
    @IBOutlet weak var carFabYearLabel: UILabel!
    @IBOutlet weak var carModelYearLabel: UILabel!
    
    let carMakerText = NSMutableAttributedString()
    let carModelText = NSMutableAttributedString()
    let carVersionText = NSMutableAttributedString()
    let carKmText = NSMutableAttributedString()
    let carColorText = NSMutableAttributedString()
    let carYearFabText = NSMutableAttributedString()
    let carYearModelText = NSMutableAttributedString()
    
    var selectedCar: Car? {
        didSet {
            self.view.reloadInputViews()
        }
    }
    
    // MARK: Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the navigation title
        self.navigationItem.title = "\(selectedCar!.make) \(selectedCar!.model)"
        
        //Setting the car picture
        carPictureImageView.image = selectedCar!.image
        
        //Call the functions to set the labels text and configure and display the labels
        setLabelsText()
        configureAndDisplayLabels()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Labels Functions
    
    //This functions sets the labels texts
    func setLabelsText(){
        carMakerText
            .bold("Montadora")
            .normal("\n\(selectedCar!.make)")
        
        carModelText
            .bold("Modelo")
            .normal("\n\(selectedCar!.model)")
        
        carVersionText
            .bold("Versão")
            .normal("\n\(selectedCar!.version)")
        
        carKmText
            .bold("Kilometragem")
            .normal("\n\(selectedCar!.km) Km")
        
        carColorText
            .bold("Cor")
            .normal("\n\(selectedCar!.color)")
        
        carYearFabText
            .bold("Ano de Fabricação")
            .normal("\n\(selectedCar!.yearFab)")
        
        carYearModelText
            .bold("Ano do Modelo")
            .normal("\n\(selectedCar!.yearModel)")
    }
    
    //This functions configures and displays each of the labels
    func configureAndDisplayLabels() {
        carPriceLabel.numberOfLines = 0
        carPriceLabel.text = "R$ \(selectedCar!.price)"
        carPriceLabel.sizeToFit()
        
        carMakerLabel.numberOfLines = 0
        carMakerLabel.attributedText = carMakerText
        carMakerLabel.sizeToFit()
        
        carModelLabel.numberOfLines = 0
        carModelLabel.attributedText = carModelText
        carModelLabel.sizeToFit()
        
        carVersionLabel.numberOfLines = 0
        carVersionLabel.attributedText = carVersionText
        carVersionLabel.sizeToFit()
        
        carKMLabel.numberOfLines = 0
        carKMLabel.attributedText = carKmText
        carKMLabel.sizeToFit()
        
        carColorLabel.numberOfLines = 0
        carColorLabel.attributedText = carColorText
        carColorLabel.sizeToFit()
        
        carFabYearLabel.numberOfLines = 0
        carFabYearLabel.attributedText = carYearFabText
        carFabYearLabel.sizeToFit()
        
        carModelYearLabel.numberOfLines = 0
        carModelYearLabel.attributedText = carYearModelText
        carModelYearLabel.sizeToFit()
    }

}

// MARK: Text bold extension

//This function is used to create attributed texts with bold and regular words together inside it
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 18)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
