//
//  firstTableViewController.swift
//  Question2
//
//  Created by User on 2021-04-22.
//  Copyright © 2021 Seneca. All rights reserved.
//

import UIKit
import CoreData

class firstTableViewController: UITableViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        try? fetchresultcntrller.performFetch()
    }
    
    
    @IBAction func refreshbttn(_ sender: UIBarButtonItem) {
      
        
    }
    lazy var fetchresultcntrller : NSFetchedResultsController<Myweather> = {
        let fecthreq : NSFetchRequest<Myweather> = Myweather.fetchRequest()
        fecthreq.sortDescriptors = [NSSortDescriptor(key: "tripname", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fecthreq, managedObjectContext: CoreDataStack.share.persistentContainer.viewContext, sectionNameKeyPath: "tripname", cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    @IBAction func editbttn(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
   

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //delete row with swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let rowd = fetchresultcntrller.object(at: indexPath)
           fetchresultcntrller.managedObjectContext.delete(rowd)
            try? fetchresultcntrller.managedObjectContext.save()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchresultcntrller.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //let obj = fetchresultcntrller.object(at: sourceIndexPath.row)
        //tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        
        var objects = fetchresultcntrller.fetchedObjects
        let object = objects?[sourceIndexPath.row]
        objects?.remove(at: sourceIndexPath.row)
        objects?.insert(object!, at: destinationIndexPath.row)
        //for (index,item) in (objects?.enumerated())!{
            //item.tripname =
            
        //}
        CoreDataStack.share.saveContext()
        try? fetchresultcntrller.managedObjectContext.save()
        
    
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchresultcntrller.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fetchresultcntrller.object(at: indexPath).cityname ?? "NA"
        //let temp = fetchresultcntrller.object(at: indexPath).temp ?? "NA"
        cell.detailTextLabel?.text = "\(Int(fetchresultcntrller.object(at: indexPath).temp) - Int(273.15))℃"
        let image1 = "http://openweathermap.org/img/wn/\(fetchresultcntrller.object(at: indexPath).icon ?? "10d")@2x.png"
        Service.fetchImg(urlstr: image1){(image) in
            cell.imageView?.image = image
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchresultcntrller.sections?[section].name ?? "Na"
    }
    
    
}
extension firstTableViewController : NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Updates wrapper end
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Section update(s)
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    // Row update(s)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        default:
            print("Row update error")
        }
    }
    
}

