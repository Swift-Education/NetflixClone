//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by 강동영 on 7/24/24.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var button: UIButton = {
        let button: UIButton = .init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.addAction(UIAction(handler: { _ in
            let vc = MainViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        button.setTitle("Move", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(button)
    }
}
