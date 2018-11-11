//
//  SearchBar.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/11/10.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation

extension UISearchBar {
    public func setSearchText(colour: UIColor) {
        let allSubviews = subviews.flatMap { $0.subviews }
        guard
            let searchTextField = allSubviews.filter({ $0 is UITextField }).first as? UITextField
            else { return }
        searchTextField.textColor = colour
    }
}
