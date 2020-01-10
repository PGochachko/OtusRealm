//
//  Coordinator.swift
//  OtusPaging
//
//  Created by user on 10.01.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class Coordinator: NSObject {
    var parent: UIScrollViewWrapper

    init(_ wrapper: UIScrollViewWrapper) {
        self.parent = wrapper
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        parent.articlesViewModel.topic = button.titleLabel?.text ?? ""
        parent.articlesViewModel.refresh()
    }
}
