//
//  GetImageAssets.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 11.06.2024.
//

import UIKit

class AssetsImageLoader {
    static func getAssetImage(byName assetImageName: String?, in imageView: UIImageView) {
        if let imageName = assetImageName {
            let bundle = Bundle(for: AssetsImageLoader.self)
            if let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) {
                imageView.image = image
            } else {
                imageView.image = UIImage(systemName: "paperplane.fill")
            }
        } else {
            imageView.image = UIImage(systemName: "paperplane.fill")
        }
    }
}
