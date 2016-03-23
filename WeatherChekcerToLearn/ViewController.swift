//
//  ViewController.swift
//  WeatherChekcerToLearn
//
//  Created by user on 23/02/2016.
//  Copyright © 2016 RegolioLS. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, NSURLSessionDelegate, CLLocationManagerDelegate{
    
    //MARK: constant
    let API_KEY: String = "&APPID=5fee61bb7040b46210589d7527d7fa4f";
    let WEATHER_URL: String = "http://www.openweathermap.org/data/2.5/";
    let WEATHER_DAILY: String = "weather?q=";
    let WEATHER_BY_GEO: String = "weather?";
    let WEATHER_BY_GEO_LAT: String = "lat=";
    let WEATHER_BY_GEO_LON: String = "&lon=";
    let CELVIN_TO_CELSIUS: Double = 273.15;
    let locationManager = CLLocationManager();
    
    //MARK: Variables
    var lon: Double = 0.0;
    var lat: Double = 0.0;
    var cityString: String!;
    
    //MARK: Outlet
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var byCityButton: UIButton!
    @IBOutlet weak var byGPSButton: UIButton!
    @IBOutlet weak var outputText: UITextView!
    
    //MARK: Action
    @IBAction func byNameSearch(sender: UIButton) {
        cityName.resignFirstResponder();
        cityString = cityName.text as String!;
        if cityString.containsString(" "){
            cityString = cityString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.decomposableCharacterSet());
        }
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session: NSURLSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil);
        let url = NSURL(string: WEATHER_URL + WEATHER_DAILY + cityString! + API_KEY);
        print("lat: \(lat) lon: \(lon) ");
        let task = session.dataTaskWithURL(url!){(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print("Done");
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments);
                
                if let weather = json["weather"] as? [[String: AnyObject]]{
                    let clouds = weather.first;
                    let name: String = json["name"] as! String;
                    let temp = json["main"] as? [String: AnyObject];
                    let numTemp: Float = (temp?["temp"] as! Float) - 273.15;
                    let humid = temp!["humidity"];
                    let skyStatus = clouds!["description"];
                    dispatch_async(dispatch_get_main_queue()){
                        self.outputText.text = "Location: \(name) Sky status: \(skyStatus!) Temperature: \(numTemp)  Humidity: \(humid!)";
                    }
                }else if let errorM = json["message"] as? [String: AnyObject]{
                    dispatch_async(dispatch_get_main_queue()){
                        self.outputText.text = "Error: \(errorM)" ;
                    }
                }
            }catch{
                
            }
            session.finishTasksAndInvalidate();
        };
        task.resume();

        
    }
    
    @IBAction func byGPSSearch(sender: UIButton) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session: NSURLSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil);
        let url = NSURL(string: WEATHER_URL + WEATHER_BY_GEO + WEATHER_BY_GEO_LAT + String(lat) + WEATHER_BY_GEO_LON + String(lon) + API_KEY);
        print("lat: \(lat) lon: \(lon) ");
        let task = session.dataTaskWithURL(url!){(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print("Done");
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments);
                
                if let weather = json["weather"] as? [[String: AnyObject]]{
                    let clouds = weather.first;
                    let name: String = json["name"] as! String;
                    let temp = json["main"] as? [String: AnyObject];
                    let numTemp: Float = (temp?["temp"] as! Float) - 273.15;
                    let humid = temp!["humidity"];
                    let skyStatus = clouds!["description"];
                    dispatch_async(dispatch_get_main_queue()){
                        self.outputText.text = "Location: \(name) Sky status: \(skyStatus!) Temperature: \(numTemp)  Humidity: \(humid!)";
                    }
                }else if let errorM = json["message"] as? [String: AnyObject]{
                    dispatch_async(dispatch_get_main_queue()){
                        self.outputText.text = "Error: \(errorM)" ;
                    }
                }
            }catch{
                
            }
            session.finishTasksAndInvalidate();
        };
        task.resume();
        
    }
    
    //MARK: Methodes
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityName.delegate = self;
        self.locationManager.delegate = self;
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 0;
        self.locationManager.startUpdatingLocation();
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true);
        self.locationManager.stopUpdatingLocation();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityName.resignFirstResponder();
        return true;
    }
    

}

