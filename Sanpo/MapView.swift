//
//  MapView.swift
//  Sanpo
//
//  Created by yas on 2020/04/21.
//  Copyright © 2020 yas. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let mapViewDelegate = MapViewDelegate()
    var coordinate: CLLocationCoordinate2D
    var checkPoints: [CheckPoint]
    @Binding var lastCheckPoint: CheckPoint?
    @Binding var shouldGoCurrent: Bool
    @Binding var shouldShowAllPins: Bool

    func makeUIView(context: Context) -> MKMapView {
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let map = MKMapView(frame: .zero)
        map.setRegion(region, animated: true)
        map.setUserTrackingMode(.follow, animated: true)
        map.delegate = mapViewDelegate
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if shouldGoCurrent {
            uiView.setCenter(coordinate, animated: true)
            DispatchQueue.global().async {
                self.shouldGoCurrent = false
            }
        }

        if shouldShowAllPins {
            uiView.removeOverlays(uiView.overlays)
            uiView.removeAnnotations(uiView.annotations)
            uiView.setUserTrackingMode(.none, animated: true)

            drawAllPins(mapView: uiView, checkpoints: checkPoints)
            
            DispatchQueue.global().async {
                self.shouldShowAllPins = false
            }
        } else {
            if self.checkPoints.isEmpty {
                uiView.removeOverlays(uiView.overlays)
                uiView.removeAnnotations(uiView.annotations)
            }

            if let lastCheckpoint = lastCheckPoint {
                uiView.setUserTrackingMode(.follow, animated: true)
                uiView.addAnnotation(lastCheckpoint)
                DispatchQueue.global().async {
                    self.lastCheckPoint = nil
                }
            }
        }
    }
}

extension MapView {
    
    private func drawAllPins(mapView: MKMapView, checkpoints: [CheckPoint]) {
        if checkpoints.isEmpty {
            return
        }

        var coordinates: [CLLocationCoordinate2D] = []
        for checkpoint in checkpoints {
            mapView.addAnnotation(checkpoint)
            coordinates.append(checkpoint.coordinate)
        }

        let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let rect = polyLine.boundingMapRect
        mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
        
    private func drawLinesAndRoutes(mapView: MKMapView, checkpoints: [CheckPoint]) {
        let lasts = checkpoints.suffix(2)
        guard let source = lasts.first, let destination = lasts.last else { return }
        
        if checkpoints.count == 1 {
            // ピンを表示
            mapView.addAnnotation(source)
        } else if checkpoints.count >= 2 {
            mapView.addAnnotation(destination)
            drawLines(mapView: mapView, source: source, destination: destination)
        }
    }
    
    private func drawLines(mapView: MKMapView, source: CheckPoint, destination: CheckPoint) {
        let coordinates = [source.coordinate, destination.coordinate]
        let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyLine, level: .aboveLabels)
    }
    
    private func drawRoutes(mapView: MKMapView, source: CheckPoint, destination: CheckPoint) {
        let sourcePlaceMark = MKPlacemark(coordinate: source.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destination.coordinate)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response, let route = directionResonse.routes.first else {
                if let error = error {
                    print("directionResonse error: \(error.localizedDescription)")
                }
                return
            }
            
            mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 4.0
        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
        return renderer
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {

        return MapView(coordinate: MockData.coordinate,
                       checkPoints: MockData.checkpoints,
                       lastCheckPoint: .constant(nil),
                       shouldGoCurrent: .constant(false),
                       shouldShowAllPins: .constant(true))
            .environment(\.colorScheme, .dark)
    }
}
