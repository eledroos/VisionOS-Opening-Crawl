//
//  ImmersiveView.swift
//  Opening Crawl
//
//  Created by Nasser Eledroos on 8/24/24.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        RealityView { content in
            content.add(viewModel.setupContentEntity())

            // Spawn the hardcoded Star Wars crawl text
            // This text shouldn't be too long in width.
            // You might want to manually truncate it.
            // It will be automatically centered in the ViewModel.
            let crawlText = """
            Episode IV
            A NEW HOPE

            It is a period of civil war.
            Rebel spaceships, striking
            from a hidden base, have won
            their first victory against
            the evil Galactic Empire.
            """
            let textEntity = viewModel.spawnCrawlText(text: crawlText)

            // Optionally remove the text after a delay
            Task {
                await viewModel.removeTextEntities(textEntities: [textEntity], lifetime: 15)
            }
        }
    }
}



