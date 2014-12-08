//
//  WaterfallVC.m
//  Waterfall
//
//  Created by sumeng on 12/8/14.
//  Copyright (c) 2014 sumeng. All rights reserved.
//

#import "WaterfallVC.h"
#import "WaterfallLayout.h"

@interface WaterfallVC () <WaterfallLayoutDelegate>

@end

@implementation WaterfallVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    WaterfallLayout *layout = (WaterfallLayout *)self.collectionViewLayout;
    layout.delegate = self;
    layout.numColumns = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Native

- (IBAction)onReloadClick:(id)sender {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [self.collectionView reloadData];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arc4random() % 20 + 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    UILabel* label = (UILabel *)[cell viewWithTag:9999];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.tag = 9999;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        [cell addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    [label sizeToFit];
    label.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    
    return cell;
}

#pragma mark <WaterfallLayoutDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return arc4random() % 100 + 30;
}

@end
