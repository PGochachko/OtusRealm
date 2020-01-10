//
//  ContentView.swift
//  OtusPaging
//
//  Created by user on 09.01.2020.
//  Copyright © 2020 user. All rights reserved.
//

import SwiftUI

final class ArticlesViewModel: ObservableObject {
    @Published private (set) var articles = [Article]()
    
    @Published private (set) var isNewsLoading = false
    @Published private (set) var page = 0
    
    @Published var topic: String
    
    init(topic: String) {
        self.topic = topic
        refresh()
    }
    
    func refresh() {
        articles = []
        page = 0
        appendNewsFromNetwork()
    }
    
    func appendNewsFromNetwork() {
        guard self.isNewsLoading == false else {
            return
        }
        
        self.isNewsLoading = true
        
        ArticlesAPI.everythingGet(q: topic, from: "2020-01-01", sortBy: "publishedAt", apiKey: "fc743db938c646dc9e4be15868526bf7", page: self.page+1) { list, error in
            if let articles = list?.articles {
                self.articles.append(contentsOf: articles)
                self.isNewsLoading = false
                self.page += 1
            }
        }

    }
}

extension Article: Identifiable {
    public var id: String {
        return url ?? UUID().uuidString
    }
}

struct ArticleListView: View {
    @EnvironmentObject var viewModel:  ArticlesViewModel
    
    var body: some View {
        List(self.viewModel.articles) { article in
            VStack(alignment: .leading) {
                ArticleView(title: article.title ?? "", content: article.description ?? "")

                if self.viewModel.articles.isLastItem(article) &&
                    self.viewModel.isNewsLoading {
                    Divider()
                    Text("Loading...")
                }

            }.onAppear {
                self.onItemShowed(article)
            }
        }
    }
}

extension ArticleListView {
    private func onItemShowed<T:Identifiable>(_ item: T) {
        if self.viewModel.articles.isLastItem(item) {
            self.viewModel.appendNewsFromNetwork()
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
