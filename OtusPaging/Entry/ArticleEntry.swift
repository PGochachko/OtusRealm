//
//  NewsObject.swift
//  OtusPaging
//
//  Created by Павел on 01.06.2020.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation
import RealmSwift

class ArticleEntry: Object {
    @objc dynamic var topic: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
}
