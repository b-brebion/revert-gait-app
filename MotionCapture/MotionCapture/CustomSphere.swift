import UIKit
import RealityKit

// CustomSphere class for joints rendering
class CustomSphere: Entity, HasModel {
    required init(color: UIColor, radius: Float) {
        super.init()
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
