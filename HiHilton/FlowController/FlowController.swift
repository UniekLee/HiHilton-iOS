//
//  FlowController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import UIKit

public class FlowController: UIViewController, FlowControllable {
    weak var navController: UINavigationController?
    var childFlows: [FlowControllable] = []
    
    init(with nav: UINavigationController?) {
        navController = nav
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func start() {
        fatalError("Should be overriden in subclass")
    }
}

//extension FlowController {
//    func add(child flow: FlowController) {
//        childFlows.append(flow)
//    }
//
//    func remove(child flow: FlowController) {
//        guard let indexOfChildFlow = childFlows.index(where: { childFlow -> Bool in
//            let flowToCheck = childFlow as FlowController
//            return (flow == flowToCheck)
//        }) else { return }
//
//        childFlows.remove(at: indexOfChildFlow)
//    }
//}
