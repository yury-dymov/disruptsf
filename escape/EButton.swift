//
//  EButton.swift
//  escape
//
//  Created by Yury Dymov on 9/17/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit

class EButton: UIButton {
    open override var isHighlighted: Bool {
        didSet {
            _update()
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            _update()
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            _update()
        }
    }
    
    private func _update() {
        let primary = UIColor("#33D4D4")
        
        if isHighlighted || isSelected {
            backgroundColor = UIColor("#38bdbd")
        } else if !isEnabled {
            backgroundColor = UIColor("#AAEDEE")
        } else {
            backgroundColor = primary
        }
    }
}
