//
//  String+.swift
//  Lottery
//
//  Created by 조우현 on 2/24/25.
//

import UIKit

extension String {
    func resultLabelTextAttribute() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: (self as NSString).range(of: "당첨결과"))
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25, weight: .regular), range: (self as NSString).range(of: "당첨결과"))
        
        return attributeString
    }
}
