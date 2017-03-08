//
//  SegmentedControl.swift
//  Hippo
//
//  Created by Jeff Eom on 2017-02-13.
//  Copyright © 2017 Jeff Eom. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl{
    
    private var labels = [UILabel]()
//    var thumbView = UIView()
    
    var items: [String] = ["Photos", "Overview", "Map"]{
        didSet{
            setupLables()
        }
    }
    
    var selectedIndex : Int = 0{
        didSet{
            displayNewSelectedIndex()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder){
        super.init(coder: coder)!
        
        setupView()
    }
    
    func setupView(){
        
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0).cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clear
        
        setupLables()
        
        let label = labels[0]
        label.textColor = UIColor.white
        
//        insertSubview(thumbView, at: 0)
    }
    
    func setupLables() {
        for label in labels{
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count{
            let label = UILabel(frame: CGRect.zero)
            label.text = items[index - 1]
            label.textAlignment = .center
            label.textColor = UIColor(white: 1.0, alpha: 0.5)
            self.addSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        var selectedFrame = self.bounds
//        let newWidth = selectedFrame.width / CGFloat(items.count)
//        selectedFrame.size.width = newWidth
//        thumbView.frame = selectedFrame
//        thumbView.backgroundColor = UIColor.white
//        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1{
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect.init(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
        }
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location){
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil{
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex() {
        
        for aLabel in labels{
            aLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        }
        
        let label = labels[selectedIndex]
        label.textColor = UIColor.white
        
    }
    
}
