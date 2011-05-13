
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "macros.h"

@class UITableViewGroup;

@interface UITableViewRow : NSObject {
	id data;
	BOOL isEditable;
	BOOL isSelectable;
	UITableView * ownerTable;
	NSString * cellIdentifier;
	NSString * nibName;
	UITableViewCell * nibbedCell;
}

@property (nonatomic,retain) IBOutlet UITableView * ownerTable;
@property (nonatomic,retain) IBOutlet UITableViewCell * nibbedCell;
@property (nonatomic,copy) NSString * nibName;
@property (nonatomic,assign) BOOL isSelectable;
@property (nonatomic,assign) BOOL isEditable;
@property (nonatomic,copy) NSString * cellIdentifier;
@property (nonatomic,retain) id data;

+ (id) rowOfClass:(Class) _class withCellIdentifier:(NSString *) _cellIdentifier;
+ (id) rowOfClass:(Class) _class withNibName:(NSString *) _nibName andCellIdentifier:(NSString *) _cellIdentifier;
- (void) loadNib;
- (void) didLoadNib;
- (void) willLoadNib;
- (BOOL) canMoveRowInGroup:(UITableViewGroup *) _group atIndex:(NSInteger) _index;
- (id) getCachedRowForTable:(UITableView *) _tableView;
- (UITableViewCell *) cellForTable:(UITableView *) _tableView;

@end
