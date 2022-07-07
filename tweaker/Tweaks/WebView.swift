//
//  WebView.swift
//  DC app
//
//  Created by Hugo Mason on 27/06/2021.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: URL?
    let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        return WKWebView(frame: .zero,
                         configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let mapURL = url else {
            return
        }
        let request = URLRequest(url: mapURL)
        uiView.load(request)
    }
}
