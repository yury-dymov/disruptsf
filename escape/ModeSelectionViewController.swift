//
//  ModeSelectionViewController.swift
//  escape
//
//  Created by Yury Dymov on 9/17/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Cartography

class ModeSelectionViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let ret = UILabel()
        
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 28)
        ret.textColor = .white
        ret.textAlignment = .center
        ret.text = "I WANT TO"
        
        return ret
    }()
    
    private lazy var shareButton: UIView = {
        let ret = UIView()
        
        ret.layer.borderColor = UIColor.white.cgColor
        ret.layer.borderWidth = 1
        
        let lbl = UILabel()
        
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = "SHARE"
        lbl.textColor = .white
        
        ret.isUserInteractionEnabled = true
        
        ret.addSubview(lbl)
        
        constrain(lbl) { l in
            l.left == l.superview!.left + 10
            l.right == l.superview!.right - 10
            l.bottom == l.superview!.bottom - 10
        }
        
        return ret
    }()
    
    private lazy var findButton: UIView = {
        let ret = UIView()
        
        ret.layer.borderColor = UIColor.white.cgColor
        ret.layer.borderWidth = 1
        
        let lbl = UILabel()
        
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = "FIND"
        lbl.textColor = .white
        
        ret.isUserInteractionEnabled = true
        
        ret.addSubview(lbl)
        
        constrain(lbl) { l in
            l.left == l.superview!.left + 10
            l.right == l.superview!.right - 10
            l.bottom == l.superview!.bottom - 10
        }
        
        ret.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sel)))
        
        return ret
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .black
        self.view.addSubview(titleLabel)
        self.view.addSubview(shareButton)
        self.view.addSubview(findButton)
        
        self.titleLabel.frame = CGRect(x: 0, y: -40, width: self.view.frame.size.width, height: 40)
        self.shareButton.frame = CGRect(x: -150, y: 120, width: 150, height: 150)
        self.findButton.frame = CGRect(x: self.view.frame.size.width, y: 120, width: 150, height: 150)
        
        UIView.animate(withDuration: 0.2) { 
            self.titleLabel.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.shareButton.frame = CGRect(x: 17, y: 120, width: 150, height: 150)
            self.findButton.frame = CGRect(x: self.view.frame.size.width - 167, y: 120, width: 150, height: 150)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func sel() {
        self.findButton.layer.borderColor = UIColor("#33D4D4").cgColor
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
