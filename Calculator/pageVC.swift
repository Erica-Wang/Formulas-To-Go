//
//  pageVC.swift
//  Calculator
//
//  Created by Erica Wang on 2017-02-04.
//  Copyright © 2017 Erica Wang. All rights reserved.
//

import UIKit
import CoreData

class pageVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    var pageVC = UIPageViewController()
    var liVC : listVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        pageVC.setViewControllers([pages.first!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PageViewSegue"{
            pageVC = segue.destination as! UIPageViewController
            pageVC.dataSource = self
            pageVC.delegate = self
        }
        
    }
    
    func prep(vc: listVC){
        let new = self.storyboard?.instantiateViewController(withIdentifier: "new") as! newVC
        new.index = 0
        self.liVC = vc
        new.liVC = vc
        new.paVC = self
        
        pages.removeAll()
        pages.append(new)
        pageVC.setViewControllers([pages.first!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func set(obj: NSManagedObject){
        
        pages.removeAll()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "apply") as! applyVC
        vc.obj = obj
        vc.prep()
        pages.append(vc)
        let new = self.storyboard?.instantiateViewController(withIdentifier: "new") as! newVC
        new.liVC = self.liVC
        new.paVC = self
        new.appVC = vc
        pages.append(new)
        pageVC.setViewControllers([pages.first!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        var index = -1
        
        if let vc = viewController as? newVC{
            index = vc.index-1
        }
        
        if index==0{
            return pages[index]
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        if pages.count > 1{
        
            var index = -1
            
            if let vc = viewController as? applyVC{
                index = vc.index+1
            }
            
            if index==1{
                return pages[index]
            }
        }
        return nil
        
    }
    
    func restart(){
        pageVC.setViewControllers([pages.first!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
}
