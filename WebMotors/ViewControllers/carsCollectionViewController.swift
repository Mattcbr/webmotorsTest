//
//  carsCollectionViewController.swift
//  WebMotors
//
//  Created by Matheus Queiroz on 5/12/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

private let reuseIdentifier = "carCell"

class carsCollectionViewController: UICollectionViewController, RequestDelegate {

    // MARK: Creating the Outlets and Variables neccessary
    @IBOutlet weak var loadingCarsActivityIndicator: UIActivityIndicatorView!
    var r = Request()
    var pageNumber = 1
    var isLoadingData = false
    var firstRequest = true
    
    var carsArray: [Car]? {
        didSet {
            //When the array with cars has been set, reloads the collection view, stops the loading view and set loading data to false
            self.collectionView?.reloadData()
            loadingCarsActivityIndicator.stopAnimating()
            isLoadingData = false
        }
    }
    
    // MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingCarsActivityIndicator.hidesWhenStopped = true
        loadingCarsActivityIndicator.startAnimating()
        
        //Set the navigation title
        self.navigationItem.title = "WebMotors"
        
        //Setting the request delegate and making a request
        r.delegate = self
        r.requestInfo(pageNumber: pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return carsArray?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Get the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? carCollectionViewCell else {
            fatalError("Not a car collection view cell")
        }
    
        //Get the car that corresponds to the cell
        let carToDisplay: Car = carsArray![indexPath.row]
        
        //Setting the image loading indicator view properties and starting it
        cell.imageLoadingActivityIndicator.hidesWhenStopped = true
        cell.imageLoadingActivityIndicator.startAnimating()
        
        //If the car's image has not been loaded yet, request the image
        if(!carToDisplay.hasLoadedImage) {
        Alamofire.request((carToDisplay.imageLink)).responseImage { response in
            if let image = response.result.value {
                cell.carPictureImageView.image = image                  //Set the car image
                cell.imageLoadingActivityIndicator.stopAnimating()      //Stop the loading indicator once the image has been loaded.
                self.carsArray![indexPath.row].image = image            //Save the image to the car object
                self.carsArray![indexPath.row].hasLoadedImage = true    //Set "has loaded image" to yes
            }
        }
        } else {                                                    //If the car's image has already been set
            cell.carPictureImageView.image = carToDisplay.image     //Show it
            cell.imageLoadingActivityIndicator.stopAnimating()      //Stop the loading indicator once the image has been shown.
        }
        
        //Setting the labels texts
        cell.carPriceLabel.text = "R$\(carToDisplay.price)"
        cell.carNameLabel.text = "\(carToDisplay.make) \(carToDisplay.model) \(carToDisplay.version)"
        cell.carYearLabel.text = "\(carToDisplay.yearFab)/\(carToDisplay.yearModel)"
        cell.carKMLabel.text = "\(carToDisplay.km) Km"
        cell.carColorLabel.text = carToDisplay.color
        
        //Setting some desing properties to the cell
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    //MARK: Infinite Scroll
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height             //This gets the Scroll View Height
        let scrollContentSizeHeight = scrollView.contentSize.height     //This gets the Scroll Content Size Height
        let scrollOffset = scrollView.contentOffset.y                   //This gets the Scroll Offset
        
        let diff = scrollContentSizeHeight - scrollOffset - scrollViewHeight    //This detects if the scroll is near the botoom of the scroll view
        
        let carCount = carsArray?.count ?? 0                            //This is used to prevent errors that happen when the Cars array is not set yet
        
        if (diff<30 && pageNumber < 4 && carCount > 0 && !isLoadingData)    //If the scroll is near the bottom, the page to be requested exists, there is an array
                                                                            //Of cars and there is no data being loaded, make a new request.
        {
            pageNumber += 1
            r.requestInfo(pageNumber: pageNumber)    //Request a new array of cars
            isLoadingData = true                    //Change "is loading data" to true
        }
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! detailsViewController
        let cell = sender as! carCollectionViewCell
        var selectedIndexPath = self.collectionView?.indexPath(for: cell)
        
        //Setting the back navigation buttom properties
        let backItem = UIBarButtonItem()
        backItem.title = "Voltar"
        
        //Getting the car that was selected
        let selectedCar: Car = carsArray![(selectedIndexPath?.row)!]
        
        //Sending the information to the next screen
        destination.selectedCar = selectedCar
        navigationItem.backBarButtonItem = backItem
     }

    //MARK: Delegate Functions
    
    //Handles the request and parse success
    func didLoadCars(Cars: [Car]) {
        if(firstRequest){
            carsArray = Cars
            firstRequest = false
        } else {
            Cars.forEach{newCar in
                carsArray?.append(newCar)
            }
        }
    }
    
    //Handles the request error
    func didFailToLoadCars(withError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

}
