//
//  ZLSwiftRuntimable.swift
//  SwiftRuntime
//
//  Created by weng on 2020/5/27.
//  Copyright © 2020 com.xxx. All rights reserved.
//

import Foundation
import UIKit

public protocol ZLSwiftRuntimable {
    /// 需要动态注入的代码请写在runAtLoadxxx
    static func runAtLoad()
    
    /// 交换方法
    /// - Parameters:
    ///   - forClass: forClass description
    ///   - originalSelector: originalSelector description
    ///   - swizzledSelector: swizzledSelector description
    static func zl_swizzleMethod(cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector)
}

extension ZLSwiftRuntimable {
    public static func zl_swizzleMethod(cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
            let originalIMP = class_getMethodImplementation(cls, originalSelector),
            let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector),
            let swizzleIMP = class_getMethodImplementation(cls, swizzledSelector) else { return }
        // 避免有的类无imp
        class_addMethod(cls, originalSelector, originalIMP, method_getTypeEncoding(originalMethod))
        class_addMethod(cls, swizzledSelector, swizzleIMP, method_getTypeEncoding(swizzledMethod))
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

extension UIApplication {
    
    private static let runOnce: Void = {
        ZLLoadExcuteWrapper.excuteAllLoad()
    }()
    
    open override var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

fileprivate final class ZLLoadExcuteWrapper {
    fileprivate static func excuteAllLoad() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
         objc_getClassList(autoreleasingTypes, Int32(typeCount))
         for index in 0 ..< typeCount {
             (types[index] as? ZLSwiftRuntimable.Type)?.runAtLoad()
         }
         types.deallocate()
    }
}


