//
//  Toaster.swift
//  escape
//
//  Created by Vsevolod Brekelov on 9/16/17.
//  Copyright © 2017 Vsevolod Brekelov. All rights reserved.
//

import UIKit

public protocol Toaster: class {
    func text() -> NSAttributedString
    func cancelButtonTitle() -> String
    func image() -> UIImage?
    func type() -> ToasterType
    func buttons () -> [UIButton]?
}

