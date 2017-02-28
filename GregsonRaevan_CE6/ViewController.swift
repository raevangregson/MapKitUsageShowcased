//
//  ViewController.swift
//  GregsonRaevan_CE6
//
//  Created by Raevan Gregson on 12/9/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import UIKit
import MapKit

private let identifier = "Annotation"

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //outlets for my UI the map and the nav button
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    //variables to hold my data throughout, notice the array that holds annotation points and some bools for to signal my switches on the other view
    var locationManager = CLLocationManager()
    var annotationToggle = true
    var annotations = [MKPointAnnotation]()
    var location = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //this is where I load in my annotation data and add it into my array var
        let disney = MKPointAnnotation()
        disney.coordinate = CLLocationCoordinate2D(latitude:28.3852, longitude:-81.5639)
        disney.title = "Disney"
        disney.subtitle = "Theme Park"
        let fullsail = MKPointAnnotation()
        fullsail.coordinate = CLLocationCoordinate2D(latitude:28.5959, longitude:-81.3019)
        fullsail.title = "Full Sail University"
        fullsail.subtitle = "School"
        let kennedySpaceCenter = MKPointAnnotation()
        kennedySpaceCenter.coordinate = CLLocationCoordinate2D(latitude:28.5729, longitude:-80.6490)
        kennedySpaceCenter.title = "Nasa Kennedy Space Center"
        kennedySpaceCenter.subtitle = "Space Administration Field Center"
        let bushGardens = MKPointAnnotation()
        bushGardens.coordinate = CLLocationCoordinate2D(latitude:28.0373, longitude:-82.4194)
        bushGardens.title = "Bush Gardens"
        bushGardens.subtitle = "Theme Park"
        let magicKingdom = MKPointAnnotation()
        magicKingdom.coordinate = CLLocationCoordinate2D(latitude:28.4177, longitude:-81.5812)
        magicKingdom.title = "Magic Kingdom"
        magicKingdom.subtitle = "Theme Park"
        
        annotations = [disney,fullsail,kennedySpaceCenter,bushGardens,magicKingdom]
        
        //where I add my annotations to the map along with the zoomed range as when first running it is preloaded to this range not the users location
        mapView.addAnnotations(annotations)
        
        //let user know
        //changing the region by location and span
        let location = CLLocationCoordinate2D(latitude: 28.5947, longitude: -81.3031)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        //creating the region
        let region = MKCoordinateRegion(center: location, span: span)
        
        //function to set up the map
        mapView.setRegion(region, animated:true)
        
        locationManager.delegate = self
        mapView.delegate = self
        
        navStatusCheck()
        
    }
    
    //function where I set some UI stuff up for the annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //make sure the user location isn't a pin
        if annotation is MKUserLocation{
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if view == nil{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        //configuring the view
        view?.animatesDrop = true
        view?.canShowCallout = true
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navToggleClick(_ sender: UIBarButtonItem) {
        navStatusCheck()
    }
    
    //this is where I check the authorization status, I put it in a seperate function since I use the code twice, this way I only need to type it out once and then just call the function when I need to check authorization status
    func navStatusCheck(){
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == .denied || status == .restricted{
            //let user know
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse{
            if CLLocationManager.locationServicesEnabled(){
                // I use the nav button image to determine whether I should be tracking the users location or not (I use two different images on when active and one when not)
                if navButton.image == #imageLiteral(resourceName: "nav"){
                    navButton.image = #imageLiteral(resourceName: "navFilled")
                    locationManager.startUpdatingLocation()
                    mapView.showsUserLocation = true
                    location = true
                }
                else{
                    navButton.image = #imageLiteral(resourceName: "nav")
                    mapView.showsUserLocation = false
                    locationManager.stopUpdatingLocation()
                    location = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        //creating the region
        let region = MKCoordinateRegion(center: location, span: span)
        
        //function to set up the map
        mapView.setRegion(region, animated:true)
        let accuracy = mapView.userLocation.location?.horizontalAccuracy
        if accuracy ?? 0 > 0 {
            locationManager.stopUpdatingLocation()
        }
    }
    
    // I use one action to change the map type in the segment control, dependent on its tag
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
        
    }
    
    //this is where I check whether my annotations should be on or not by checking what the bool is
    override func viewDidAppear(_ animated: Bool) {
        if annotationToggle == true{
            mapView.addAnnotations(annotations)
        }
        else{
            mapView.removeAnnotations(annotations)
        }
    }
    
    //this is where I send info to my other view controller from this controller, specifically my bools
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        let destinationNavigationController = segue.destination as! SecondViewController
        destinationNavigationController.annotationToggle = annotationToggle
        destinationNavigationController.location = location
    }
}

