//
//  ChatViewController.swift
//  escape
//
//  Created by Yury Dymov on 9/16/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Hyphenate
import Cartography

class ChatViewController: UIViewController {
    let chatSession: EMCallSession
    
    public lazy var dropPhoneButton: UIButton = {
        let ret = UIButton()
        
        ret.setImage(#imageLiteral(resourceName: "Hang"), for: .normal)
        ret.layer.cornerRadius = 32
        ret.layer.borderColor = UIColor("#e9210c").cgColor
        ret.layer.borderWidth = 1
        
        ret.block_setAction(block: { [weak self] (btn) in
            btn.isEnabled = false
            
            guard let weakSelf = self else { return }
            
            let _ = EMClient.shared().callManager.endCall!(weakSelf.chatSession.callId, reason: EMCallEndReasonHangup)
            
            weakSelf.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        
        return ret
    }()
    
    init(chatSession: EMCallSession) {
        self.chatSession = chatSession
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chatSession.remoteVideoView = EMCallRemoteView(frame: self.view.bounds)
        chatSession.localVideoView = EMCallLocalView(frame: CGRect(x: 0, y: 0, width: 100, height: 132))
        
        self.view.addSubview(chatSession.remoteVideoView)
        self.view.addSubview(chatSession.localVideoView)
        self.view.addSubview(dropPhoneButton)
        self.navigationController?.isNavigationBarHidden = true
        
        chatSession.localVideoView.layer.borderWidth = 2
        chatSession.localVideoView.layer.cornerRadius = 8
        chatSession.localVideoView.layer.masksToBounds = true
        chatSession.localVideoView.layer.borderColor = UIColor("#33D4D4").cgColor
        
        constrain(chatSession.remoteVideoView) { v in
            v.edges == v.superview!.edges
        }
        
        constrain(chatSession.localVideoView) { v in
            v.left == v.superview!.left + 10
            v.top == v.superview!.top + 10
            v.width == 100
            v.height == 132
        }
        
        constrain(dropPhoneButton) { b in
            b.right == b.superview!.right - 20
            b.top == b.superview!.top + 20
            b.width == 64
            b.height == 64
        }
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
