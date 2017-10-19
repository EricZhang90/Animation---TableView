import UIKit

class ViewController: UIViewController {
    
    //MARK: IB outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonMenu: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonTrailing: NSLayoutConstraint!
    
    //MARK: further class variables
    
    var slider: HorizontalItemList!
    var isMenuOpen = false
    var items: [Int] = [0, 1, 2]
    
    //MARK: class methods
    
    @IBAction func actionToggleMenu(_ sender: AnyObject) {
        isMenuOpen = !isMenuOpen
        
        menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
        
        closeButtonTrailing.constant = isMenuOpen ? 16.0 : 8.0
        
        titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
        
        for constraint in titleLabel.superview!.constraints
        {
            if constraint.identifier == "TitleCenterX"
            {
                constraint.isActive = false
                
                let newConstraint = NSLayoutConstraint(
                    item: titleLabel,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: titleLabel.superview!,
                    attribute: .centerX,
                    multiplier: isMenuOpen ? 0.25 : 1,
                    constant: isMenuOpen ? 40 : 0)
                
                newConstraint.identifier = "TitleCenterX"
                
                newConstraint.isActive = true
                
                //constraint.constant = isMenuOpen ? -100.0 : 0.0
            }
            else if constraint.identifier == "TitleCenterY"
            {
                constraint.isActive = false
                
                let newConstraint = NSLayoutConstraint(
                    item: titleLabel,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: titleLabel.superview!,
                    attribute: .centerY,
                    multiplier: isMenuOpen ? 0.67 : 1,
                    constant: 5)
                
                newConstraint.identifier = "TitleCenterY"
                
                newConstraint.isActive = true
            }
            
        }
        
        UIView.animate(withDuration: 1.2, delay: 0,
                                   
            usingSpringWithDamping: 0.4, initialSpringVelocity: 5.0,
            
            options: .curveEaseOut, animations: {
            
            let angle = self.isMenuOpen ? CGFloat(Double.pi / 4) : 0
            
            self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        UIView.animate(withDuration: 1.2, animations: {
            self.slider.alpha = self.isMenuOpen ? 1 : 0
        })
        
    }
    
    func showItem(_ index: Int) {

        // hide previous image
        if let lastImageView = view.subviews.last,  lastImageView.isKind(of: UIImageView.self)
        {
            UIView.transition(with: lastImageView, duration: 0.75,
                                     
                options: [.transitionFlipFromBottom]
                
                , animations: {
                    lastImageView.isHidden = true
                }, completion: {
                    (_) in
                    lastImageView.removeFromSuperview()
            })
        }
        
        //show the selected image
        let imageView  = UIImageView(image:
            UIImage(named: "summericons_100px_0\(index).png"))
        imageView.backgroundColor = UIColor(red: 0.0, green: 0.0,
                                            blue: 0.0, alpha: 0.4)
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
    
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
        let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
        let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        
        NSLayoutConstraint.activate([conX, conBottom, conWidth, conHeight])
        
        view.layoutIfNeeded()
        
        conBottom.constant = -imageView.frame.size.height/2
        conWidth.constant = 0.0
        UIView.animate(withDuration: 0.33, delay: 0.0,
            
            usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0,
                                   
            options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        delay(seconds: 1.5){
            UIView.transition(with: imageView, duration: 1,
                options: [.transitionFlipFromBottom]
                , animations: { 
                    imageView.isHidden = true
            }){
                (_) in
                imageView.reloadInputViews()
            }
        }
    }
    
    func transitionCloseMenu(_ item: UIView) {
        //close the menu with a cool transition
        delay(seconds: 0.35, completion: {
            self.actionToggleMenu(self)
        })
        
        let titleBar = slider.superview!
        
        UIView.transition(with: titleBar,
                                  duration: 0.5,
                                  options: [.curveEaseOut, .transitionFlipFromBottom],
                                  animations: {
                                    self.slider.removeFromSuperview()
            }, completion: {_ in titleBar.addSubview(self.slider) })
    }
}

//////////////////////////////////////
//
//   Starter project code
//
//////////////////////////////////////

let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: View Controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.rowHeight = 54.0
        
        slider = HorizontalItemList(inView: view)
        slider.didSelectItem = {item in
            self.items.append(item.tag)
            self.tableView.reloadData()
            self.transitionCloseMenu(item)
        }
        slider.alpha = 0
        self.titleLabel.superview!.addSubview(slider)
    }
    
    // MARK: Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = itemTitles[items[(indexPath as NSIndexPath).row]]
        cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[(indexPath as NSIndexPath).row]).png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItem(items[(indexPath as NSIndexPath).row])
    }
}
