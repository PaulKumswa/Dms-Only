//
//  ContentView.swift
//  InstaRedirectApp
//
//  Created by EJ Emesia on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var preferredPage: String = "reels"
    
    var body: some View {
        VStack {
            Picker("Choose Default Page", selection: $preferredPage) {
                Text("Messages").tag("messages")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            let startURL = URL(string: "https://www.instagram.com/")!
            let request = URLRequest(url: startURL)
            
            WebViewWithRedirect(request: request, preferredPage: preferredPage)
                .edgesIgnoringSafeArea(.all)
        }
    }
}


#Preview {
    ContentView()
}
