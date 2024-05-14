//
//  WebView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 13/5/24.
//

import SwiftUI
import WebKit

struct ComicWebView: View {
    let url:String
    var body: some View {
        WebView(url: url)
    }
}

struct WebView: UIViewRepresentable {
    var url: String
    let webView: WKWebView
    
    init(url: String) {
        self.url=url
        webView = WKWebView(frame: .zero)
    }
 
    
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: URL(string: url)!))
    }
}

#Preview {
    ComicWebView(url: "http://marvel.com/comics/issue/10223/marvel_premiere_1972_35?utm_campaign=apiRef&utm_source=a5756515edff54cf6538f93b5c3844dc")
}
