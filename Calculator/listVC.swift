//
//  listVC.swift
//  Calculator
//
//  Created by Erica Wang on 2017-02-04.
//  Copyright © 2017 Erica Wang. All rights reserved.
//

import UIKit
import CoreData

class listVC: UITableViewController {
    
    var formulas = [NSManagedObject]()
    var paVC : pageVC!
    var numOfForm = 0
    
    var selected : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.formulas.count)
        print("tableview",self.tableView.numberOfRows(inSection: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath = self.tableView.indexPathForSelectedRow
        
        selected = indexPath
        self.tableView.reloadData()
        
        let vc = segue.destination as! pageVC
        paVC = vc
        vc.liVC = self
        vc.set(obj: formulas[(indexPath?.row)!])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Formula")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            formulas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numOfForm = formulas.count
        return formulas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = formulas[indexPath.row].value(forKey: "name") as? String
        if selected != nil{
            if indexPath == selected{
                cell?.backgroundColor = UIColor(hue: 0.5111, saturation: 0.25, brightness: 1, alpha: 1.0)
            }else{
                cell?.backgroundColor = UIColor.white
            }
        }
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            void in
            
            let alertController = UIAlertController(title: "Are you sure?", message: "It will not be recoverable.", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "Delete", style: .destructive, handler: {
                void in
                self.deleteFormula(indexPath: indexPath, index: indexPath.row)
            })
            let cancelAct = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(deleteAct)
            alertController.addAction(cancelAct)
            self.present(alertController, animated: true, completion: nil)
            
        })
        
        let uselessAction = UITableViewRowAction(style: .default, title: "", handler: {
            void in
        })
        return [uselessAction,uselessAction,deleteAction]
    }
    
    func deleteFormula (indexPath: IndexPath, index: Int){
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(formulas[index] as NSManagedObject)
        formulas.remove(at: index)
        
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    @IBAction func deleteAllAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "The information will not be recoverable.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            void in
            
            let appDelegate =
                UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            
            for i in 0..<self.formulas.count{
                managedContext.delete(self.formulas[i] as NSManagedObject)
            }
            
            self.formulas.removeAll()
            self.tableView.reloadData()
            
            self.paVC.prep(vc: self)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            void in
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    
        
    }
    
    func reload(index: IndexPath){
        self.tableView.cellForRow(at: selected)?.backgroundColor = UIColor.white
        selected = index
        let cell = self.tableView.cellForRow(at: selected)
        print(index)
        cell?.backgroundColor = UIColor(hue: 0.5111, saturation: 0.25, brightness: 1, alpha: 1.0)
    }
}
