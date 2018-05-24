//
//  ViewController.swift
//  StretchySnacks
//
//  Created by Raman Singh on 2018-05-24.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var addSnackOutlet: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var foodArray = [String]()
    
    var gestureArray:[UIGestureRecognizer] = []
    var stackView:UIStackView!
    var stackViewBottomConstraint:NSLayoutConstraint!
    var layerBottomConstraint:NSLayoutConstraint!
    var snacksLabel:UILabel!
    
    var itemsArray = ["oreos", "pizza_pockets", "pop_tarts", "popsicle", "ramen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        addLabel()
        stackViewBottomConstraint = self.stackView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: (self.headerView.frame.size.height - 80))
        stackView.isHidden = true
        
    }//load
    
    
    @IBAction func addSnack(_ sender: Any) {
        self.view.layoutIfNeeded()
        
        if stackView.isHidden {
            stackView.isHidden = false
            animateView(viewToBeAnimated: self.headerView, size: 200)
        } else {
           stackView.isHidden = true
            animateView(viewToBeAnimated: self.headerView, size: 64)
        }
        
    }//addSnack
    
    
    func animateView(viewToBeAnimated:UIView, size:CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            viewToBeAnimated.frame.size.height = size
            self.addSnackOutlet.transform = self.addSnackOutlet.transform.rotated(by: CGFloat(Double.pi/4))
            self.stackViewBottomConstraint.isActive = false
            self.stackViewBottomConstraint = self.stackView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: (size - 80))
            self.stackViewBottomConstraint.isActive = true
            self.tableView.frame.origin.y = size
            self.layerBottomConstraint.isActive = false

            if size == 200 {
            self.layerBottomConstraint = self.snacksLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 60)
                
            } else {
            self.layerBottomConstraint = self.snacksLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: (size - 80))
            }
            
            self.layerBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }//animateView
    
    func setupStackView() {
        stackView   = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing   = 16.0
        stackView.backgroundColor = UIColor.red
        
        self.headerView.addSubview(stackView)
        self.stackView.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let gr1 = addImageToStackView(imageName:"oreos", tag:0)
        let gr2 = addImageToStackView(imageName:"pizza_pockets", tag:0)
        let gr3 = addImageToStackView(imageName:"pop_tarts", tag:1)
        let gr4 = addImageToStackView(imageName:"popsicle", tag:0)
        let gr5 = addImageToStackView(imageName:"ramen", tag:1)
        
        gestureArray.append(gr1)
        gestureArray.append(gr2)
        gestureArray.append(gr3)
        gestureArray.append(gr4)
        gestureArray.append(gr5)
        
    }
    
    func addImageToStackView(imageName:String, tag:Int) -> UIGestureRecognizer {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: imageName)
        imageView.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        let imageViewWidth = NSLayoutConstraint(
            item: imageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50
        )
        
        let imageViewHeight = NSLayoutConstraint(
            item: imageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50
        )
        
        imageView.addConstraint(imageViewWidth)
        imageView.addConstraint(imageViewHeight)
        
        imageView.tag = tag
        imageView.isUserInteractionEnabled = true
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapping(recognizer:)))
        singleTap.numberOfTapsRequired = 1;
        imageView.addGestureRecognizer(singleTap)
        
        stackView.addArrangedSubview(imageView)
        
        return singleTap
    }
    
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        
        let index = gestureArray.index(of: recognizer)
        
        let item = itemsArray[index!]
        if !foodArray.contains(item) {
            foodArray.append(item)
        } else {
            foodArray.remove(at: foodArray.index(of: item)!)
        }
        tableView.reloadData()
    }
    
    func addLabel() {
        snacksLabel = UILabel(frame: CGRect(x: 0, y: 300, width: 200, height: 21))
        snacksLabel.textAlignment = .center
        snacksLabel.text = "All Snacks"
        self.headerView.addSubview(snacksLabel)
        self.layerBottomConstraint = self.snacksLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -16)
        self.layerBottomConstraint.isActive = true
        snacksLabel.translatesAutoresizingMaskIntoConstraints = false
        snacksLabel.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
    }
    
    
}//end

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = foodArray[indexPath.row]
        return cell
    }
}





