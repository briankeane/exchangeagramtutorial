//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Brian D Keane on 4/3/15.
//  Copyright (c) 2015 Brian D Keane. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem)
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData
    @NSManaged var thumbnail: NSData

}
