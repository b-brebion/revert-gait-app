import UIKit
import RealityKit
import ARKit
import Combine

class CamViewVC: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var arView: ARView!
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
    
    // Setup the settings and disconnect buttons
    private func setupBarButtonItem() {
        let pullDownMenu = UIMenu(title: "", children: [
            UIAction(title: "Settings", image: UIImage(systemName: "gearshape")) { action in
                // Settings Menu Child Selected
                let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                settingsVC.modalPresentationStyle = .automatic
                self.present(settingsVC, animated: true, completion: nil)
            },
            
            UIAction(title: "Disconnect", image: UIImage(systemName: "power"), attributes: .destructive) { action in
                // Disconnect Menu Child Selected
                let user = User.connectedUser()
                User.connectDisconnect(name: user.name!, familyName: user.familyName!, state: false)
                let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                menuVC.modalPresentationStyle = .fullScreen
                self.present(menuVC, animated: true, completion: nil)
            },
        ])
        
        menuButton.menu = pullDownMenu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    // ARKit session (will switch to the code of JointsDetection in the future)
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            //let leftHandTransform = bodyAnchor.skeleton.modelTransform(for: .leftHand)!
            // print("test")
            //print(ARSkeletonDefinition.defaultBody3D.jointNames)
            //let test = bodyAnchor.skeleton.localTransform(for: ARSkeleton.JointName(rawValue: "hips_joint"))
            //print(test)
            
            // Update the position of the character anchor's position.
            print(bodyAnchor.skeleton.jointLocalTransforms)
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            print(bodyPosition)
            characterAnchor.position = bodyPosition + characterOffset
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
   
            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
        }
    }
}
