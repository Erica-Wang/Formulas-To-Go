
//
//  newVC.swift
//  Calculator
//
//  Created by Erica Wang on 2017-02-04.
//  Copyright © 2017 Erica Wang. All rights reserved.
//

import UIKit
import CoreData

class newVC: UIViewController {
    
    var index = 1
    var liVC : listVC!
    var paVC : pageVC!
    var appVC : applyVC!    
    var formula : NSManagedObject!

    @IBOutlet weak var leftF: UITextField!
    @IBOutlet weak var rightF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Name", message: "Add a new name to list", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            void in
            
            self.paVC.restart()

            let txtfield = alertController.textFields?.first
            self.saveData(str: (txtfield?.text)!)
            let section = 0
            let row = self.liVC.numOfForm
            self.liVC.selected = IndexPath(row: row, section: section)
            self.liVC.tableView.reloadData()
            
            self.paVC.set(obj: self.formula)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            void in
        })
        
        alertController.addTextField(configurationHandler: {
            void in
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func saveData(str: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Formula", in: managedContext)
        
        
        formula = NSManagedObject(entity: entity!, insertInto: managedContext)
        formula.setValue(str, forKey: "name")
        formula.setValue(leftF.text, forKey: "left")
        formula.setValue(rightF.text, forKey: "right")
        
        do {
            
            try managedContext.save()
            self.liVC.formulas.append(formula)
            
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

}
