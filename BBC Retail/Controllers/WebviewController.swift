//
//  WebviewContriller.swift
//  BBC Retail
//
//  Created by Ritu Thakur on 16/09/22.
//

import Foundation

import UIKit
import WebKit
class WebviewController: UIViewController, WKUIDelegate {
   var webView: WKWebView!
   override func viewDidLoad() {
      super.viewDidLoad()
      let myURL = URL(string:"https://bbc.newforceltd.com/")
      let myRequest = URLRequest(url: myURL!)
      webView.load(myRequest)
   }
   override func loadView() {
      let webConfiguration = WKWebViewConfiguration()
      webView = WKWebView(frame: .zero, configuration: webConfiguration)
      webView.uiDelegate = self
      view = webView
   }
}
