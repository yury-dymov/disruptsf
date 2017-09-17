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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animation = LOTAnimationView(name: "intro")
        
        self.view.addSubview(animation)
        self.view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        
        constrain(animation) { an in
            an.top == an.superview!.top + 120
            an.left == an.superview!.left + 20
            an.right == an.superview!.right - 20
            an.bottom == an.superview!.bottom - 80
        }
        
        
        animation.play(fromFrame: 0, toFrame: 100) { (done) in
            
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
