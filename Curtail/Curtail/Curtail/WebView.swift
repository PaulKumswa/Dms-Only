//
//  WebView.swift
//  Curtail
//
//  Created by EJ Emesia on 21/03/2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    // 1) We’ll pass in a custom WKWebViewConfiguration
    let configuration: WKWebViewConfiguration
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        // Create the WKWebView with the custom config
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        // Optionally set navigationDelegate if you want to see console logs, etc.
        webView.navigationDelegate = context.coordinator
        
        // Load the initial URL
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nothing needed here for now
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        // You can add logs or handle navigation events here if desired
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
            
    func makeConfigurationForLimitingPosts() -> WKWebViewConfiguration {
        let contentController = WKUserContentController()
        
        // This JS runs after the DOM loads, removing extra posts
        let blockAfter10PostsJS = #"""
        (function() {
          // Keep track of how many posts we've seen
          let postCount = 0;

          // Observe the DOM for new elements
          const observer = new MutationObserver(function(mutations) {
            for (const mutation of mutations) {
              for (const node of mutation.addedNodes) {
                if (node.nodeType === Node.ELEMENT_NODE) {
                  // If this node (or a child of it) is recognized as a post
                  // IG posts are often <article> or have certain classes, but it changes
                  // We guess "article" as an example. You might need to tweak this.
                  if (node.querySelector && node.querySelector("article")) {
                    // Each <article> might contain 1 post or multiple—this is naive
                    // but let's increment once for each matched article
                    postCount++;
                    console.log("Added post. postCount=", postCount);

                    // If we're above 10 posts, remove the node from the DOM
                    if (postCount > 10) {
                      node.remove();
                    }
                  }
                }
              }
            }
          });

          // Start observing the main container
          // We do body for simplicity, but you might want to be more specific
          observer.observe(document.body, { childList: true, subtree: true });

          // Additionally, we can try disabling the fetch for more posts:
          // (monkey-patch fetch or XHR after 10, but that’s more advanced)
        })();
        """#
        
        let userScript = WKUserScript(source: blockAfter10PostsJS,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        return config
    }


        }
    }
}
