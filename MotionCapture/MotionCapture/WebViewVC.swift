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
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        menuVC.modalPresentationStyle = .fullScreen
        self.present(menuVC, animated: true, completion: nil)

    }
    


}
