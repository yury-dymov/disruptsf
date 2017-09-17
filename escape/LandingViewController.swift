//
//  LandingViewController.swift
//  escape
//
//  Created by Yury Dymov on 9/17/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Cartography

class LandingViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let ret = UILabel()
        
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 28)
        ret.textColor = .white
        ret.textAlignment = .center
        ret.text = "ESCAPE CAR POOL"
        
        return ret
    }()
    
    private lazy var nextButton: UIButton = {
        let ret = UIButton()
        
        ret.alpha = 1.0
        ret.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        ret.titleLabel?.textAlignment = .center
        
        ret.layer.cornerRadius = 22
        ret.backgroundColor = UIColor("#33D4D4")
        ret.setTitleColor(.white, for: .normal)
        ret.setTitle("NEXT", for: .normal)
        
        ret.block_setAction(block: {[weak self] (btn) in
            guard let weakSelf = self else { return }
            
            weakSelf.navigationController?.pushViewController(IntroViewController(), animated: false)
            
        }, for: .touchUpInside)
        
        
        return ret
    }()
    
    private lazy var skipTitle: UILabel = {
        let ret = UILabel()
        
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 12)
        ret.textColor = .white
        ret.textAlignment = .center
        ret.text = "SKIP INTRO"
        
        return ret
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let bgView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        
        self.view.addSubview(bgView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(nextButton)
        self.view.addSubview(skipTitle)
        self.view.backgroundColor = .black
        
        constrain(bgView) { v in
            v.centerX == v.superview!.centerX
            v.centerY == v.superview!.centerY
            v.width == 200
            v.height == 200
        }
        
        titleLabel.frame = CGRect(x: 0, y: -40, width: self.view.bounds.size.width, height: 40)
        titleLabel.layer.opacity = 0
        
        
        self.nextButton.frame = CGRect(x: (self.view.bounds.size.width - 240) / 2, y: self.view.bounds.size.height, width: 240, height: 44)
        self.skipTitle.frame = CGRect(x: 0, y: self.nextButton.frame.origin.y + self.nextButton.frame.size.height, width: self.view.bounds.size.width, height: 30)
        
        nextButton.layer.opacity = 0
        skipTitle.layer.opacity = 0
        
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.frame = CGRect(x: 0, y: 100, width: self.titleLabel.bounds.size.width, height: 40)
            self.titleLabel.layer.opacity = 1
        }
        
        UIView.animate(withDuration: 0.4) {
            self.nextButton.frame = CGRect(x: (self.view.bounds.size.width - 240) / 2, y: self.view.bounds.size.height - 150, width: 240, height: 44)
            self.skipTitle.frame = CGRect(x: 0, y: self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 10, width: self.view.bounds.size.width, height: 30)
            self.nextButton.layer.opacity = 1
            self.skipTitle.layer.opacity = 1
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
