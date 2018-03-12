//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, LocationsViewControllerDelegate
{
    
    
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var image:UIImage!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self;
 navigationController?.navigationBar.backgroundColor = UIColor.cyan
        navigationItem.title = "Map View";
        
        // Set up the camera button //
        cameraButton.layer.masksToBounds = true;
        cameraButton.layer.cornerRadius = 50;
        cameraButton.layer.borderWidth = 3
        cameraButton.backgroundColor = UIColor.clear;
        cameraButton.layer.borderColor = UIColor.white.cgColor;
        // Do any additional setup after loading the view.
        
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),MKCoordinateSpanMake(0.1, 0.1))
        
        
        
        mapView.setRegion(sfRegion, animated: false)
    }


   
    @IBAction func didTapCamera(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.image = editedImage;
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "tagSegue", sender: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber, locationName: String) {
        
        // pop the LocationsViewController from the view stack and show the PhotoMapViewController
        self.navigationController?.popViewController(animated: true)
        
        // Get the location coordinates from the Lat. and Long. passed from the delegate/protocol
        let locationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude));
        
        let annotation = PhotoAnnotation();
        
        // set the coordinates of that point using the coordinate defined above
        annotation.coordinate = locationCoordinate2D
        
         annotation.title = locationName;
        
        // add the annotation to the MKMapView
        annotation.append(annotation)
        
        mapView.addAnnotations(annotation);
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! LocationsViewController;
        vc.delegate = self;
        
    }
    }
    


