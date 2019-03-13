//
//  ViewController.swift
//  Lab7
//
//  Created by Volodymyr Klymenko on 2019-03-13.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var latLabel: UILabel!
	@IBOutlet var lngLabel: UILabel!
	@IBOutlet var altLabel: UILabel!
	@IBOutlet var spdLabel: UILabel!
	@IBOutlet var courseLabel: UILabel!
	@IBOutlet var nearAddressLabel: UILabel!

	var locationManager: CLLocationManager!
	var speed: CLLocationSpeed = CLLocationSpeed()
	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
		mapView.showsUserLocation = true
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let userLocation: CLLocation = locations.last!

		let latitude = userLocation.coordinate.latitude
		let longitude = userLocation.coordinate.longitude
		let altitude = userLocation.altitude
		let speed = userLocation.speed
		let course = userLocation.course

		let longDelta = 0.05
		let latDelta = 0.05

		let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
		let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let region = MKCoordinateRegion(center: location, span: span)

		latLabel.text = "Latitude: \(latitude)"
		lngLabel.text = "Longitude: \(longitude)"
		altLabel.text = "Altitude: \(altitude)"
		spdLabel.text = "Speed: \(speed)"
		courseLabel.text = "Course: \(course)"

		self.mapView.setRegion(region, animated: true)
	}




}

