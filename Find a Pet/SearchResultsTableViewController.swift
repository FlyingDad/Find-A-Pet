//
//  SearchResultsTableViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/16/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UITableViewController {

    var coreDataStack: CoreDataStack!
    var fetchRequest: NSFetchRequest<Pet>!
    var pets: [Pet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = coreDataStack.managedContext.persistentStoreCoordinator?.managedObjectModel,
            let fetchRequest = model.fetchRequestTemplate(forName: "FetchAll") as? NSFetchRequest<Pet> else {
                    return
        }
        self.fetchRequest = fetchRequest
        fetchAndReload()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath)

        let pet = pets[indexPath.row]
        cell.textLabel?.text = pet.name
        print("Cell: \(pet.name)")
        cell.detailTextLabel?.text = pet.animal

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func refresh(_ sender: Any) {
        fetchAndReload()
    }
    
    func fetchAndReload() {
        do {
            pets = try coreDataStack.managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}
