//
//  ViewModel.swift
//  Opening Crawl
//
//  Created by Nasser Eledroos on 8/24/24.
//

import RealityKit
import SwiftUI

class ViewModel: ObservableObject {
    private var contentEntity = Entity()
    private let roomBoundaryStart: Float = 2.0
    private let roomBoundaryEnd: Float = 6.0

    func setupContentEntity() -> Entity {
        return contentEntity
    }

    @MainActor
    func spawnCrawlText(text: String, color: UIColor = .yellow, duration: Double = 10.0) -> ModelEntity {
        let textMeshResource: MeshResource = .generateText(
            text,
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.35, weight:.black),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping)

        let material = UnlitMaterial(color: color)
        let textEntity = ModelEntity(mesh: textMeshResource, materials: [material])
        
        // Calculate the width of the text block
        let textWidth = textEntity.model?.mesh.bounds.extents.x ?? 0
        
        textEntity.position = SIMD3(x: -textWidth / 2, y: -3, z: 2) // Start near bottom and close to the viewer, centered on the text block
        textEntity.transform.rotation = simd_quatf(angle: -.pi / 3.5, axis: SIMD3(x: 1, y: 0, z: 0)) // Tilt back
        contentEntity.addChild(textEntity)

        let animation = generateCrawlAnimation(entity: textEntity, duration: duration)
        textEntity.playAnimation(animation, transitionDuration: duration, startsPaused: false)

        return textEntity
    }

    private func generateCrawlAnimation(entity: ModelEntity, duration: Double) -> AnimationResource {
        let start = Point3D(
            x: entity.position.x,
            y: entity.position.y,
            z: entity.position.z
        )

        let end = Point3D(
            x: start.x,
            y: start.y + 5, // Move up
            z: start.z - 10 // Move away
        )
        
        // Maintain rotation axis
        let rotation = entity.transform.rotation

        let linear = FromToByAnimation<Transform>(
            from: Transform(scale: .init(repeating: 1), rotation: rotation, translation: simd_float(start.vector)),
            to: Transform(scale: .init(repeating: 1), rotation: rotation, translation: simd_float(end.vector)),
            duration: duration,
            timing: .linear,
            bindTarget: .transform
        )

        return try! AnimationResource.generate(with: linear)
    }
    
    func removeTextEntities(textEntities: [ModelEntity], lifetime: UInt32 = 20) async {
        sleep(lifetime)
        await MainActor.run {
            textEntities.forEach { $0.removeFromParent() }
        }
    }

}
