//
//  Meal.swift
//  FoodTracker
//
//  Created by Tandem on 28/09/2017.
//  Copyright © 2017 Tandem. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding{ // to subclass from the NSObject class:,NSCoding to adopt the NSCoding protocol:
    //^^ Meal is now a subcalss of OSObject
    
    //Mark: Properties
    
    // var means the variable can change
    // let means they are constants, cannot change
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    //You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class. Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
    
    //The DocumentsDirectory constant uses the file manager’s urls(for:in:) method to look up the URL for your app’s documents directory. This is a directory where your app can save data for the user. This method returns an array of URLs, and the first parameter returns an optional containing the first URL in the array. However, as long as the enumerations are correct, the returned array should always contain exactly one match. Therefore, it’s safe to force unwrap the optional.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //After determining the URL for the documents directory, you use this URL to create the URL for your apps data. Here, you create the file URL by appending meals to the end of the documents URL
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    //MARK: Types
    
    struct PropertyKey {
        //The static keyword indicates that these constants belong to the structure itself, not to instances of the structure. You access these constants using the structure’s name (for example, PropertyKey.name).
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //Mark: Initialization
    // a method that prepares an instance of a class for use, setting initial value
    // something like java constructer
    init?(name: String, photo: UIImage?, rating: Int) { //init? means failable init
//        print("name : ", name)

        //A guard statement declares a condition that must be true in order for the code after the guard statement to be executed.
        // the name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //rating must be 0-5
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK: NSCoing
    //The NSCoding protocol declares two methods that any class that adopts to it must implement so that instances of that class can be encoded and decoded:
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    //The required modifier means this initializer must be implemented on every subclass, if the subclass defines its own initializers.
    //The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
    required convenience init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode the name for a meal object", log: OSLog.default, type: .debug)
            return nil
        }
        
        //becuse photo is an optional property of meal, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //Because the return value of decodeIntegerForKey is Int, there’s no need to downcast the decoded value and there is no optional to unwrap.
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //must call designated initializer
        self.init(name: name, photo: photo, rating: rating)
    }
}
