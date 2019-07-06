//
//  CollectionViewCell.swift
//  Memory Pairs Game
//
//  Created by mac_os on 03/11/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let frontImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let backImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        [backImageView, frontImageView].forEach { addSubview( $0 ) }
        
        backImageView.fillSuperview()
        frontImageView.fillSuperview()
        
        frontImageView.isHidden = true
        backImageView.isHidden = false
        
    }
    
}
