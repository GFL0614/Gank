//
//  AHGankViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

let ConfigDict: [AnyHashable: Any] = ["福利" : "福利",
                                "Android": "Android",
                                "iOS" : "iOS",
                                "视频" : "休息视频",
                                "拓展资源" : "拓展资源",
                                "前端" : "前端",
                                "干货" : "all"]
enum ClassType: String {
    case welfare = "福利"
    case Android = "Android"
    case iOS = "iOS"
    case video = "休息视频"
    case resource = "拓展资源"
    case fontEnd = "前端"
    case gank = "all"
}

class AHGankViewController: AHDisplayViewController {
    
    /// 已显示的tags
    fileprivate var showTagsArray: [String] = [String]()
    
    /// 未显示的tags
    fileprivate var moreTagsArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 模拟从服务器获取频道列表
        showTagsArray = ["干货", "Android", "iOS", "视频", "前端", "拓展资源"]
        moreTagsArray = ["福利"]
        
        // 从本地读取频道列表
        let saveShowTagsArray = NSKeyedUnarchiver.unarchiveObject(withFile: "saveShowTagsArray".cachesDir()) as? [String]
        if saveShowTagsArray != nil {
            showTagsArray = saveShowTagsArray!
        }
        let saveMoreTagsArray = NSKeyedUnarchiver.unarchiveObject(withFile: "saveMoreTagsArray".cachesDir()) as? [String]
        if saveMoreTagsArray != nil {
            moreTagsArray = saveMoreTagsArray!
        }
        
        setupChildVCs(titles: showTagsArray)
        addTitleButton.addTarget(self, action: #selector(AHGankViewController.addTitleButtonClick(_:)), for: .touchUpInside)
    }
    
    func addTitleButtonClick(_ btn: UIButton) {
        let turnVC = AHTurnChannelViewController()
        turnVC.showTagsArray = showTagsArray
        turnVC.moreTagsArray = moreTagsArray
        
        turnVC.turnChannelClouse = { [unowned self]  showTags, moreTags in
            if self.showTagsArray == showTags {
                return
            }
            
            for childVC in self.childViewControllers {
                childVC.removeFromParentViewController()
            }
            
            self.setupChildVCs(titles: showTags)
            AHLog(showTags)
            // 更新未显示的tags
            self.moreTagsArray = moreTags
            NSKeyedArchiver.archiveRootObject(moreTags, toFile: "saveMoreTagsArray".cachesDir())
            
            self.setupTitleWidth()
            self.setupAllTitle()
            self.contentScrollView.reloadData()
        }
        
        self.present(turnVC, animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupChildVCs(titles: [String]) {
        showTagsArray.removeAll()
        for title in titles {
            let classVC = AHClassViewController()
            classVC.title = title
            classVC.type = ClassType(rawValue: "\(ConfigDict[title]!)")
            addChildViewController(classVC);
            // 更新以显示的tags
            showTagsArray.append(title)
        }
        NSKeyedArchiver.archiveRootObject(showTagsArray, toFile: "saveShowTagsArray".cachesDir())
    }
}
