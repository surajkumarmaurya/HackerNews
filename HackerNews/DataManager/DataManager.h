//
//  DataManager.h
//  HackerNews
//
//  Created by Suraj Kumar on 6/2/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DataManager*)sharedInstance;
- (NSManagedObjectContext*)managedObjectContext;
@end
