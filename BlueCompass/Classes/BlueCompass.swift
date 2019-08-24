//
//  ScriptRoutingHelper.swift
//  dc7
//
//  Created by こが on 2019/08/15.
//  Copyright © 2019 こが. All rights reserved.
//

import Foundation
import WebKit
import RxSwift

class WebViewScriptRouter: WKUserContentController {
  typealias Key = String
  typealias Content = String
  typealias Observer = PublishSubject<Content>
  
  var observers = Dictionary<Key, Observer>()
  
  //
  // Routerへ購読を登録
  //
  func receive( _ key: Key ) -> Observer {
    
    if let observer = observers[ key ] {
      return observer
    } else {
      add( self, name: key )
      
      
      let observer = Observer()
      observers[ key ] = observer
      
      print( observers )
      
      return observer
    }
    
  }
  
}

extension WebViewScriptRouter: WKScriptMessageHandler {
  
  // JSから呼ばれる
  func userContentController( _ userContentController: WKUserContentController, didReceive message: WKScriptMessage ){
    
    guard let messageData = message.body as? String else {
      fatalError( "message data is not stringified" )
    }
    
    if let observer = observers[ message.name ] {
      observer.on( .next( messageData ) )
    }
  }
}
