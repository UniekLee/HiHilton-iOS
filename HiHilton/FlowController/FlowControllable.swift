//
//  FlowControllable.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation

protocol FlowControllable: AnyObject {
    var childFlows: [FlowControllable] { get set }
    var navController: UINavigationController? { get set }
    
    func start()
}

extension FlowControllable {
    func add(childFlow: FlowControllable) {
        childFlows.append(childFlow)
    }
    
    func remove(childFlow: FlowControllable) {
        if let indexOfChild = childFlows.index(where: { $0 === childFlow }) {
            childFlows.remove(at: indexOfChild)
        }
    }
}
