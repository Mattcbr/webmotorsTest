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

    @IBOutlet weak var loadingCarsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var carsCountLabel: UILabel!
    var r = Request()
    var pageNumber = 1
    var isLoadingData = false
    var firstRequest = true
    
    var carsArray: [Car]? {
        didSet {
            //When the array with cars has been set reloads the collection view and stops the loading view
            self.collectionView?.reloadData()
            loadingCarsActivityIndicator.stopAnimating()
            isLoadingData = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingCarsActivityIndicator.hidesWhenStopped = true
        loadingCarsActivityIndicator.startAnimating()
        
        self.navigationItem.title = "WebMotors"
        
        /*
        let loadingNib = UINib(nibName: "loadingCollectionViewCell", bundle: nil)
        collectionView?.register(loadingNib, forCellWithReuseIdentifier: "loadingCell")
         */
        
        
        r.delegate = self
        r.requestInfo(pageNumber: pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
            return carsArray?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as? carCollectionViewCell else {
            fatalError("Not a car collection view cell")
        }
    
        //Get the car that corresponds to the cell
        let carToDisplay: Car = carsArray![indexPath.row]
       
        
        let carsCount = carsArray?.count ?? 0
        cell.carsCountLabel.text = "\(carsCount)"
        
        cell.imageLoadingActivityIndicator.hidesWhenStopped = true
        cell.imageLoadingActivityIndicator.startAnimating()
        
        if(!carToDisplay.hasLoadedImage) {
        Alamofire.request((carToDisplay.imageLink)).responseImage { response in
            if let image = response.result.value {
                cell.carPictureImageView.image = image //Set the show image
                cell.imageLoadingActivityIndicator.stopAnimating() //Stop the loading indicator once the image has been loaded.
                self.carsArray![indexPath.row].image = image
                self.carsArray![indexPath.row].hasLoadedImage = true
            }
        }
        } else {
            cell.carPictureImageView.image = carToDisplay.image
        }
        cell.carPriceLabel.text = "R$\(carToDisplay.price)"
        cell.carNameLabel.text = "\(carToDisplay.make) \(carToDisplay.model) \(carToDisplay.version)"
        cell.carYearLabel.text = "\(carToDisplay.yearFab)/\(carToDisplay.yearModel)"
        cell.carKMLabel.text = "\(carToDisplay.km) Km"
        cell.carColorLabel.text = carToDisplay.color
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        let diff = scrollContentSizeHeight - scrollOffset - scrollViewHeight
//        print("Diferença: \(diff)")
        
        let carCount = carsArray?.count ?? 0
        
        if (diff<30 && pageNumber < 4 && carCount > 0 && !isLoadingData)
        {
            pageNumber += 1
            r.requestInfo(pageNumber: pageNumber)
            loadingCarsActivityIndicator.startAnimating()
            isLoadingData = true
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! detailsViewController
        let cell = sender as! carCollectionViewCell
        var selectedIndexPath = self.collectionView?.indexPath(for: cell)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        //Getting the show that was selected and its poster
        let selectedCar: Car = carsArray![(selectedIndexPath?.row)!]
        let carImage = cell.carPictureImageView.image
        
        destination.carImage = carImage!
        destination.selectedCar = selectedCar
        navigationItem.backBarButtonItem = backItem
     }

    //MARK: Delegate Functions
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
    
    func didFailToLoadCars(withError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
