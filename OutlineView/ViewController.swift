//
//  ViewController.swift
//  OutlineView
//
//  Created by Iggy Drougge on 2018-10-01.
//  Copyright © 2018 Iggy Drougge. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var treeController: NSTreeController!
    
    @objc dynamic var dict = ["apa": 1, "bpa": 2, "cpa": ["ett": 1, "två": 2], "dpa": "fyra", "epa": [5,6,7], "fpa": ["åtta":8, "mer": ["nio": 9, "tio": 10]]].map(TreeItem.init)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

@objc class TreeItem: NSObject {
    @objc var name: String//? = nil
    @objc var children: [TreeItem] = []
    @objc var value: String?
    @objc var count: Int { return children.count }
    @objc var isLeaf: Bool { return children.isEmpty }
    init(_ obj: Any) {
        //print("obj:",obj, obj is (String,Int))
        switch obj {
        case let (k,v) as (String,Int):
            print("k:\(k),nr:\(v)")
            self.name = k
            self.value = "\(v)"
        case let (k,v) as (String,String):
            print("k:\(k),str:\(v)")
            self.name = k
            self.value = v
        case let (k,v) as (String,[String:Any]):
            print("k:\(k),dic:\(v)")
            self.name = k
            let children = v.map(TreeItem.init)
            self.value = "\(children.count) items"
            self.children = children
        case let (k,v) as (String,[Any]):
            self.name = k
            let children = v.enumerated().map(TreeItem.init)
            self.value = "\(children.count) items"
            self.children = children
        case let (k,v) as (Int,Int):
            self.name = "#\(k)"
            self.value = "\(v)"
        default: self.name = "Error: \(obj)"
        }
    }
}
