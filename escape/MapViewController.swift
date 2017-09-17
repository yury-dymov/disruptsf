//
//  ViewController.swift
//  escape
//
//  Created by Yury Dymov on 9/16/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import ArcGIS
import Cartography
import Hyphenate

enum MarkerType {
    case me
    case available
    case selected
    case block
}

extension AGSPoint {
    private func _markerImage(type: MarkerType) -> UIImage {
        switch type {
        case .me:
            return #imageLiteral(resourceName: "Marker").resize(newWidth: 90)
        case .available:
            return #imageLiteral(resourceName: "MarkerAvailable").resize(newWidth: 90)
        case .selected:
            return #imageLiteral(resourceName: "MarkerSelected").resize(newWidth: 90)
        case .block:
            return #imageLiteral(resourceName: "Block").resize(newWidth: 45)
        }
    }
    
    
    func marker(type: MarkerType) -> AGSGraphic {
        let markerImage = _markerImage(type: type)
        let symbol = AGSPictureMarkerSymbol(image: markerImage)
        
        symbol.leaderOffsetY = markerImage.size.height / 4
        symbol.offsetY = markerImage.size.height / 4
        
        return AGSGraphic(geometry: self, symbol: symbol, attributes: nil)
    }
}

class MapViewController: UIViewController, AGSGeoViewTouchDelegate, AGSCalloutDelegate {
    public init(timeToLeave: TimeInterval = 0) {
        self.timeToLeave = timeToLeave
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var origin: AGSPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7758293, -122.3863622))
    
    private lazy var points: [AGSPoint] = [
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7718412, -122.393519)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7788752, -122.394988)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7814721, -122.389245))
    ]
    
    private lazy var blocks: [AGSPoint] = [
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.775040, -122.392419)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.776779, -122.390273))
    ]
    
    private lazy var route: [AGSPoint] = [
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7758293, -122.3863622)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.775468, -122.387665)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.772166, -122.386995)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7718412, -122.393519)),
    ]
    
    private lazy var center: AGSPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7769039, -122.3904595)) // SF Pier 48
    private lazy var mapView: AGSMapView = {
        let ret = AGSMapView()
        
        ret.map = AGSMap(basemapType: .darkGrayCanvasVector, latitude: self.center.x, longitude: self.center.y, levelOfDetail: 10)
        ret.touchDelegate = self
        
        return ret
    }()
    
    private lazy var graphicsOverlay: AGSGraphicsOverlay = {
        let ret = AGSGraphicsOverlay()
        
        ret.graphics.add(self.origin.marker(type: .me))
        
        return ret
    }()
    
    let routeGraphicsOverlay = AGSGraphicsOverlay()
    
    private var tapTimer: TimeInterval = 0
    private var animationFinished: Bool = false
    private let timeToLeave: TimeInterval
    
    public lazy var routeButton: UIButton = {
        let ret = EButton(style: .light)
        
        ret.setImage(#imageLiteral(resourceName: "Route"), for: .normal)
        ret.layer.cornerRadius = 8
        ret.layer.masksToBounds = true
        ret.isHidden = true
        ret.block_setAction(block: { (btn) in
            btn.isSelected = !btn.isSelected            
            
            if btn.isSelected {
                btn.isEnabled = false
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    self.routeGraphicsOverlay.isVisible = true
                    btn.isEnabled = true
                })
            } else {
                self.routeGraphicsOverlay.isVisible = false
            }
        }, for: .touchUpInside)
        
        return ret
    }()
    
    public lazy var messageChatButton: UIButton = {
        let ret = EButton(style: .light)
        
        ret.setImage(#imageLiteral(resourceName: "chat-bubble-icon").resize(newWidth: 20), for: .normal)
        ret.layer.cornerRadius = 8
        ret.layer.masksToBounds = true
        ret.isHidden = true
        
        return ret
    }()
    
    public lazy var videoChatButton: UIButton = {
        let ret = EButton(style: .light)
        
        ret.setImage(#imageLiteral(resourceName: "camera-icon").resize(newWidth: 21), for: .normal)
        ret.layer.cornerRadius = 8
        ret.layer.masksToBounds = true
        ret.isHidden = true
        ret.block_setAction(block: { (_) in
            if AppDelegate.build == "yury" {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    EMClient.shared().callManager.start!(EMCallTypeVideo, remoteName: AppDelegate.other, ext: "") { (session, error) in }
                })
            }
            
        }, for: .touchUpInside)
        
        return ret
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        
        self.title = "Pick Location"
        self.view.addSubview(mapView)
        self.mapView.setViewpoint(AGSViewpoint(center: self.center, scale: 12000.0), duration: 4.0)
        self.mapView.graphicsOverlays.add(self.graphicsOverlay)
        self.mapView.graphicsOverlays.add(self.routeGraphicsOverlay)
        
        /*
        let filterView = UIImageView(image: #imageLiteral(resourceName: "Filter"))
        
        self.view.addSubview(filterView)
        
        constrain(filterView) { f in
            f.centerX == f.superview!.centerX
            f.top == f.superview!.top + 40
            f.width == 175
            f.height == 30
        }*/
        
        points.forEach({ (pnt) in
            let marker = pnt.marker(type: .available)
            
            marker.isVisible = false
            
            self.graphicsOverlay.graphics.add(marker)
        })
        
        blocks.forEach({ (pnt) in
            let marker = pnt.marker(type: .block)
            
            marker.isVisible = false
            
            self.graphicsOverlay.graphics.add(marker)
        })
        
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { [weak self] (tm) in
            guard let weakSelf = self else { return tm.invalidate() }
            
            weakSelf.graphicsOverlay.graphics.forEach({ (el) in
                if let elem = el as? AGSGraphic {
                    elem.isVisible = true
                }
            })
                        
            weakSelf.animationFinished = true
        }
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
        
        routeGraphicsOverlay.isVisible = false
        routeGraphicsOverlay.graphics.add(AGSGraphic(geometry: AGSPolyline(points: route), symbol: AGSSimpleLineSymbol(style: .solid, color: UIColor.yellow, width: 5), attributes: nil))
        
        
        self.view.addSubview(routeButton)
        
        let bSize: CGFloat = 44
        
        constrain(routeButton) { b in
            b.width == bSize
            b.height == bSize
            b.right == b.superview!.right - 10
            b.top == b.superview!.top + 110
        }
        
        self.view.addSubview(messageChatButton)
        
        constrain(messageChatButton, routeButton) { b, pv in
            b.width == bSize
            b.height == bSize
            b.right == b.superview!.right - 10
            b.top == pv.bottom + 20
        }
        
        self.view.addSubview(videoChatButton)
        
        constrain(videoChatButton, messageChatButton) { b, pv in
            b.width == bSize
            b.height == bSize
            b.right == b.superview!.right - 10
            b.top == pv.bottom + 20
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    private var _timeString: String {
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        return timeFormatter.string(from: Date(timeIntervalSince1970: timeToLeave))
    }
    
    /*
    func _findNearest(_ point: AGSPoint) -> Int {
        let distances = points.map { (pnt) -> Double in
            return (pnt.x - point.x) * (pnt.x - point.x) + (pnt.y - point.y) * (pnt.y - point.y)
        }
        
        return distances.index(of: distances.min()!) ?? 0
    }
 */
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        if !animationFinished || (tapTimer != 0 && Date().timeIntervalSince1970 - tapTimer < 2) {
            return
        }
        
        tapTimer = Date().timeIntervalSince1970
        
        // let nearest = _findNearest(mapPoint)
        
        if self.mapView.callout.isHidden {
            self.mapView.callout.image = #imageLiteral(resourceName: "Seva")
            self.mapView.callout.title = "Seva Brekelov"
            
            self.mapView.callout.detail = "3 spaces / " + _timeString
            self.mapView.callout.isAccessoryButtonHidden = false
            self.mapView.callout.accessoryButtonImage = #imageLiteral(resourceName: "Checkmark")
            self.mapView.callout.delegate = self
            self.mapView.callout.tintColor = UIColor("#33d4d4")
            self.mapView.callout.show(at: mapPoint, screenOffset: .zero, rotateOffsetWithMap: false, animated: true)
        } else {
            self.mapView.callout.isHidden = true
            tapTimer = 0
        }
    }
    
    public func didTapAccessoryButton(for callout: AGSCallout) {
        graphicsOverlay.graphics.removeAllObjects()
        graphicsOverlay.graphics.add(points[0].marker(type: .selected))
        graphicsOverlay.graphics.add(origin.marker(type: .me))
        blocks.forEach({ (pnt) in
            let marker = pnt.marker(type: .block)
            
            self.graphicsOverlay.graphics.add(marker)
        })
        
        self.mapView.callout.isHidden = true
        ToasterHandler.shared.showToaster(SuccessToaster(message: "Congratulations! You are going with Seva now!"))
            
        self.animationFinished = false // don't want to accidentally go to the same pattern
        messageChatButton.isHidden = false
        routeButton.isHidden = false
        videoChatButton.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] tm in
            guard let weakSelf = self else { return tm.invalidate() }
            
            let timeFormatter = DateFormatter()
            
            timeFormatter.dateFormat = "m:ss"
            
            let elapsedTime = weakSelf.timeToLeave - Date().timeIntervalSince1970
            
            if elapsedTime <= 0 {
                weakSelf.title = "Hurry Up!"
                tm.invalidate()
                
                return
            }
            
            weakSelf.title = "Go to Seva (" + timeFormatter.string(from: Date(timeIntervalSince1970: elapsedTime)) + ")"
        })
    }

}

