import Foundation
import WebKit
import RxSwift

public class BlueCompass: WKUserContentController {
  
  private var observers = Dictionary<String, ( subject: Any, sender: ( String ) -> Void )>()
  
  public func receive<Response>( _ key: String, _ responseType: Response.Type ) -> PublishSubject<Response> where Response: Decodable {
    let dictionaryKey: String = key.description
    
    if let element = observers[ dictionaryKey ] {
      
      return element.subject as! PublishSubject<Response>
    } else {
      add( self, name: key.description )
      
      let observer = PublishSubject<Response>()
      observers[ dictionaryKey ] = (observer, { message in
        let decoded = try! JSONDecoder().decode( Response.self, from: message.description.data(using: .utf8 )! )
        observer.on( .next( decoded ) )
      })
      
      return observer
    }
  }
}

extension BlueCompass: WKScriptMessageHandler {
  
  public func userContentController( _ userContentController: WKUserContentController, didReceive message: WKScriptMessage ){
    
    guard let messageData = message.body as? String else {
      fatalError( "message data is not stringified" )
    }
    
    if let observer = observers[ message.name ] {
      observer.sender( messageData )
    }
  }
}
