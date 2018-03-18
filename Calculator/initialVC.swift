//
//  initialVC.swift
//  Calculator
//
//  Created by Erica Wang on 2017-02-05.
//  Copyright © 2017 Erica Wang. All rights reserved.
//

import UIKit

class initialVC: SWRevealViewController {
    
    var liVC : listVC!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sw_rear"{
            
            let nav = segue.destination as! UINavigationController
            liVC = nav.viewControllers[0] as! listVC
            
        }else if segue.identifier == "sw_front"{
            let vc = segue.destination as! pageVC
            vc.prep(vc: self.liVC)
            liVC.paVC = vc
        }
        
    }

}
