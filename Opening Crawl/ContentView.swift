//
//  ContentView.swift
//  Opening Crawl
//
//  Created by Nasser Eledroos on 8/24/24.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel
    @State private var showContentView = true // Controls the visibility of the entire ContentView
    @State private var textAnimationCompleted = false // Controls the reappearance of the window contents

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        if showContentView { // Show the content view only if showContentView is true
            Button("Start Opening Crawl") {
                startCrawl()
            }
        }
    }

    func startCrawl() {
        showContentView = false // Hide the entire window
        Task {
            await openImmersiveSpace(id: "ImmersiveSpace")
            textAnimationCompleted = false
            // Assume the animation duration is 15 seconds
            try? await Task.sleep(nanoseconds: UInt64(15 * 1_000_000_000))
            await dismissImmersiveSpace()
            textAnimationCompleted = true
            // Reappear the content view after a delay
            try? await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000)) // 2-second delay
            showContentView = true
        }
    }
}

