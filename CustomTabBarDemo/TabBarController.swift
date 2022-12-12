//
//  TabBarController.swift
//  CustomTabBarDemo
//
//  Created by Mostafa AbdElFatah on 12/12/2022.
//

import UIKit

class TabBarController: UITabBarController {

    public var selectedTab: TabBar{
        get{ tabBarView.selectedTab }
        set{ tabBarView.selectedTab = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .green
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .blue
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .red
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .orange
        let vc5 = UIViewController()
        vc5.view.backgroundColor = .magenta
        let viewControllers = [vc1, vc2, vc3, vc4, vc5 ]
        setViewControllers(viewControllers, animated: false)
        tabBarView.selectedTab = .main
    }
    
    
    lazy var tabBarView: TabBarView = {
        let sview = TabBarView.instance()
        sview.tabBarController = self
        sview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sview)
        NSLayoutConstraint.activate([
            sview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            sview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            sview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
        view.bringSubviewToFront(sview)
        return sview
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(tabBarView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
