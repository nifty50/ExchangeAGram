//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Ansel Adams on 2/29/16.
//  Copyright © 2016 Ansel Adams. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let request = NSFetchRequest(entityName: "FeedItem")
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = appDelegate.managedObjectContext
        var itemArray: [AnyObject] = []
        do {
            itemArray = try context.executeFetchRequest(request)
        } catch {
            abort()
        }
        
        if itemArray.count > 0 {
            for item in itemArray {
                let location = CLLocationCoordinate2D(latitude: Double(item.latitude), longitude: Double(item.longitude))
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegionMake(location, span)
                mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = item.caption
                mapView.addAnnotation(annotation)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
