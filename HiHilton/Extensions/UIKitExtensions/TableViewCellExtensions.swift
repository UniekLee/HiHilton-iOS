//
//  TableViewCellExtensions.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit

extension UITableViewCell: NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self.self), bundle: HiHilton)
    }
}
