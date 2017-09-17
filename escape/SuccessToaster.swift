//
//  SuccessToaster.swift
//  escape
//
//  Created by Vsevolod Brekelov on 9/16/17.
//  Copyright © 2017 Vsevolod Brekelov. All rights reserved.
//

import UIKit

public class SuccessToaster: NSObject, Toaster {
    private var _message: NSAttributedString
    
    public init(message: String) {
        self._message = NSAttributedString(string: message)
    }
    
    public init (attributedMessage: NSAttributedString) {
        self._message = attributedMessage
    }
    
    public func type() -> ToasterType {
        return .success
    }
    
    public func text() -> NSAttributedString {
        return _message
    }
    
    public func image() -> UIImage? {
        return nil
    }
    
    public func cancelButtonTitle() -> String {
        return "OK"
    }
    
    public func buttons() -> [UIButton]? {
        return nil
    }
    
}
