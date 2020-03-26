//
//  AdvanceLearning.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/26.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

enum TestEnum {
    case test1,test2,test3
}

enum EnAssociatedEnum {
    case test1(Int, Int, Int)
    case test2(Int, Int)
    case test3(Int)
    case test4(Bool)
    case test5
    // 1个字节存储成员值
    // N个字节存储关联值（N取占用内存最大的关联值），任何一个case的关联值都共用这N个字节
    // 共用体
}

class SeniorLearning: NSObject {
    func testEnum() {
        var t = TestEnum.test1
        t = .test2
        t = .test3
        print(Mems.ptr(ofVal: &t))
        
        print(MemoryLayout<TestEnum>.size)
        print(MemoryLayout<TestEnum>.stride)
        print(MemoryLayout<TestEnum>.alignment)
    }
    

}
