# BlueCompass

[![CI Status](https://img.shields.io/travis/kogarasi/BlueCompass.svg?style=flat)](https://travis-ci.org/kogarasi/BlueCompass)
[![Version](https://img.shields.io/cocoapods/v/BlueCompass.svg?style=flat)](https://cocoapods.org/pods/BlueCompass)
[![License](https://img.shields.io/cocoapods/l/BlueCompass.svg?style=flat)](https://cocoapods.org/pods/BlueCompass)
[![Platform](https://img.shields.io/cocoapods/p/BlueCompass.svg?style=flat)](https://cocoapods.org/pods/BlueCompass)

## Features

* Reactive Style.
* Simple receive data with type.

## Example

```swift

// format for receive json.
class MessageEntity: Decodable {
  var message: String
}


class ExampleViewController: UIViewController {
  var disposeBag = DisposeBag()
  
  let blueCompass = BlueCompass()
  
  // create configuration and set BlueCompass to userContentController.
  lazy var configuration: WKWebViewConfiguration = {
    let config = WKWebViewConfiguration()
    config.userContentController = blueCompass
    
    return config
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear( animated )
    
    let webView = WKWebView( frame: view.frame, configuration: configuration )
    view.addSubview( webView )
    
    // "test" is custom specified name.
    // Json data is converted in internal.
    blueCompass.receive( "test", MessageEntity.self ).subscribe{
      print( $0.element!.message )
    }.disposed(by: disposeBag )
    
    // javascript sample.
    webView.evaluateJavaScript( "webkit.messageHandlers.test.postMessage( JSON.stringify( { message: \"hello world\" } ) )" )
  }
}
```

## Requirements

Swift: 5.0
iOS: 11.0
RxSwift: 5.0

## Installation

BlueCompass is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BlueCompass'
```

## Author

kogarasi, kogarasi.cross@gmail.com

## License

BlueCompass is available under the MIT license. See the LICENSE file for more info.
