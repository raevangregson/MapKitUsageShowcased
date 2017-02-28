//
//  SecondViewController.swift
//  GregsonRaevan_CE6
//
//  Created by Raevan Gregson on 12/9/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate{
    //outlets for my UI elements
    @IBOutlet weak var locationToggle: UISwitch!
    @IBOutlet weak var annotationsToggle: UISwitch!
    
    //my holder variables that I use to pass information back and forth from the view controllers
    var annotationToggle = true
    var location = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        //depending on the values of my holders after passing from  my first vc, I setup the UI for this VC. To do this I use if statements to check what the values are and determine the state the UI should be in
        if annotationToggle == true{
            annotationsToggle.isOn = true
        }
        else{
            annotationsToggle.isOn = false
        }
        
        if location == true{
            locationToggle.isOn = true
        }
        else{
            locationToggle.isOn = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func annotationChanged(_ sender: UISwitch) {
        //this action determines whether the user wants annotations on or not, and sets up the a bool var to hold this info for when we switch back view controllers we can pass it along
        if annotationsToggle.isOn {
            annotationToggle = true
        }
        else{
            annotationToggle = false
        }
    }
    //this is when we switch back view controllers and pass back the bool they may or may of not been changed
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ViewController {
            controller.annotationToggle = annotationToggle
            controller.location = location
            controller.mapView.removeAnnotations(controller.annotations)
        }
    }
    //this loads the view dependent upon the bool which may or may not of changed since the first view did load
    override func viewDidAppear(_ animated: Bool) {
        if location == true{
            locationToggle.isOn = true
        }
        else{
            locationToggle.isOn = false
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
