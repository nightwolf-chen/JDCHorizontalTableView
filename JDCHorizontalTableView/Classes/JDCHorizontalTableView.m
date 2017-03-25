//
//  JDCHorizontalTableView.m
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

#import "JDCHorizontalTableView.h"
#import "JDCHorizontalTableCell.h"

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

typedef enum PSTemplateContainerScrollDirection{
    PSTemplateContainerScrollDirectionLeft,
    PSTemplateContainerScrollDirectionRight,
    PSTemplateContainerScrollDirectionStill
}PSTemplateContainerScrollDirection;

static const CGFloat kColumMargin = 0;
static const CGFloat kColumWidth = 80;

/**
 Privte class
 */
@interface JDCHorizontalTableCellModel : NSObject
@property (nonatomic,assign) CGFloat startX;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) JDCHorizontalTableCell *cachedCell;
@end

//////////////////////////////////////////////////////////////////////////////
@interface JDCHorizontalTableView ()
@property (nonatomic,strong) NSArray *columModels;
@property (nonatomic,strong) NSMutableArray *resuableColumes;
@property (nonatomic,strong) NSMutableIndexSet *visibleColums;

@property (nonatomic,strong) NSMutableDictionary *registerdReuableCellClass;
@property (nonatomic,strong) NSMutableDictionary *registerdReuableCellNib;

@end


@implementation JDCHorizontalTableView

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _columModels = @[] ;
        _resuableColumes = [NSMutableArray array];
        _visibleColums = [[NSMutableIndexSet alloc] init];
        _registerdReuableCellClass = [[NSMutableDictionary alloc] init];
        _registerdReuableCellNib = [[NSMutableDictionary alloc] init];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}

- (void) reloadData
{
    [self returnNonVisibleColumsToThePool: nil];
    [self generateHeightAndOffsetData];
    [self layoutTableColums];
}


- (CGFloat )columWidth
{
    return kColumWidth;
}

- (void) generateHeightAndOffsetData
{
    CGFloat currentOffsetX = 0.0;
    
    BOOL checkWidthForEachColum = [[self delegate] respondsToSelector: @selector(ps_tableViewWidthForColum:colum:)];
    
    NSMutableArray* newColumModels = [NSMutableArray array];
    
    NSInteger numberOfColums = [[self dataSource] numberOfColums:self];
    
    for (NSInteger colum = 0; colum < numberOfColums; colum++)
    {
        JDCHorizontalTableCellModel* columModel = [[JDCHorizontalTableCellModel alloc] init];
        
        CGFloat columWidth = checkWidthForEachColum ? [[self delegate] ps_tableViewWidthForColum:self colum:colum] : [self columWidth];
        
        columModel.width = columWidth + kColumMargin;
        columModel.startX = currentOffsetX + kColumMargin;
        
        [newColumModels addObject:columModel];
        
        currentOffsetX += (columWidth + kColumMargin);
    }
    
    self.columModels = newColumModels;
    
    [self setContentSize: CGSizeMake(currentOffsetX, self.bounds.size.height)];
}

- (NSInteger) findColumForOffsetX: (CGFloat) xPosition inRange: (NSRange) range
{
    if ([[self columModels] count] == 0) return 0;
    
    JDCHorizontalTableCellModel* cellModel = [[JDCHorizontalTableCellModel alloc] init];
    cellModel.startX = xPosition;
    
    NSInteger returnValue = [[self columModels] indexOfObject: cellModel
                                                inSortedRange: range
                                                      options: NSBinarySearchingInsertionIndex
                                              usingComparator: ^NSComparisonResult(JDCHorizontalTableCellModel* cellModel1, JDCHorizontalTableCellModel* cellModel2){
                                                     if (cellModel1.startX < cellModel2.startX)
                                                         return NSOrderedAscending;
                                                     return NSOrderedDescending;
                                             }];
    if (returnValue == 0) return 0;
    return returnValue-1;
}

- (void) layoutTableColums
{
    if (_columModels.count <= 0) {
        return;
    }
    
    CGFloat currentStartX = [self contentOffset].x;
    CGFloat currentEndX = currentStartX + [self frame].size.width;
    
    NSInteger columToDisplay = [self findColumForOffsetX:currentStartX inRange:NSMakeRange(0, _columModels.count)];
    
    NSMutableIndexSet* newVisibleColums = [[NSMutableIndexSet alloc] init];
    
    CGFloat xOrgin;
    CGFloat columWidth;
    do
    {
        [newVisibleColums addIndex: columToDisplay];
        
        xOrgin = [self cellModelAtIndex:columToDisplay].startX;
        columWidth = [self cellModelAtIndex:columToDisplay].width;
        
        JDCHorizontalTableCell *cell = [self cellModelAtIndex:columToDisplay].cachedCell;
        
        if (!cell)
        {
            cell = [[self dataSource] ps_tableView:self columForIndexPath:columToDisplay];
            [self cellModelAtIndex:columToDisplay].cachedCell = cell;
            
            cell.frame = CGRectMake(xOrgin, 0, columWidth - kColumMargin, self.bounds.size.height);
            [self addSubview: cell];
        }
        
        columToDisplay++;
    }
    while (xOrgin + columWidth < currentEndX && columToDisplay < _columModels.count);
    
    
//    NSLog(@"laying out %ld row", [_columModels count]);
    
    [self returnNonVisibleColumsToThePool:newVisibleColums];
}

- (JDCHorizontalTableCellModel *)cellModelAtIndex:(NSUInteger)columIndex
{
    if (columIndex < _columModels.count) {
        return _columModels[columIndex];
    }
    
    return nil;
}

- (JDCHorizontalTableCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    JDCHorizontalTableCell *poolCell = nil;
    
    for(JDCHorizontalTableCell *cell in _resuableColumes){
        if ([cell.reusableIdentifier isEqual:reuseIdentifier]) {
            poolCell = cell;
            break;
        }
    }
    
    if (poolCell) {
        [_resuableColumes removeObject:poolCell];
    }
    
    if (!poolCell) {
        
        UINib *cellNib =_registerdReuableCellNib[reuseIdentifier];
        if (cellNib) {
            poolCell = (id)[cellNib instantiateWithOwner:nil options:nil][0];
            poolCell.reusableIdentifier = reuseIdentifier;
        }
        
        Class cellClass = _registerdReuableCellClass[reuseIdentifier];
        if (cellClass && !poolCell) {
            poolCell = [cellClass new];
            poolCell.reusableIdentifier = reuseIdentifier;
        }
    }
    
    return poolCell;
}

- (void) returnNonVisibleColumsToThePool: (NSMutableIndexSet*) currentVisibleColums
{
    [_visibleColums removeIndexes:currentVisibleColums];
    [_visibleColums enumerateIndexesUsingBlock:^(NSUInteger columIdx, BOOL *stop)
     {
         JDCHorizontalTableCell* tableViewCell = [self cellModelAtIndex:columIdx].cachedCell;
         if (tableViewCell)
         {
             [_resuableColumes addObject:tableViewCell];
             [tableViewCell removeFromSuperview];
             [self cellModelAtIndex:columIdx].cachedCell = nil;
         }
     }];
    
    self.visibleColums = currentVisibleColums;
}


- (void)adjustCellAt:(NSUInteger)index
{
    if ([_visibleColums containsIndex:index]) {
        CGFloat coumWidth = [self cellModelAtIndex:index].width;
        CGFloat offset = self.contentOffset.x;
        JDCHorizontalTableCellModel *model = _columModels[index];
        CGFloat cellX = model.startX;
        if (cellX < offset) {
            CGPoint adjustedOffset = self.contentOffset;
            adjustedOffset.x -= (offset - cellX);
            [self setContentOffset:adjustedOffset animated:YES];
            return;
        }
        
        if (cellX + coumWidth > self.contentOffset.x + self.frame.size.width) {
            CGFloat delta =  (cellX + coumWidth) - (offset + self.frame.size.width);
            CGPoint adjustedOffset = self.contentOffset;
            adjustedOffset.x += delta;
            [self setContentOffset:adjustedOffset animated:YES];
            return;
        }

    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self layoutTableColums];
}

- (NSIndexSet*) indexSetOfVisibleColumIndexes
{
    return [_visibleColums copy];
}

#pragma mark - register reusable cell.
- (void)registerReuableCellClass:(Class)cellClass reuabelIndentifier:(NSString *)reuseIdentifier
{
    if (cellClass) {
        self.registerdReuableCellClass[reuseIdentifier] = cellClass;
    }
}

- (void)registerReuableCellNib:(UINib *)cellNib reuabelIndentifier:(NSString *)reuseIdentifier
{
    if (cellNib) {
        self.registerdReuableCellNib[reuseIdentifier] = cellNib;
    }
}

@end

//////////////////////////////////////////////////////////////////////////////
//JDCHorizontalTableCellModel
@implementation JDCHorizontalTableCellModel

@end
