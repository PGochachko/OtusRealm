//
//  ContentView.swift
//  OtusPaging
//
//  Created by user on 09.01.2020.
//  Copyright © 2020 user. All rights reserved.
//

import SwiftUI
import RealmSwift

final class ArticlesViewModel: ObservableObject {
    @Published private (set) var articles = [ArticleEntry]()
    
    @Published private (set) var isNewsLoading = false
    @Published private (set) var page = 0
    
    @Published var topic: String
    
    private let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private var realm: Realm
    var articleEntries: Results<ArticleEntry>

    init(topic: String) {
        self.topic = topic
        self.realm = try! Realm(configuration: config)
        self.articleEntries = realm.objects(ArticleEntry.self)
        refresh()
    }
        
    func refresh() {
        articles.append(contentsOf: self.articleEntries.filter {
            $0.topic == self.topic
        })
        page = 0
        appendNewsFromNetwork()
    }
    
    func appendNewsFromNetwork() {
        guard self.isNewsLoading == false else {
            return
        }
        
        self.isNewsLoading = true
        
        ArticlesAPI.everythingGet(q: topic, from: "2020-05-31", sortBy: "publishedAt", apiKey: "b8292fe9971a4230902942e9fe51bd9e", page: self.page+1) { list, error in
            if let articles = list?.articles {
                let articalEntries = articles.map { a in
                    ArticleEntry(value: ["topic": self.topic, "title": a.title ?? "", "desc": a.description ?? ""])
                }
                
                try! self.realm.write {
                    self.realm.add(articalEntries)
                }
                
                self.articles.append(contentsOf: articalEntries)
                self.isNewsLoading = false
                self.page += 1
            }
        }

    }
}

extension ArticleEntry: Identifiable {
    public var id: String {
        return UUID().uuidString
    }
}

struct ArticleListView: View {
    @EnvironmentObject var viewModel:  ArticlesViewModel
    
    var body: some View {
        List(self.viewModel.articles) { article in
            VStack(alignment: .leading) {
                ArticleView(title: article.title, content: article.description)

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
