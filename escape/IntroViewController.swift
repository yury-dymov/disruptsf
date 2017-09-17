//
//  IntroViewController.swift
//  escape
//
//  Created by Yury Dymov on 9/16/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Lottie
import Cartography

class IntroViewController: UIViewController {
    public let titles = [
        "DURING EVACUATION HIGHWAYS ARE FULLY BLOCKED",
        "AVERAGE SPEED IS ALMOST 0",
        "IF WE REMOVE JUST 15% OF CARS",
        "REST 85% WILL GO 50+ MPH",
        "ESCAPE CAR POOL"
    ]
    public let stopFrames = [0, 120, 146, 247]
    let animation = LOTAnimationView(name: "intro")
    let logo = UIImageView(image: #imageLiteral(resourceName: "Logo"))
    
    private var _cur = 0
    
    private lazy var headerTitle: UILabel = {
        let ret = UILabel()
        
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 28)
        ret.textColor = .white
        ret.textAlignment = .center
        
        return ret
    }()
    
    private lazy var animHeaderTitle: UILabel = {
        let ret = UILabel()
        
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 28)
        ret.textColor = .white
        ret.textAlignment = .center
        
        return ret
        
    }()
    
    private lazy var subheaderTitle: UILabel = {
        let ret = UILabel()
        
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 24)
        ret.textColor = .white
        ret.textAlignment = .center
        
        return ret
    }()
    
    private lazy var nextButton: UIButton = {
        let ret = EButton()
        
        ret.alpha = 1.0
        ret.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        ret.titleLabel?.textAlignment = .center
        
        ret.layer.cornerRadius = 22
        ret.backgroundColor = UIColor("#33D4D4")
        ret.setTitleColor(.white, for: .normal)
        ret.setTitle("NEXT", for: .normal)
        
        ret.block_setAction(block: {[weak self] (btn) in
            btn.isEnabled = false
            
            guard let weakSelf = self else { return }
            
            
            if weakSelf._cur == weakSelf.stopFrames.count - 1 {
                weakSelf.navigationController?.pushViewController(MapViewController(), animated: true)
                
                return
            }
            
            weakSelf.animation.play(fromFrame: NSNumber(value: weakSelf.stopFrames[weakSelf._cur]), toFrame:
            NSNumber(value: weakSelf.stopFrames[weakSelf._cur + 1])) { (done) in
                if done {
                    btn.isEnabled = true
                    
                    if weakSelf._cur == weakSelf.stopFrames.count - 1 {
                        UIView.animate(withDuration: 0.6, animations: { 
                            weakSelf.animation.layer.opacity = 0
                            weakSelf.logo.layer.opacity = 1
                        })
                        
                        weakSelf.headerTitle.text = weakSelf.titles[4]
                        
                        UIView.animate(withDuration: 0.4, delay: 0.6, options: [], animations: {
                            weakSelf.subheaderTitle.layer.opacity = 1
                        }, completion: nil)
                    }
                }
            }

            
            weakSelf._cur += 1
            
            weakSelf.animHeaderTitle.text = weakSelf.titles[weakSelf._cur]
            weakSelf.animHeaderTitle.layoutSubviews()
            weakSelf.headerTitle.layoutSubviews()
            
            UIView.animate(withDuration: 0.4, delay: 0.6, options: [], animations: { 
                weakSelf.animHeaderTitle.layer.opacity = 1
                weakSelf.headerTitle.layer.opacity = 0
            }, completion: { (done) in
                if done {
                    weakSelf.headerTitle.text = weakSelf.animHeaderTitle.text
                    weakSelf.animHeaderTitle.layer.opacity = 0
                    weakSelf.animHeaderTitle.text = weakSelf.titles[weakSelf._cur + 1]
                    weakSelf.headerTitle.layer.opacity = 1
                }
            })
            
            
        }, for: .touchUpInside)
        
        
        return ret
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(headerTitle)
        self.view.addSubview(animHeaderTitle)
        self.view.addSubview(subheaderTitle)
        self.view.addSubview(animation)
        self.view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(nextButton)
        self.view.addSubview(logo)
        
        self.headerTitle.text = titles[0]
        self.animHeaderTitle.text = titles[1]
        self.subheaderTitle.text = "SAVING LIVES"
        self.subheaderTitle.layer.opacity = 0
        self.animHeaderTitle.layer.opacity = 0
        
        logo.layer.opacity = 0

        constrain(headerTitle) { t in
            t.left == t.superview!.left + 20
            t.right == t.superview!.right - 20
            t.top == t.superview!.top + 10
        }
        
        constrain(animHeaderTitle) { t in
            t.left == t.superview!.left + 20
            t.right == t.superview!.right - 20
            t.top == t.superview!.top + 10
        }
        
        constrain(subheaderTitle, headerTitle) { s, h in
            s.left == h.left
            s.right == h.right
            s.top == h.bottom + 10
        }
        
        constrain(animation) { an in
            an.top == an.superview!.top + 120
            an.left == an.superview!.left + 60
            an.right == an.superview!.right - 60
            an.bottom == an.superview!.bottom - 110
        }
        
        constrain(nextButton) { btn in
            btn.bottom == btn.superview!.bottom - 20
            btn.width == 240
            btn.height == 44
            btn.centerX == btn.superview!.centerX
        }
        
        constrain(logo) { logo in
            logo.width == 200
            logo.height == 200
            logo.centerX == logo.superview!.centerX
            logo.centerY == logo.superview!.centerY
        }
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
