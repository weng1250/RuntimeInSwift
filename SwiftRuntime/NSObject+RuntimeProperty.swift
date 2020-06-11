//
//  NSObject+Runtime.swift
//  SwiftRuntime
//
//  Created by weng on 2020/5/27.
//  Copyright © 2020 com.xxx. All rights reserved.
//

import Foundation


extension NSObject {
    
    /// 利用swift的反射获取属性列表，由于反射需要传入instance，所以这是个实例方法
    ///
    /// - Parameter exceptionList: 白名单，在白名单内不会被返回
    /// - Returns: return value description
    func mte_propertyList(_ exceptionList: Set<String>? = nil) -> [String]? {
        let mirror = Mirror.init(reflecting: self)
        var propertyList: [String] = []
        for (property_, _) in mirror.children {
            guard let property = property_ else { continue }
            if let exceptionList = exceptionList, exceptionList.contains(property) { continue }
            propertyList.append(property)
        }
        return propertyList.count > 0 ? propertyList : nil
    }
    
    /// 获取属性列表以及属性值，属性值即使为nil也会出现在列表中
    ///
    /// - Parameter exceptionList: 白名单，在白名单内不会被返回
    /// - Returns: return value description
    func mte_propertyListAndValues(_ exceptionList: Set<String>? = nil) -> [String: Any?]? {
        let mirror = Mirror.init(reflecting: self)
        var propertyListAndValues: [String: Any?] = [:]
        for (property_, _) in mirror.children {
            guard let property = property_ else { continue }
            if let exceptionList = exceptionList, exceptionList.contains(property) { continue }
            /// bugfix 个别情况下value值会始终为nil，比如遇到Realm的基类派生出的子类会导致反射出来的value值全部为空，这里手动修复value值
            let newValue = self.value(forKey: property)
            propertyListAndValues[property] = newValue
        }
        return propertyListAndValues.count > 0 ? propertyListAndValues : nil
    }
}
