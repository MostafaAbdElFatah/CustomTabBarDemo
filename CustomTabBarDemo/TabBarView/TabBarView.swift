//
//  TabBarView.swift
//  CustomTabBarDemo
//
//  Created by Mostafa AbdElFatah on 12/12/2022.
//

import UIKit

enum TabBar:Int {
    case main = 1
    case telawa
    case quran
    case books
    case settings
}

protocol TabBarViewDelegate: AnyObject {
    func didSelect(tabBar:TabBar)
}

class TabBarView: UIView {
    
    public static func instance() -> TabBarView {
        return Bundle.main.loadNibNamed("TabBarView", owner: nil, options: nil)?.first as! TabBarView
    }
    
    
    @IBOutlet weak var sview: CustomView!
    @IBOutlet var tabBarBtns: [UIButton]!
    @IBOutlet var tabBarLabels: [UILabel]!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!

    public var selectedTab:TabBar = .main{
        didSet{ setupSelectedView( selectedTab) }
    }
    
    public var delegate: TabBarViewDelegate?
    public weak var tabBarController:UITabBarController?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        centerView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerView.layer.masksToBounds = false
        centerView.layer.shadowRadius = 6.0
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        centerView.layer.shadowOpacity = 0.4
        centerView.layer.cornerRadius = centerView.frame.width / 2
        leadingConstraint.constant =  30
    }
    
    @IBAction func tabBarBtnTapped(_ sender: UIButton) {
        guard let selectTab = TabBar(rawValue: sender.tag)
        else { return }
        guard let tabBarDelegate = delegate else {
            selectedTab = selectTab
            return
        }
        tabBarDelegate.didSelect(tabBar: selectTab)
    }
    
    func setupSelectedView(_ selectedTab:TabBar) {
        for btn in tabBarBtns {
            guard let label = tabBarLabels.first(where: { $0.tag == btn.tag })
            else { return  }
            if btn.tag == selectedTab.rawValue {
                btn.tintColor = .blue
                label.textColor = .blue
                tabBarController?.selectedIndex = selectedTab.rawValue - 1
                //label.font = UIFont.font(style: .black, size: 8)
            }else{
                btn.tintColor = .lightGray
                label.textColor = .lightGray
                //label.font = UIFont.font(style: .medium, size: 8)
            }
        }
    }// end function
}




class CustomView: UIView {
    
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addShape()
    }
    
    @objc func nightThemeChanged(notification:NSNotification){
        self.addShape()
    }

    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        //shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowOffset = CGSize(width:1, height:1)
        shapeLayer.shadowRadius = 3
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.4

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 60 //frame.height
        let path = UIBezierPath()
        let centerWidth:CGFloat = height
        path.move(to: CGPoint(x: height, y: 0))
        
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
        path.addCurve(
            to: CGPoint(x: centerWidth, y: height - ( height * 0.25)),
            controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
            controlPoint2: CGPoint(x: centerWidth - 35, y: height - ( height * 0.25))
        )
        
        path.addCurve(
            to: CGPoint(x: centerWidth +  height, y: 0),
            controlPoint1: CGPoint(x: centerWidth + 35, y: height - ( height * 0.25)),
            controlPoint2: CGPoint(x: (centerWidth + 30), y: 0)
        )
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        
//        // making cornerRadius of topRight
//        path.addCurve(
//            to: CGPoint(x: self.frame.width, y:  self.frame.height / 2),
//            controlPoint1: CGPoint(x: self.frame.width, y: 0),
//            controlPoint2: CGPoint(x: self.frame.width, y:  self.frame.height / 2)
//        )
//
//        // making cornerRadius of bottomRight
//        path.addCurve(
//            to: CGPoint(x: self.frame.width - 40 , y: self.frame.height) ,
//            controlPoint1: CGPoint(x: self.frame.width, y:  self.frame.height),
//            controlPoint2: CGPoint(x: self.frame.width - 40 , y: self.frame.height)
//        )

        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
//        // making cornerRadius of bottomLeft
//        path.addCurve(
//            to: CGPoint(x: 0, y: self.frame.height / 2),
//            controlPoint1: CGPoint(x: 0, y: self.frame.height),
//            controlPoint2: CGPoint(x: 0, y: self.frame.height / 2)
//        )
//        
//        // making cornerRadius of topLeft
//        path.addCurve(
//            to: CGPoint(x: 40, y: 0),
//            controlPoint1: CGPoint(x: 0, y: 0),
//            controlPoint2: CGPoint(x: 40, y: 0)
//        )
        
        path.close()
        return path.cgPath
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

