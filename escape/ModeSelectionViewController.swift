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
    private lazy var timeToLeave: TimeInterval = {
        let leaveTime: TimeInterval = Date().timeIntervalSince1970 + 15 * 60
        
        for i in 0..<900 {
            if Int(floor(leaveTime + Double(i))) % 900 == 0 {
                return floor(leaveTime + Double(i))
            }
        }
        
        return leaveTime
    }()

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
        
        let image = #imageLiteral(resourceName: "Share").withRenderingMode(.alwaysTemplate)
        let icon = UIImageView(image: image)
        icon.tintColor = .white
        
        ret.addSubview(icon)
        
        constrain(icon) { i in
            i.top == i.superview!.top + 10
            i.centerX == i.superview!.centerX
            i.width == 100
            i.height == 100
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
        
        let image = #imageLiteral(resourceName: "Find").withRenderingMode(.alwaysTemplate)
        let icon = UIImageView(image: image)
        icon.tintColor = .white
        
        ret.addSubview(icon)
        
        constrain(icon) { i in
            i.top == i.superview!.top + 10
            i.centerX == i.superview!.centerX
            i.width == 100
            i.height == 100
        }        
        
        ret.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sel)))
        
        return ret
    }()
    
    private lazy var adultCount: UIView = {
        let ret = UIView()
        
        ret.isUserInteractionEnabled = true
        
        let img = UIImageView(image: #imageLiteral(resourceName: "Adults").withRenderingMode(.alwaysTemplate))
        
        img.tintColor = UIColor.white
        
        ret.layer.opacity = 0
        ret.addSubview(img)
        
        constrain(img) { i in
            i.left == i.superview!.left + 5
            i.width == 40
            i.height == 40
            i.top == i.superview!.top + 11
        }
        
        let cntLabel = UILabel()
        cntLabel.text = "1"
        cntLabel.font = UIFont.boldSystemFont(ofSize: 32)
        cntLabel.textColor = .white
        
        ret.addSubview(cntLabel)
        
        constrain(cntLabel, img) { l, i in
            l.width == 20
            l.height == 40
            l.top == i.top
            l.left == i.right + 12
        }
        
        let plusButton = UIButton()

        plusButton.setImage(#imageLiteral(resourceName: "Plus").withRenderingMode(.alwaysTemplate), for: .normal)
        plusButton.tintColor = .white
        
        ret.addSubview(plusButton)
        
        constrain(plusButton, cntLabel) { b, l in
            b.width == 40
            b.height == 40
            b.top == l.top
            b.left == l.right + 12
        }
        
        plusButton.block_setAction(block: { (_) in
            cntLabel.text = "2"
        }, for: .touchUpInside)
        
        let minusButton = UIButton()
        
        minusButton.setImage(#imageLiteral(resourceName: "Minus").withRenderingMode(.alwaysTemplate), for: .normal)
        minusButton.tintColor = .white
        
        ret.addSubview(minusButton)
        
        constrain(minusButton, plusButton) { b, l in
            b.width == 40
            b.height == 40
            b.top == l.top
            b.left == l.right + 24
        }
        
        return ret
    }()
    
    private lazy var childrenCount: UIView = {
        let ret = UIView()
        
        ret.layer.opacity = 0
        ret.isUserInteractionEnabled = true
        
        let img = UIImageView(image: #imageLiteral(resourceName: "Children").withRenderingMode(.alwaysTemplate))
        
        img.tintColor = UIColor.white
        
        ret.addSubview(img)
        
        constrain(img) { i in
            i.left == i.superview!.left + 5
            i.width == 40
            i.height == 40
            i.top == i.superview!.top + 11
        }
        
        let cntLabel = UILabel()
        cntLabel.text = "0"
        cntLabel.font = UIFont.boldSystemFont(ofSize: 32)
        cntLabel.textColor = .white
        
        ret.addSubview(cntLabel)
        
        constrain(cntLabel, img) { l, i in
            l.width == 20
            l.height == 40
            l.top == i.top
            l.left == i.right + 12
        }
        
        let plusButton = UIButton()
        
        plusButton.setImage(#imageLiteral(resourceName: "Plus").withRenderingMode(.alwaysTemplate), for: .normal)
        plusButton.tintColor = .white
        
        ret.addSubview(plusButton)
        
        constrain(plusButton, cntLabel) { b, l in
            b.width == 40
            b.height == 40
            b.top == l.top
            b.left == l.right + 12
        }
        
        let minusButton = UIButton()
        
        minusButton.setImage(#imageLiteral(resourceName: "Minus").withRenderingMode(.alwaysTemplate), for: .normal)
        minusButton.tintColor = .white
        
        ret.addSubview(minusButton)
        
        constrain(minusButton, plusButton) { b, l in
            b.width == 40
            b.height == 40
            b.top == l.top
            b.left == l.right + 24
        }
        
        return ret
    }()
    
    private lazy var timeView: UIView = {
        let ret = UIView()
        
        ret.layer.opacity = 0
        let icon = UIImageView(image: #imageLiteral(resourceName: "Clock").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .white
        
        ret.addSubview(icon)
        
        constrain(icon) { i in
            i.width == 40
            i.height == 40
            i.top == i.superview!.top + 10
            i.left == i.superview!.left + 5
        }
        
        
        let timeLabeL = UILabel()
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        timeLabeL.text = timeFormatter.string(from: Date(timeIntervalSince1970: self.timeToLeave))
        timeLabeL.font = UIFont.boldSystemFont(ofSize: 32)
        timeLabeL.textColor = .white
        
        ret.addSubview(timeLabeL)
        
        constrain(timeLabeL, icon) { l, i in
            l.width == 220
            l.height == 40
            l.top == i.top
            l.left == i.right + 12
        }

        
        return ret
    }()

    private lazy var nextButton: UIButton = {
        let ret = UIButton()
        
        ret.layer.opacity = 0.0
        ret.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        ret.titleLabel?.textAlignment = .center
        
        ret.layer.cornerRadius = 22
        ret.backgroundColor = UIColor("#33D4D4")
        ret.setTitleColor(.white, for: .normal)
        ret.setTitle("NEXT", for: .normal)
        
        ret.block_setAction(block: { [weak self] (_) in
            guard let weakSelf = self else { return }
            
            weakSelf.navigationController?.pushViewController(MapViewController(timeToLeave: weakSelf.timeToLeave), animated: true)
        }, for: .touchUpInside)
        
        return ret
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .black
        self.view.addSubview(titleLabel)
        self.view.addSubview(shareButton)
        self.view.addSubview(findButton)
        self.view.addSubview(adultCount)
        self.view.addSubview(childrenCount)
        self.view.addSubview(timeView)
        self.view.addSubview(nextButton)
        
        self.titleLabel.frame = CGRect(x: 0, y: -40, width: self.view.frame.size.width, height: 40)
        self.shareButton.frame = CGRect(x: -150, y: 120, width: 150, height: 150)
        self.findButton.frame = CGRect(x: self.view.frame.size.width, y: 120, width: 150, height: 150)
        self.nextButton.frame = CGRect(x: (self.view.frame.size.width - 240) / 2, y: self.view.frame.size.height, width: 240, height: 44)
        
        UIView.animate(withDuration: 0.2) { 
            self.titleLabel.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 40)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.shareButton.frame = CGRect(x: 17, y: 120, width: 150, height: 150)
            self.findButton.frame = CGRect(x: self.view.frame.size.width - 167, y: 120, width: 150, height: 150)
        }
        
        adultCount.frame = CGRect(x: 17 - 350, y: 300, width: 350 - 17, height: 60)
        childrenCount.frame = CGRect(x: 17 - 350, y: 390, width: 350 - 17, height: 60)
        timeView.frame = CGRect(x: 17 - 350, y: 480, width: 350 - 17, height: 60)
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
        
        UIView.animate(withDuration: 0.4) { 
            self.adultCount.frame = CGRect(x: 17, y: 300, width: 350 - 17, height: 60)
            self.adultCount.layer.opacity = 1
            self.childrenCount.frame = CGRect(x: 17, y: 390, width: 350 - 17, height: 60)
            self.childrenCount.layer.opacity = 1
            self.timeView.frame = CGRect(x: 17, y: 480, width: 350 - 17, height: 60)
            self.timeView.layer.opacity = 1
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.6, options: [], animations: { 
            self.nextButton.frame = CGRect(x: self.nextButton.frame.origin.x, y: self.view.frame.size.height - 44 - 20, width: 240, height: 44)
            self.nextButton.layer.opacity = 1
            
        }, completion: nil)
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
