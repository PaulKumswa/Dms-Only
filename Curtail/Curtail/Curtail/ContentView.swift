//
//  ContentView.swift
//  Curtail
//
//  Created by EJ Emesia on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // 1) Create our custom WKWebViewConfiguration
        let config = makeConfigurationForLimitingPosts()

        // 2) The URL to Instagram’s home page
        let instaURL = URL(string: "https://www.instagram.com/")!

        // 3) Pass both to our WebView struct
        WebView(configuration: config, url: instaURL)
            .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ContentView()
}
