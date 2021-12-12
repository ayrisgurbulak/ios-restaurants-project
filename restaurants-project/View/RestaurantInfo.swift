//
//  RestaurantInfo.swift
//  restaurants-project
//
//  Created by Ayris Gürbulak on 1.12.2021.
//

import UIKit

class RestaurantInfo: UIView {

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
}



extension UIView{
    func animShow(){
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn],
                       animations: {
            self.center.y -= self.frame.height
            //self.layoutIfNeeded()
        }, completion: nil)
        //self.isHidden = false
    }
    /*func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }*/
}



