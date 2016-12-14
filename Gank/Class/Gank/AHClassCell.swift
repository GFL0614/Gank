//
//  AHClassCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/14.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHClassCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    lazy var pictureView: YYAnimatedImageView = {
        let pictureView = YYAnimatedImageView()
        self.contentView.addSubview(pictureView)
        return pictureView
    }()
    
    lazy var morePicturesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let morePicturesView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        morePicturesView.collectionViewLayout = layout
        
        let margin: CGFloat = 10
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        let width = (kScreen_W - margin * 4) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .horizontal
        
        morePicturesView.dataSource = self
        morePicturesView.delegate = self
        morePicturesView.backgroundColor = UIColor.white
        morePicturesView.register(UINib(nibName: AHImageCell.getClassName(), bundle: nil), forCellWithReuseIdentifier: "collectionID")
        self.contentView.addSubview(morePicturesView)
        return morePicturesView
    }()
    
    var classModel: AHClassModel! {
        didSet {
            self.contentLabel.text = classModel.desc
            
            // 只有一张图片
            if classModel.imageType == AHImageType.oneImage {
                self.pictureView.isHidden = false
                self.morePicturesView.isHidden = true
                self.pictureView.frame = classModel.imageContainFrame
                if let urlString = classModel.images?[0] {
                    let small_url = urlString + "?imageView2/1/w/\(Int(classModel.imageContainFrame.width))/h/\(Int(classModel.imageContainFrame.height))/interlace/1"
                    self.pictureView.yy_imageURL = URL(string: small_url)
                }
            }
            
            // 有多张图片
            if classModel.imageType == AHImageType.moreImage {
                self.pictureView.isHidden = true
                self.morePicturesView.isHidden = false
                self.morePicturesView.frame = classModel.imageContainFrame
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(_ tableview: UITableView) -> AHClassCell {
        
        var cell = tableview.dequeueReusableCell(withIdentifier: "AHClassCell")
        if cell == nil {
            cell = self.viewFromNib() as! AHClassCell
        }
        return cell as! AHClassCell
    }
}

extension AHClassCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = classModel.images?.count else {
            return 0
        }
        if count == 1 {
            return 0
        } else {
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionID", for: indexPath) as! AHImageCell
        cell.urlString = classModel.images![indexPath.row]
        return cell
    }
}