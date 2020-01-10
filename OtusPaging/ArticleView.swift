//
//  NewsView.swift
//  OtusPaging
//
//  Created by user on 09.01.2020.
//  Copyright © 2020 user. All rights reserved.
//

import SwiftUI
import Combine

struct ArticleView: View {
    var title: String
    var content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 40))
                .bold()
            Text(content)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(title: "", content: "")
    }
}
