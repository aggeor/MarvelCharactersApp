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
