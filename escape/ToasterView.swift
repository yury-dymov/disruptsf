//
//  ToasterView.swift
//  escape
//
//  Created by Vsevolod Brekelov on 9/16/17.
//  Copyright © 2017 Vsevolod Brekelov. All rights reserved.
//

import UIKit
import Cartography

public enum ToasterType {
    case normal
    case success
}

open class ToasterView: UIView {
    public weak var delegate: ToasterViewDelegate?
    
    public lazy var imageView: UIImageView = {
        return UIImageView()
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor("#333333")
        
        return label
    }()
    
    public lazy var closeButton: UIButton = {
        let ret = UIButton(type: .custom)
        
        ret.setTitleColor(UIColor("#33d4d4"), for: .normal)
        ret.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        ret.layer.borderWidth = 0
        ret.backgroundColor = UIColor.clear
        
        ret.block_setAction(block: { (btn) in
            self.delegate?.close(self)
        }, for: .touchUpInside)
        
        return ret
    }()
    
    
    public lazy var separator: UIView = {
        let ret = UIView(frame: CGRect.zero)
        
        ret.backgroundColor = UIColor("#FEFEFE")
        
        return ret
    }()
    
    public lazy var typeView: UIView = {
        return UIView()
    }()
    
    public var buttons: [UIButton]?
    
    private var _type: ToasterType?
    
    public var type:ToasterType? {
        get {
            return self._type
        }
        set {
            
            self._type = newValue
            if (newValue == nil) {
                self.typeView.backgroundColor = UIColor.clear
                return
            }
            
            switch newValue! {
            case .normal:
                self.typeView.backgroundColor = UIColor.clear
            case .success:
                self.typeView.backgroundColor = UIColor("#33d4d4")
            }
        }
    }
    
    public lazy var containerView: UIView = {
        let ret = UIView()
        
        ret.clipsToBounds = true
        ret.layer.borderWidth = 1
        ret.layer.borderColor = UIColor("#FEFEFE").cgColor
        
        return ret
    }()
    
    private var _shadowLayer: CAShapeLayer?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if (imageView.superview == nil) {
            self.addSubview(containerView)
            containerView.addSubview(typeView)
            containerView.addSubview(imageView)
            containerView.addSubview(titleLabel)
            containerView.addSubview(closeButton)
            containerView.addSubview(separator)
            
            let hasImage = imageView.image != nil
            
            let w = imageView.image?.size.width ?? 0
            let h = imageView.image?.size.height ?? 0
            
            constrain(containerView) { containerView in
                containerView.left == containerView.superview!.left
                containerView.top == containerView.superview!.top
                containerView.width == containerView.superview!.width
                containerView.height == containerView.superview!.height
            }
            
            constrain(typeView, imageView, titleLabel, closeButton, separator) { (typeView, imageView, titleLabel, closeButton, separator) in
                typeView.left == typeView.superview!.left
                typeView.top == typeView.superview!.top
                typeView.bottom == typeView.superview!.bottom
                typeView.width == 8
                
                if (hasImage) {
                    imageView.left == typeView.right + 10
                    imageView.top == imageView.superview!.top + 10
                    imageView.width == w
                    imageView.height == h
                }
                
                closeButton.right == closeButton.superview!.right - 10
                closeButton.centerY == closeButton.superview!.centerY
                closeButton.width == 60
                closeButton.left == separator.right + 10
                
                if (hasImage) {
                    titleLabel.left == imageView.right + 10
                } else {
                    titleLabel.left == typeView.right + 10
                }
                
                titleLabel.top == titleLabel.superview!.top + 10
                titleLabel.right == separator.left - 10
                titleLabel.height >= 21
                titleLabel.bottom == titleLabel.superview!.bottom - 10
                
                separator.top == separator.superview!.top + 10
                separator.bottom == separator.superview!.bottom - 10
                separator.width == 1
            }
            
            var prevView: UIView? = nil
            
            for btn in (buttons ?? []) {
                self.addSubview(btn)
                
                if (prevView == nil) {
                    constrain(titleLabel, btn) { (titleLabel, btn) in
                        btn.top == titleLabel.bottom + 10
                        btn.left == titleLabel.left
                        btn.height >= 30
                        btn.bottom == btn.superview!.bottom - 10
                    }
                } else {
                    constrain(prevView!, btn) { (prevView, btn) in
                        btn.top == prevView.top
                        btn.left == prevView.right + 10
                    }
                }
                
                prevView = btn
            }
        }
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor("#FEFEFE").cgColor
        
        _shadowLayer?.removeFromSuperlayer()
        
        _shadowLayer = CAShapeLayer()
        _shadowLayer!.path = UIBezierPath(roundedRect: bounds, cornerRadius: 4).cgPath
        _shadowLayer!.fillColor = UIColor.white.cgColor
        
        _shadowLayer!.shadowColor = UIColor.darkGray.cgColor
        _shadowLayer!.shadowPath = _shadowLayer!.path
        _shadowLayer!.shadowOffset = CGSize(width: 4.0, height: 4.0)
        _shadowLayer!.shadowOpacity = 0.6
        _shadowLayer!.shadowRadius = 4
        
        self.layer.insertSublayer(_shadowLayer!, at: 0)
        
        _shadowLayer!.masksToBounds = false
        self.layer.masksToBounds = false
    }
    
    public static func fromToaster(_ toaster: Toaster) -> ToasterView {
        let ret = ToasterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 44))
        
        ret.imageView.image = toaster.image()
        ret.titleLabel.attributedText = toaster.text()
        ret.closeButton.setTitle(toaster.cancelButtonTitle(), for: .normal)
        ret.type = toaster.type()
        ret.buttons = toaster.buttons()
        
        return ret
    }
    
}

