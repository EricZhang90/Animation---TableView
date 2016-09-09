import UIKit

//
// A scroll view, which loads all 10 images, and has a callback
// for when the user taps on one of the images
//
class HorizontalItemList: UIScrollView {
  
  var didSelectItem: ((item: UIView)->())?
  
  let buttonWidth: CGFloat = 60.0
  let padding: CGFloat = 10.0
  
  convenience init(inView: UIView) {
    let rect = CGRect(x: 0, y: 120.0, width: inView.frame.width, height: 80.0)
    self.init(frame: rect)
    
    for i in 0 ..< 10 {
      let image = UIImage(named: "summericons_100px_0\(i).png")
      let imageView  = UIImageView(image: image)
      imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth/2, y: buttonWidth/2)
      imageView.tag = i
      imageView.userInteractionEnabled = true
      addSubview(imageView)
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(HorizontalItemList.didTapImage(_:)))
      imageView.addGestureRecognizer(tap)
    }
    
    contentSize = CGSize(width: padding * buttonWidth, height:  buttonWidth + 2*padding)
  }
  
  func didTapImage(tap: UITapGestureRecognizer) {
    didSelectItem?(item: tap.view!)
  }  
}