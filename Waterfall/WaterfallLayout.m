//
//  WaterfallLayout.m
//  Waterfall
//
//  Created by sumeng on 12/8/14.
//  Copyright (c) 2014 sumeng. All rights reserved.
//

#import "WaterfallLayout.h"

@interface WaterfallLayout ()

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSMutableArray *frameByIndexPaths;
@property (nonatomic, strong) NSMutableArray *bottomNumbers;

@end

@implementation WaterfallLayout

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _numColumns = 2;
        _spacing = 8;
        _frameByIndexPaths = [[NSMutableArray alloc] init];
        _bottomNumbers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    _count = [self.collectionView numberOfItemsInSection:0];
    _itemWidth = (self.collectionView.frame.size.width-(_numColumns+1)*_spacing)/_numColumns;
    [_frameByIndexPaths removeAllObjects];
    [_bottomNumbers removeAllObjects];
    
    for (int i = 0; i < _count; i++) {
        CGFloat h = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]) {
            h = [_delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self insertFrame:h];
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, [self getBottom]+_spacing);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < _count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (attributes.frame.origin.y+attributes.frame.size.height >= rect.origin.y
            && attributes.frame.origin.y < rect.origin.y+rect.size.height) {
            [array addObject:attributes];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [[_frameByIndexPaths objectAtIndex:indexPath.row] CGRectValue];
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

#pragma mark - Native

- (void)insertFrame:(CGFloat)h {
    CGPoint point;
    if (_bottomNumbers.count < _numColumns) {
        point = CGPointMake(_spacing+(_spacing+_itemWidth)*_bottomNumbers.count, _spacing);
        [_bottomNumbers addObject:[NSNumber numberWithFloat:_spacing+h]];
    }
    else {
        NSInteger index = 0;
        CGFloat bottom = [(NSNumber *)[_bottomNumbers objectAtIndex:0] floatValue];
        for (int i = 1; i < _bottomNumbers.count; i++) {
            NSNumber *number = [_bottomNumbers objectAtIndex:i];
            CGFloat b = [number floatValue];
            if (b < bottom) {
                index = i;
                bottom = b;
            }
        }
        point = CGPointMake(_spacing+(_spacing+_itemWidth)*index, bottom+_spacing);
        [_bottomNumbers replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:bottom+_spacing+h]];
    }
    CGRect frame = CGRectMake(point.x, point.y, _itemWidth, h);
    [_frameByIndexPaths addObject:[NSValue valueWithCGRect:frame]];
}

- (CGFloat)getBottom {
    CGFloat bottom = 0;
    for (NSNumber *number in _bottomNumbers) {
        CGFloat h = [number floatValue];
        if (h > bottom) {
            bottom = h;
        }
    }
    return bottom;
}

@end
