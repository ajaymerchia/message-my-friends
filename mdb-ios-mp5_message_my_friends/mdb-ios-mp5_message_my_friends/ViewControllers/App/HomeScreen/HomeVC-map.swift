//
//  HomeVC-map.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import MapKit
import CoreLocation

extension HomeVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func initMap() {
        mapview = MKMapView(frame: CGRect(x: 0, y: trueTop, width: view.frame.width, height: trueHeight/2.5))
        mapview.delegate = self
        mapview.showsUserLocation = true
        mapview.setUserTrackingMode(.follow, animated: true)
        view.addSubview(mapview)
        
        self.addOtherUsers()
        
        
//        addRecenter()
    }
    
    func addRecenter() {
        
        
//        recenterButton = UIButton(frame: CGRect(x: mapview.frame.maxX - recenterSize * 1.2 * .PADDING, y: mapview.frame.maxY - recenterSize * 1.2 * .PADDING, width: recenterSize * .PADDING, height: recenterSize * .PADDING))
        recenterButton.setImage(UIImage(named: "recenter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        recenterButton.tintColor = borderColor
        recenterButton.layer.backgroundColor = UIColor.white.cgColor
        recenterButton.layer.cornerRadius = recenterButton.frame.width/2
        let insetamt:CGFloat = 3
        recenterButton.imageEdgeInsets = UIEdgeInsets(top: insetamt, left: insetamt, bottom: insetamt, right: insetamt)
        
        recenterButton.imageView?.layer.cornerRadius = .PADDING/2
        recenterButton.imageView?.contentMode = .scaleAspectFit
        recenterButton.addTarget(self, action: #selector(recenter), for: .touchUpInside)
        view.addSubview(recenterButton)
    }
    
    @objc func recenter() {
        guard let latMax = mapview.annotations.map({ (annotation) -> Double in return annotation.coordinate.latitude}).max() else { return }
        guard let latMin = mapview.annotations.map({ (annotation) -> Double in return annotation.coordinate.latitude}).min() else { return }
        
        guard let lonMax = mapview.annotations.map({ (annotation) -> Double in return annotation.coordinate.longitude}).max() else { return }
        guard let lonMin = mapview.annotations.map({ (annotation) -> Double in return annotation.coordinate.longitude}).min() else { return }
        
        let regionMultiple: Double = 2
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (latMax + latMin)/2, longitude: (lonMax + lonMin)/2), span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(exactly: regionMultiple * (latMax - latMin))!, longitudeDelta: CLLocationDegrees(exactly: regionMultiple * (lonMax - lonMin))!))
        
        mapview.setRegion(region, animated: true)
        
    }
    
    func addOtherUsers() {
        mapview.removeAnnotations(mapview.annotations)
        
        for friend in self.user.friends.values {
            if self.user.friendStatuses[friend.uid] == "hiding" { continue }
            
            var friendAnnotation = MKPointAnnotation()
            guard let location = friend.lastUpdate else { continue }
            
            friendAnnotation.coordinate = location.coordinate
            friendAnnotation.title = friend.fullname
            let oldNess = Date().timeIntervalSince(location.timestamp)
            
            if oldNess < 60 {
                friendAnnotation.subtitle = "updated \(Int(oldNess)) seconds ago"
            } else if oldNess < 60 * 60 {
                friendAnnotation.subtitle = "updated \(Int(oldNess/60)) minutes ago"
            } else {
                friendAnnotation.subtitle = "updated \(Int(oldNess/60 / 60)) hours ago"
            }
            
            mapview.addAnnotation(friendAnnotation)
            
        }
        recenter()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        
        let reuseId = "team"
        let anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        anView.annotation = annotation
        
        
        if let user = getFriendFor(annotation: annotation) {
            
            let sizeOfView: CGFloat = 40
            let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: sizeOfView, height: sizeOfView))
            shadowView.layer.shadowColor = UIColor.DARK_BLUE.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
            shadowView.layer.shadowOpacity = 0.65
            shadowView.layer.shadowRadius = 1.0
            shadowView.clipsToBounds = false
            
            
            let imageView = UIImageView(frame: shadowView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.clipsToBounds = true
            imageView.image = user.photo
            
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 1
            
            
            shadowView.addSubview(imageView)
            anView.addSubview(shadowView)
            anView.sendSubviewToBack(shadowView)

            anView.frame = shadowView.bounds
            anView.calloutOffset = CGPoint(x: 0, y: -sizeOfView/2)
        }
        
        
        anView.canShowCallout = true
        anView.rightCalloutAccessoryView = UIButton(type: .infoDark)
    
        return anView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        guard let friend = getFriendFor(annotation: annotation) else { return }
        guard let location = friend.lastUpdate else { return }
        
        let radius = location.horizontalAccuracy
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: radius * 3, longitudinalMeters: radius * 3), animated: true)
        
        userLocationAccuracyCircle = MKCircle(center: annotation.coordinate, radius: radius)
        mapView.addOverlay(userLocationAccuracyCircle!)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let circle = userLocationAccuracyCircle {
            mapView.removeOverlay(circle)
            collapseMap()
            recenter()
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle )
            renderer.fillColor = borderColor
            renderer.alpha = 0.3
            return renderer
            
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func getFriendFor(annotation: MKAnnotation) -> User? {
        guard let nameOfFriend = annotation.title else {
            return nil
        }
        
        for friend in self.user.friends.values {
            if friend.fullname == nameOfFriend {
                return friend
            }
        }
        
        return nil
        
    }


}
