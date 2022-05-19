import UIKit
import WebKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let url = Bundle.main.url(forResource: "gait-app", withExtension: "html")
        let myRequest = NSURLRequest(url: url!)
        webView.load(myRequest as URLRequest)
        */
        
        guard let url = URL(string: "https://uartois-lml.github.io/gait-app.html") else {
            return
        }
        webView.load(URLRequest(url: url))
    }

    @IBAction func leaveButtonPressed(){
        let camViewVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewVC") as! CamViewVC
        camViewVC.modalPresentationStyle = .fullScreen
        self.present(camViewVC, animated: true, completion: nil)

    }
    


}
