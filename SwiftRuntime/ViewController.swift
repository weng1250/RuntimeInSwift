//
//  ViewController.swift
//  SwiftRuntime
//
//  Created by weng on 2020/5/27.
//  Copyright © 2020 com.xxx. All rights reserved.
//

import UIKit

class ZLViewController: UIViewController {
    private var nameInMeituViewController: String?
}

class ViewController: ZLViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let list = self.mte_propertyList() {
            print(list)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    // MARK: - Private
    private var name: String?
    private var closureProperty: ((String)->Void)?
    private var computeProperty: Int {
        return 1
    }
} 

extension UIViewController: ZLSwiftRuntimable {
    
    private static let once: Void = {
        zl_swizzleMethod(cls: UIViewController.self,
                               originalSelector: #selector(viewWillAppear(_:)),
                               swizzledSelector: #selector(hook_viewWillAppear(_:)))
    }()
    
    public static func runAtLoad() {
        once
    }

    @objc func hook_viewWillAppear(_ animated: Bool) {
        print("hook_viewWillAppear:\(self.classForCoder)")
        
        hook_viewWillAppear(animated)
    }
}
