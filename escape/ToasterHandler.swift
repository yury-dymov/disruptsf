//
//  ToasterHandler.swift
//  escape
//
//  Created by Vsevolod Brekelov on 9/16/17.
//  Copyright © 2017 Vsevolod Brekelov. All rights reserved.
//

import UIKit
import Cartography

extension Array where Element: AnyObject {
    mutating func remove(object: Element) {
        if let index = index(where: { $0 === object }) {
            remove(at: index)
        }
    }
}

public class ToasterHandler: NSObject, ToasterViewDelegate {
    
    public static let shared = ToasterHandler()
    
    private var _activeToasters: [ToasterView] = []
    private var _activeToastersTopConstraint: [ConstraintGroup] = []
    
    
    public func showToaster(_ toaster: Toaster) {
        let view = ToasterView.fromToaster(toaster)
        
        view.delegate = self
        
        UIApplication.shared.keyWindow!.addSubview(view)
        
        let height: CGFloat = (toaster.buttons() == nil || toaster.buttons()!.count == 0) ? 57 : 75
        
        constrain(view) { view in
            view.width == view.superview!.width - 30 ~ 999.0
            view.width <= 350
            view.height >= height
        }
        
        let group = ConstraintGroup()
        
        constrain(view, replace: group) { view in
            view.left == view.superview!.right
            view.top == view.superview!.top + 45
        }
        
        view.superview!.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            constrain(view, replace: group) { view in
                view.right == view.superview!.right - 15
                view.top == view.superview!.top + 45
            }
            
            var prev = view
            
            for (index, toaster) in self._activeToasters.reversed().enumerated() {
                let group = self._activeToastersTopConstraint[self._activeToastersTopConstraint.count - index - 1]
                
                constrain(toaster, prev, replace: group) { view, prev in
                    view.right == view.superview!.right - 15
                    view.top == prev.bottom + 10
                }
                
                prev = toaster
            }
            
            view.superview!.layoutIfNeeded()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
                self.close(view)
            })
            
            self._activeToasters.append(view)
            self._activeToastersTopConstraint.append(group)
        }, completion: nil
        )
    }
    
    public func close(_ toasterView: ToasterView) {
        var index = -1
        
        for (idx, elem) in self._activeToasters.enumerated() {
            if (elem == toasterView) {
                index = idx
                break
            }
        }
        
        if (index == -1) {
            return
        }
        
        _activeToastersTopConstraint.remove(at: index)
        _activeToasters.remove(at: index)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            toasterView.layer.opacity = 0
            
            var prev: UIView? = nil
            
            for (tindx, toaster) in self._activeToasters.reversed().enumerated() {
                let group = self._activeToastersTopConstraint[self._activeToastersTopConstraint.count - tindx - 1]
                
                if (prev == nil) {
                    constrain(toaster, replace: group) { view in
                        view.right == view.superview!.right - 15
                        view.top == view.superview!.top + 45
                    }
                } else {
                    constrain(toaster, prev!, replace: group) { view, prev in
                        view.right == view.superview!.right - 15
                        view.top == prev.bottom + 10
                    }
                }
                
                prev = toaster
            }
            
            toasterView.superview?.layoutIfNeeded()
        }, completion: { (done) in
            if (done) {
                toasterView.removeFromSuperview()
            }
        })
    }
}

