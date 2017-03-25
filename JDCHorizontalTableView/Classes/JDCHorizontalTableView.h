//
// JDCHorizontalTableView.h
//
// Copyright (c) 2014–2017 Jidong Chen ( http://www.jidongchen.com/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "JDCHorizontalTableCell.h"

@class JDCHorizontalTableCell;
@class JDCHorizontalTableView;


/**
JDCHorizontalTableViewDelegate
 */
@protocol JDCHorizontalTableViewDelegate <NSObject,UIScrollViewDelegate>
@required

/**
 Use this method to tell tableview width of each colum

 @param tableView Target tableview
 @param columIdx Index of colum
 @return Width of colum at index columIdx
 */
- (CGFloat)ps_tableViewWidthForColum:(JDCHorizontalTableView *)tableView colum:(NSUInteger)columIdx;
@end


/**
 JDCHorizontalTableViewDataSource
 */
@protocol JDCHorizontalTableViewDataSource <NSObject>
@required

/**
 Returen Cell for tableview

 @param tableView The tableview.
 @param index Index for clum.
 @return JDCHorizontalTableCell instance.
 */
- (JDCHorizontalTableCell *)ps_tableView:(JDCHorizontalTableView *)tableView columForIndexPath:(NSUInteger)index;
- (NSUInteger)numberOfColums:(JDCHorizontalTableView *)tableView;
@end

@interface JDCHorizontalTableView : UIScrollView

@property (nonatomic,weak) id<JDCHorizontalTableViewDelegate> delegate;
@property (nonatomic,weak) id<JDCHorizontalTableViewDataSource> dataSource;


/**
 Ask tableview to return reuable cell. 
 You should set cell reuseIndentifier for reusing.

 @param reuseIdentifier Reusable identifier.
 @return JDCHorizontalTableCell instance
 */
- (JDCHorizontalTableCell *)dequeueReusableCellWithIdentifier: (NSString*) reuseIdentifier;


/**
 
 Register a nib which is used to create cell When you call dequeueReusableCellWithIdentifier 
 tableview and no reusable cell available.

 @param cellNib Nib of the Cell.
 @param reuseIdentifier Reusable identifier for the cell.
 */
- (void)registerReuableCellNib:(UINib*)cellNib reuabelIndentifier:(NSString *)reuseIdentifier;

/**
 
 Register a cell class for reusing with reuseIdentifier.
 When you call dequeueReusableCellWithIdentifier tableview will use this class to create cell with
 reuseIdentifier.

 @param cellClass Class type of cell.
 @param reuseIdentifier Reusable identifier for the cell.
 @warning If you register class and nib with same reuseIdentifier nib will be used.
 */
- (void)registerReuableCellClass:(Class)cellClass reuabelIndentifier:(NSString *)reuseIdentifier;

/**
 Reload cells in tableview.
 */
- (void)reloadData;


/**
 Get a set of indexes of tableview

 @return indexes set.
 */
- (NSIndexSet*) indexSetOfVisibleColumIndexes;


/**
 This method focus a cell adjust it's offset to avoid partially visible.

 @param index The indx of the cell to adjust.
 */
- (void)adjustCellAt:(NSUInteger)index;

@end





