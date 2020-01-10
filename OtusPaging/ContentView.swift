//
//  ContentView.swift
//  OtusPaging
//
//  Created by user on 10.01.2020.
//  Copyright © 2020 user. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var articlesVM = ArticlesViewModel(topic: "Apple")
    
    var body: some View {
        VStack {
            ArticleListView()
                .environmentObject(articlesVM)
            Divider()
            UIScrollViewWrapper()
                .frame(height:60)
                .environmentObject(articlesVM)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
