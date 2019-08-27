//
//  ViewController.swift
//  BlueCompass
//
//  Created by kogarasi on 08/16/2019.
//  Copyright (c) 2019 kogarasi. All rights reserved.
//

import UIKit
import WebKit
import BlueCompass
import RxSwift


class MessageEntity: Decodable {
  var message: String
}


class ExampleViewController: UIViewController {
  var disposeBag = DisposeBag()
  
  let blueCompass = BlueCompass()
  
  lazy var configuration: WKWebViewConfiguration = {
    let config = WKWebViewConfiguration()
    config.userContentController = blueCompass
    
    return config
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear( animated )
    
    let webView = WKWebView( frame: view.frame, configuration: configuration )
    view.addSubview( webView )
        
    blueCompass.receive( "test", MessageEntity.self ).subscribe{
      print( $0.element!.message )
    }.disposed(by: disposeBag )
    
    webView.evaluateJavaScript( "webkit.messageHandlers.test.postMessage( JSON.stringify( { message: \"hello world\" } ) )" )
  }
}
