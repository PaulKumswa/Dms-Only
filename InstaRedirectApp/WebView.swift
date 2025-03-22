//
//  WebView.swift
//  InstaRedirectApp
//
//  Created by EJ Emesia on 21/03/2025.
//

import SwiftUI
@preconcurrency import WebKit  // Suppresses concurrency warnings from WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    let request: URLRequest

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        // 1. Configure JavaScript to hide unwanted UI
        let config = WKWebViewConfiguration()
        let js = """
        setInterval(() => {
            // Optional: Hide top nav bar
            const nav = document.querySelector('nav');
            if (nav) nav.style.display = 'none';

            // Optional: Hide main feed
            const feed = document.querySelector('[role="main"]');
            if (feed) feed.style.display = 'none';

            // Hide the Back button in the DMs page
            const backBtnIcon = document.querySelector('svg[aria-label="Back"]');
            if (backBtnIcon) {
                const button = backBtnIcon.closest('button');
                if (button) button.style.display = 'none'; // or button.remove();
            }
        }, 1000);
        """
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)

        // 2. Create the WebView with config and delegate
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

    // MARK: - Coordinator for Navigation Handling
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // Redirect from Instagram homepage to DMs
            if url.absoluteString == "https://www.instagram.com/" {
                let newURL = URL(string: "https://www.instagram.com/direct/inbox/")!
                webView.load(URLRequest(url: newURL))
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }
    }
}
