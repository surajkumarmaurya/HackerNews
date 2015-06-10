//
//  CommentID.h
//  
//
//  Created by Suraj Kumar on 6/6/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stories;

@interface CommentID : NSManagedObject

@property (nonatomic, retain) NSNumber * commentID;
@property (nonatomic, retain) Stories *stories;

@end
