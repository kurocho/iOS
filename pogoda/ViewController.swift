//
//  ViewController.swift
//  pogoda
//
//  Created by Piotr Snopekon 17/10/2019.
//  Copyright © 2019 Piotr Snopek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let daysDisplayed : Int = 6
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var weatherType: UITextField!
    
    @IBOutlet weak var maxTemp: UITextField!
    
    @IBOutlet weak var minTemp: UITextField!
    
    @IBOutlet weak var windSpeed: UITextField!
    
    @IBOutlet weak var rainfall: UITextField!
    
    @IBOutlet weak var pressure: UITextField!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var time: UITextField!
    
    @IBOutlet weak var windBearing: UITextField!
    
    
    var data = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Weather.getData(latitude: "50.064651", longitude: "19.944981", completion:{ (results:[Weather]?) in
            
            if let weatherData = results {
                self.data = weatherData
                
                DispatchQueue.main.async {
                    self.reloadData(i: 0)
                }
                
            }
        })
        pageControl.numberOfPages = daysDisplayed
    }
    
    func reloadData(i: Int) {
        self.displayDate(unixtimeInterval: self.data[i].timeStamp)
        self.weatherType.text = self.data[i].weatherType
        self.maxTemp.text = String(self.data[i].maxTemp)
        self.rainfall.text = String(self.data[i].rainfall)
        self.pressure.text = String(self.data[i].pressure)
        self.minTemp.text = String(self.data[i].minTemp)
        self.windSpeed.text = String(self.data[i].windSpeed)
        self.icon.image = UIImage(named: self.data[i].icon)
        self.windBearing.text = String(self.data[i].windDirection)
    }
    
    func displayDate(unixtimeInterval: Double) {
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        self.time.text = strDate
    }
    
    @IBAction func forwardSwipe(_ sender: UISwipeGestureRecognizer) {
        if(pageControl.currentPage < pageControl.numberOfPages) {
            pageControl.currentPage += 1
            self.reloadData(i: pageControl.currentPage)
        }
    }
    @IBAction func backwardSwipe(_ sender: Any) {
            if(pageControl.currentPage >= 1) {
            pageControl.currentPage += -1
            self.reloadData(i: pageControl.currentPage)
        }
    }
}
