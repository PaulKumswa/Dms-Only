//
//  WebViewWithRedirect.swift
//  InstaRedirectApp
//
//  Created by EJ Emesia on 21/03/2025.
//

import SwiftUI
import WebKit

struct WebViewWithRedirect: UIViewRepresentable {
    // The type of UIView we’re wrapping
    typealias UIViewType = WKWebView
    
    let request: URLRequest
    var preferredPage: String

    // Create our coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(preferredPage: preferredPage)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    // Called when SwiftUI updates the view
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // If the user changes `preferredPage` in the Picker,
        // we update the coordinator’s state
        context.coordinator.preferredPage = preferredPage
        
        // Optionally reload if you want changes to take effect immediately:
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var preferredPage: String
        
        init(preferredPage: String) {
            self.preferredPage = preferredPage
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            // If user tries to load plain instagram.com,
            // redirect to the subpage
            if url.absoluteString == "https://www.instagram.com/" {
                var newURLString = "https://www.instagram.com/"
                switch preferredPage {
                case "messages":
                    newURLString = "https://www.instagram.com/direct/inbox/"
                // 'home' or fallback
                default:
                    newURLString = "https://www.instagram.com/direct/inbox/"
                }
                
                let newURL = URL(string: newURLString)!
                webView.load(URLRequest(url: newURL))
                
                // Cancel the original navigation
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
    }
}
