//
//  CustomARView.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import ARKit
import RealityKit
import Combine
import SwiftUI

class CustomARView: ARView {
    
    @ObservedObject var basketballManager = BasketballManager.shared
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var collisionSubscription: Cancellable?
    
    private func onCollisionBegan(_ event: CollisionEvents.Began) {
        print("Collide!")
        let firstEntity = event.entityA
        let secondEntity = event.entityB
        
        if firstEntity.name == "triggerEntity" && secondEntity.name == "basketballEntity" {
            print("Goal!")
            basketballManager.totalScore+=1
        }
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
//        let anchorEntity = try! Experience.loadScene()
//        scene.anchors.append(anchorEntity)
        
        collisionSubscription = scene.publisher(for: CollisionEvents.Began.self,
                                                on: nil).sink(receiveValue: onCollisionBegan)
        
        // BOX ENTITY FOR TRIGGER
        let box = MeshResource.generateBox(width: 0.4, height: 0.01, depth: 0.5)
        let material = SimpleMaterial(color: UIColor.clear, isMetallic: false)
        let triggerEntity = ModelEntity(mesh: box, materials: [material])
        
        triggerEntity.collision = CollisionComponent(shapes: [.generateBox(width: 0.4, height: 0.01, depth: 0.5)], mode: .trigger, filter: .sensor)
        triggerEntity.name = "triggerEntity"
        
        let anchor = AnchorEntity(world: .init(x: 0, y: 3.1, z: -5.8))
        anchor.addChild(triggerEntity)
        
        // BASKET HOOP ENTITY
        let secondAnchor = AnchorEntity(world: .init(x: 0, y: 1.0, z: -10.0))
        let basketHoopEntity = try! ModelEntity.loadModel(named: "BasketHoop")
        secondAnchor.addChild(basketHoopEntity)
        
        // LEFT RING ENTITY
        let leftRingEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.02, height: 0.02, depth: 0.5),
                                         materials: [SimpleMaterial(color: UIColor.clear, isMetallic: false)])
        
        leftRingEntity.collision = CollisionComponent(shapes: [.generateBox(width: 0.02, height: 0.02, depth: 0.5)])
        leftRingEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        let thirdAnchor = AnchorEntity(world: .init(x: -0.3, y: 3.0, z: -5.5))
        thirdAnchor.addChild(leftRingEntity)
        
        // MIDDLE RING ENTITY
        let middleRingEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.5, height: 0.02, depth: 0.02),
                                           materials: [SimpleMaterial(color: UIColor.clear, isMetallic: false)])
        
        middleRingEntity.collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.02, depth: 0.02)])
        middleRingEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        let fourthAnchor = AnchorEntity(world: .init(x: 0, y: 3.0, z: -5.3))
        fourthAnchor.addChild(middleRingEntity)
        
        // RIGHT RING ENTITY
        let rightRingEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.02, height: 0.02, depth: 0.5),
                                          materials: [SimpleMaterial(color: UIColor.clear, isMetallic: false)])
        
        rightRingEntity.collision = CollisionComponent(shapes: [.generateBox(width: 0.02, height: 0.02, depth: 0.5)])
        rightRingEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        let fifthAnchor = AnchorEntity(world: .init(x: 0.3, y: 3.0, z: -5.5))
        fifthAnchor.addChild(rightRingEntity)
        
        // BACK HOOP ENTITY
        let backHoopEntity = ModelEntity(mesh: MeshResource.generateBox(width: 1.8, height: 1.5, depth: 0.02),
                                         materials: [SimpleMaterial(color: UIColor.clear, isMetallic: false)])
        
        backHoopEntity.collision = CollisionComponent(shapes: [.generateBox(width: 1.8, height: 1.5, depth: 0.02)])
        backHoopEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        let sixthAnchor = AnchorEntity(world: .init(x: 0, y: 3.0, z: -5.8))
        sixthAnchor.addChild(backHoopEntity)
        
        scene.addAnchor(anchor)
        scene.addAnchor(secondAnchor)
        scene.addAnchor(thirdAnchor)
        scene.addAnchor(fourthAnchor)
        scene.addAnchor(fifthAnchor)
        scene.addAnchor(sixthAnchor)
        
        addCoaching()
        subscribeToActionStream()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                case .shoot:
                    self?.shoot()
                case .removeAllAnchors:
                    self?.scene.anchors.removeAll()
                }
            }
            .store(in: &cancellables)
    }
    
    func shoot() {
        // Get camera position dynamically
        guard let frame = session.currentFrame else { return }
        let cameraTransform = frame.camera.transform
        
        // Create sphere entity
        let sphere = MeshResource.generateSphere(radius: 0.15)
        let material = SimpleMaterial(color: UIColor(.orange), isMetallic: false)
        let entity = ModelEntity(mesh: sphere, materials: [material])
        
        entity.collision = CollisionComponent(shapes: [.generateSphere(radius: 0.15)])
        entity.physicsBody = PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.65), material: .generate(friction: 0.4, restitution: 0.7), mode: .dynamic)
        entity.name = "basketballEntity"
        
//        entity.position = anchorEntity.position
//
//        anchorEntity.addChild(entity)
        
//         Create anchor entity
        let anchor = AnchorEntity(world: cameraTransform)

        anchor.addChild(entity)

        scene.addAnchor(anchor)

        pushSphere(entity)
    }
    
    private func pushSphere(_ entity: ModelEntity) {
        let impulseMagnitude: Float = -5.2
        let impulseVector = SIMD3<Float>(-3.7, 0, impulseMagnitude)
        entity.applyLinearImpulse(impulseVector, relativeTo: entity.parent)
    }
    
    private func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
}

