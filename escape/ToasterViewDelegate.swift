//
//  ToasterViewDelegate.swift
//  escape
//
//  Created by Vsevolod Brekelov on 9/16/17.
//  Copyright © 2017 Vsevolod Brekelov. All rights reserved.
//

import UIKit

public protocol ToasterViewDelegate: class {
    func close(_ toasterView: ToasterView)
}

