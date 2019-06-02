//
//  ViewController.swift
//  OutlineView
//
//  Created by Iggy Drougge on 2018-10-01.
//  Copyright © 2018 Iggy Drougge. All rights reserved.
//

import Cocoa

let json = """
{
    "glossary": {
        "title": "example glossary",
        "GlossDiv": {
            "title": "S",
            "GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "Acronym": "SGML",
                    "Abbrev": "ISO 8879:1986",
                    "GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                    },
                    "GlossSee": "markup"
                }
            }
        }
    }
}
"""
class ViewController: NSViewController {

    @IBOutlet var treeController: NSTreeController!
    
    @objc var dict = try! [ TreeItem.init( JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: .allowFragments) ) ]
    
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
    // TODO: Handle `Bool`, `null`
    init(_ obj: Any) {
        //print("obj:", type(of: obj))
        switch obj {
        case let v as [String:Any]:
            let children = v.map(TreeItem.init)
            self.name = "\(children.count) items"
            self.children = children
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
        case let (k,v) as (Int,String):
            self.name = "#\(k)"
            self.value = v
        default:
            print("###Unhandled type:", obj)
            self.name = "Error: \(obj)"
        }
    }
}
