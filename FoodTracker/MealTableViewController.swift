//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Tandem on 03/10/2017.
//  Copyright © 2017 Tandem. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    
    //This code declares a property and initializes it with a default value (an empty array of Meal objects)
    //By making meals a variable (var) instead of a constant, you make the array mutable, which means you can add items to it after you initialize it.
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //load nay saved meals, othersize load sample data
        if let savedMeals = loadMeals(){ //if successfully return a meal object, condition is true, then if statement get executed
            meals += savedMeals
        }else{
            //load the sample data
            loadSampleMeals()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    //these 3 methods below are required for a fucntioing table
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //in this project ths list only return 1 section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count // return the size of the array
    }

    //For table views with a small number of rows, all rows may be onscreen at once, so this method gets called for each row in your table.
    //But table views with a large number of rows display only a small fraction of their total items at a given time.
    //It’s most efficient for table views to ask for only the cells for rows that are being displayed, and that’s what tableView(_:cellForRowAt:) allows the table view to do.
    //check doc for more info on this, check -create a table view, search for comment above this
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //table view cells are resued and should be dequeued usng a cell identifier
        let cellIdentifier = "MealTableViewCell" //This creates a constant with the identifier you set in the storyboard
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{ //? means optional
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // fetches the appropriate meal for the data source layout
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let MealDetailViewController = segue.destination as? MealViewController else{
                fatalError("Unexpected destination : \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else{
                fatalError("Unexpected sender : \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else{
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            MealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected segue identifier; \(segue.identifier)")
        }
    }
 
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        print("reach unwind method")
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal{
            
            //This code checks whether a row in the table view is selected. If it is, that means a user tapped one of the table views cells to edit a meal. In other words, this if statement gets executed when you are editing an existing meal.
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //update an existing meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{ //means the user tap on the add meal button
                // add a new meal
                //This code computes the location in the table view where the new table view cell representing the new meal will be inserted, and stores it in a local constant called newIndexPath
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                print("before append")
                meals.append(meal)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //save the meals
            saveMeals()
            
            
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleMeals(){
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
    
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else{
            fatalError("unable to instantiate meal1")
        }
    
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else{
        fatalError("unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta and Meatballs", photo: photo3, rating: 3) else{
        fatalError("unable to instantiate meal3")
        }
    
        meals += [meal1,meal2,meal3] //add to array
    }
    
    private func saveMeals(){ //save to db
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path) //will return true if successfully saved
        
        //test if really saved successfully
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    //This method has a return type of an optional array of Meal objects, meaning that it might return an array of Meal objects or might return nothing (nil).
    private func loadMeals() -> [Meal]? {
        //This method attempts to unarchive the object stored at the path Meal.ArchiveURL.path and downcast that object to an array of Meal objects. This code uses the as? operator so that it can return nil if the downcast fails. This failure typically happens because an array has not yet been saved. In this case, the unarchiveObject(withFile:) method returns nil. The attempt to downcast nil to [Meal] also fails, itself returning nil.
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

}
