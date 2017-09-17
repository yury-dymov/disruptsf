//
//  EMClientHelper.swift
//  escape
//
//  Created by Yury Dymov on 9/16/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatDemoHelper: NSObject, EMClientDelegate, EMContactManagerDelegate, EMChatManagerDelegate, EMGroupManagerDelegate, EMChatroomManagerDelegate, EMCallManagerDelegate {
    
    static let shareHelper = EMChatDemoHelper()
    
    
    override init() {
        super.init()
        setupHelper()
    }
    
    public func noop() { }
    
    func setupHelper() {
        EMClient.shared().add(self, delegateQueue: nil)
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        EMClient.shared().groupManager.add(self, delegateQueue: nil)
        EMClient.shared().contactManager.add(self, delegateQueue: nil)
        EMClient.shared().roomManager.add(self, delegateQueue: nil)
        EMClient.shared().callManager.add!(self, delegateQueue: nil)
    }
    
    deinit {
        EMClient.shared().removeDelegate(self)
        EMClient.shared().chatManager.remove(self)
        EMClient.shared().groupManager.removeDelegate(self)
        EMClient.shared().contactManager.removeDelegate(self)
        EMClient.shared().roomManager.remove(self)
    }
    
    public func setupUntreatedApplyCount() {
    }
    
    // MARK: - EMClientDelegate
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        if aError == nil {
        } else {
            print(aError.description)
        }
    }
    
    // MARK: - EMChatManagerDelegate
    func conversationListDidUpdate(_ aConversationList: [Any]!) {
        print("cldu")
    }
    
    // MARK: - EMContactsManagerDelegate
    func friendRequestDidApprove(byUser aUsername: String!) {
        print("\(aUsername!)" + " agreed to add friends to apply")
    }
    
    func friendRequestDidDecline(byUser aUsername: String!) {
        print("\(aUsername!)" + " refuse to add friends to apply")
    }
    
    func friendshipDidRemove(byUser aUsername: String!) {
        print("\(aUsername!)" + " Delete")
    }
    
    func friendshipDidAdd(byUser aUsername: String!) {
        print("friendshipDidAdd")
    }
    
    func friendRequestDidReceive(fromUser aUsername: String!, message aMessage: String!) {
        print("friendRequestDidReceive")
        EMClient.shared().contactManager.acceptInvitation(forUsername: aUsername)
        /*
        if !EMApplyManager.defaultManager.isExisting(request: aUsername, nil, EMApplyStype.contact) {
            let model = EMApplyModel()
            model.applyHyphenateId = aUsername
            model.applyNickName = aUsername
            model.reason = aMessage
            model.style = EMApplyStype.contact
            EMApplyManager.defaultManager.addApplyRequest(model: model)
        }
        
        if mainVC != nil {
            setupUntreatedApplyCount()
            // TODO: send localNotification
        }
        
        contactsVC?.reloadContactRequests()
 */
    }
    
    // MARK: - EMGroupManagerDelegate
    func didLeave(_ aGroup: EMGroup!, reason aReason: EMGroupLeaveReason) {
        print("didLeave")
        /*
        var msgStr = ""
        if aReason == EMGroupLeaveReasonBeRemoved {
            msgStr = "Your are kicked out from group:" + aGroup.subject + "\([aGroup.groupId])"
        } else  if aReason == EMGroupLeaveReasonDestroyed {
            msgStr = "Group: " + aGroup.subject + " is destroyed"
        }
        
        if msgStr.characters.count > 0 {
            showAlert(msgStr)
        }
        
        let controllers = mainVC?.navigationController?.viewControllers
        var chatVC: EMChatViewController?
        for controller in controllers! {
            if (controller is EMChatViewController) {
                if (controller as! EMChatViewController)._conversationId == aGroup.groupId {
                    chatVC = controller as? EMChatViewController
                }
            }
        }
        
        if chatVC != nil {
            let viewControllers = NSMutableArray(array: controllers!)
            viewControllers.remove(chatVC!)
            if viewControllers.count > 0 {
                mainVC?.navigationController?.setViewControllers([viewControllers[0] as! UIViewController], animated: true)
            }else {
                mainVC?.navigationController?.setViewControllers(viewControllers as! [UIViewController], animated: true)
            }
        }
 */
    }
    
    func joinGroupRequestDidReceive(_ aGroup: EMGroup!, user aUsername: String!, reason aReason: String!) {
        print("joinGroupRequestDidReceive")
        /*
        if !EMApplyManager.defaultManager.isExisting(request: aUsername, aGroup.groupId, EMApplyStype.joinGroup) {
            let model = EMApplyModel()
            model.applyHyphenateId = aUsername
            model.applyNickName = aUsername
            model.groupId = aGroup.groupId
            model.groupSubject = aGroup.subject
            model.groupMemberCount = aGroup.occupantsCount
            model.reason = aUsername + " apply to join groups\'" + aGroup.subject + "\' " + aReason
            model.style = EMApplyStype.joinGroup
            EMApplyManager.defaultManager.addApplyRequest(model: model)
        }
        
        if mainVC != nil {
            setupUntreatedApplyCount()
        }
        
        contactsVC?.reloadContactRequests()
 */
    }
    
    func didJoin(_ aGroup: EMGroup!, inviter aInviter: String!, message aMessage: String!) {
        print(aInviter + " invite you to group " + aGroup.subject)
        //        let vcArt = mainVC?.navigationController?.viewControllers
        // TODO load group list
    }
    
    func joinGroupRequestDidDecline(_ aGroupId: String!, reason aReason: String!) {
        print("be refused to join the group " + aGroupId)
    }
    
    func joinGroupRequestDidApprove(_ aGroup: EMGroup!) {
        print("agreed to join the group of " + aGroup.subject)
    }
    
    func groupInvitationDidReceive(_ aGroupId: String!, inviter aInviter: String!, message aMessage: String!) {
        print("groupInvitationDidReceive")
        /*
        weak var weakSelf = self
        EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: aGroupId) { (group, error) in
            if !EMApplyManager.defaultManager.isExisting(request: aInviter, aGroupId, EMApplyStype.groupInvitation
                ) {
                let model = EMApplyModel()
                model.groupId = group?.groupId
                model.groupSubject = group?.subject
                model.reason = aMessage
                model.style = EMApplyStype.groupInvitation
                EMApplyManager.defaultManager.addApplyRequest(model: model)
            }
            
            if self.mainVC != nil {
                weakSelf?.setupUntreatedApplyCount()
            }
            
            weakSelf?.contactsVC?.reloadContactRequests()
        }
 */
    }
    
    func groupInvitationDidDecline(_ aGroup: EMGroup!, invitee aInvitee: String!, reason aReason: String!) {
        print("Group Notification", aInvitee + " decline to join the group " + aGroup.subject)
    }
    
    func groupInvitationDidAccept(_ aGroup: EMGroup!, invitee aInvitee: String!) {
        print("Group Notification", aInvitee + " has agreed to join the group " + aGroup.subject)
    }
    
    func groupMuteListDidUpdate(_ aGroup: EMGroup!, removedMutedMembers aMutedMembers: [Any]!) {
        print("groupMuteListDidUpdate")
        /*
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KEM_REFRESH_GROUP_INFO), object: aGroup)
        var msg = "Added to mute list: "
        for username in aMutedMembers as! [String] {
            msg = msg + " " + username
        }
        
        showAlert("Group Notification", msg)
 */
    }
    
    func groupMuteListDidUpdate(_ aGroup: EMGroup!, addedMutedMembers aMutedMembers: [Any]!, muteExpire aMuteExpire: Int) {
        print("groupMuteListDidUpdate")
        /*
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KEM_REFRESH_GROUP_INFO), object: aGroup)
        var msg = "Removed from mute list: "
        for username in aMutedMembers as! [String] {
            msg = msg + " " + username
        }
        
        showAlert("Group Notification", msg)
 */
    }
    
    func groupAdminListDidUpdate(_ aGroup: EMGroup!, addedAdmin aAdmin: String!) {
        print("groupAdminListDidUpdate")
        /*
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KEM_REFRESH_GROUP_INFO), object: aGroup)
        showAlert("Group Notification", aAdmin + " is upgraded to administrator")
 */
    }
    
    func groupAdminListDidUpdate(_ aGroup: EMGroup!, removedAdmin aAdmin: String!) {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue:KEM_REFRESH_GROUP_INFO), object: aGroup)
        print("Group Notification", aAdmin + " is downgraded to members")
    }
    
    func groupOwnerDidUpdate(_ aGroup: EMGroup!, newOwner aNewOwner: String!, oldOwner aOldOwner: String!) {
        print("Group Notification", "The group owner changed from " + aOldOwner + " to " + aNewOwner)
    }
    
    func userDidJoin(_ aGroup: EMGroup!, user aUsername: String!) {
        print("Group Notification", aUsername + " has joined to the group " + aGroup.subject)
    }
    
    func userDidLeave(_ aGroup: EMGroup!, user aUsername: String!) {
        print("Group Notification", aUsername + " has leaved from the group " + aGroup.subject)
    }
    
    func callDidReceive(_ aSession: EMCallSession!) {
        print("callDidReceive")
        // ToDo
        let _ = EMClient.shared().callManager.answerIncomingCall!(aSession.callId)
    }
    
    func callDidConnect(_ aSession: EMCallSession!) {
        print("callDidConnect")
        /*
         */
    }
    
    
    func callDidAccept(_ aSession: EMCallSession!) {
        print("callDidAccept")
        if let navController = UIApplication.shared.keyWindow?.rootViewController as?UINavigationController {
            if navController.topViewController?.classForCoder != ChatViewController.classForCoder() {
                navController.pushViewController(ChatViewController(chatSession: aSession), animated: true)
            }
        }
    }
    
    
    func callDidEnd(_ aSession: EMCallSession!, reason aReason: EMCallEndReason, error aError: EMError!) {
        if let error = aError {
            print(error.description)
        }
        print(aReason.rawValue)
        print("callDidEnd")
        
        if let navController = UIApplication.shared.keyWindow?.rootViewController as?UINavigationController {
            if navController.topViewController?.classForCoder == ChatViewController.classForCoder() {
                navController.popViewController(animated: true)
            }
        }

    }
    
    func callStateDidChange(_ aSession: EMCallSession!, type aType: EMCallStreamingStatus) {
        print("callStateDidChange")
        print(aType)
    }
    
    func callNetworkDidChange(_ aSession: EMCallSession!, status aStatus: EMCallNetworkStatus) {
        print("callNetworkDidChange")
    }
}
