//
//  Untitled.swift
//  GreenCircle
//
//  Created by Екатерина Шрайнер on 06.10.2026.
//
import UIKit

class PaddingTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
