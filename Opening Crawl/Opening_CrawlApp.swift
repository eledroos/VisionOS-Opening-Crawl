//
//  Opening_CrawlApp.swift
//  Opening Crawl
//
//  Created by Nasser Eledroos on 8/24/24.
//

import SwiftUI

@main
struct Opening_CrawlApp: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }
    }
}
