//
//  DatailViewController.swift
//  NewsReaderApp
//
//  Created by IwasakIYuta on 2021/07/06.
//

import UIKit
import WebKit

class DatailViewController : UIViewController {
    var link: String!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.link) {
            let request = URLRequest(url: url)
            self.webView.load(request)
            
        }
    }
}
