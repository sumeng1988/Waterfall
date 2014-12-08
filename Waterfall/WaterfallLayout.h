//
//  WaterfallLayout.h
//  Waterfall
//
//  Created by sumeng on 12/8/14.
//  Copyright (c) 2014 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterfallLayoutDelegate;

@interface WaterfallLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, weak) id<WaterfallLayoutDelegate> delegate;

@end

@protocol WaterfallLayoutDelegate <NSObject>

@required

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
