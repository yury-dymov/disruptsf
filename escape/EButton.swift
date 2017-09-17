//
//  EButton.swift
//  escape
//
//  Created by Yury Dymov on 9/17/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit

enum EButtonStyle {
    case dark
    case light
}

class EButton: UIButton {
    let style: EButtonStyle
    
    public init(style: EButtonStyle = .dark) {
        self.style = style
        
        super.init(frame: .zero)
        _update()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        if style == .dark {
            if isHighlighted || isSelected {
                backgroundColor = UIColor("#38bdbd")
            } else if !isEnabled {
                backgroundColor = UIColor("#AAEDEE")
            } else {
                backgroundColor = primary
            }
        } else {
            setTitleColor(primary, for: .normal)
            layer.borderColor = primary.cgColor
            layer.borderWidth = 1

            if isHighlighted || isSelected {
                backgroundColor = primary
                setTitleColor(.white, for: .normal)
            } else if !isEnabled {
                backgroundColor = UIColor("#AAEDEE")
            } else {
                backgroundColor = .white
            }
        }
    }
    
}
