//
//  Stories.h
//  
//
//  Created by Suraj Kumar on 6/6/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CommentID;

@interface Stories : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * storyID;
@property (nonatomic, retain) NSOrderedSet *commentID;
@end

@interface Stories (CoreDataGeneratedAccessors)

- (void)insertObject:(CommentID *)value inCommentIDAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentIDAtIndex:(NSUInteger)idx;
- (void)insertCommentID:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentIDAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentIDAtIndex:(NSUInteger)idx withObject:(CommentID *)value;
- (void)replaceCommentIDAtIndexes:(NSIndexSet *)indexes withCommentID:(NSArray *)values;
- (void)addCommentIDObject:(CommentID *)value;
- (void)removeCommentIDObject:(CommentID *)value;
- (void)addCommentID:(NSOrderedSet *)values;
- (void)removeCommentID:(NSOrderedSet *)values;
@end
