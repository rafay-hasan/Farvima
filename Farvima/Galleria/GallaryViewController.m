//
//  GallaryViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/23/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "GallaryViewController.h"
#import "MessageViewController.h"

@interface GallaryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;

@end

@implementation GallaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallaryCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger size = (int)[[UIScreen mainScreen] nativeBounds].size.height;
    if (size == 1136) {
        printf("iPhone 5 or 5S or 5C");
        return CGSizeMake(135, 135);
    }
    else if (size == 1334) {
        printf("iPhone 6/6S/7/8");
        return CGSizeMake(155, 155);
    }
    else if (size == 2208) {
        printf("iPhone 6+/6S+/7+/8+");
        return CGSizeMake(170, 170);
    }
    else if (size == 2436) {
        printf("iPhone X");
        return CGSizeMake(160, 160);
    }
    else {
        printf("unknown");
        return CGSizeMake(130, 150);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16.0;
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)messageButtonAction:(id)sender {
    if (![self isControllerAlreadyOnNavigationControllerStack]) {
        //push controller
        MessageViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}
-(BOOL)isControllerAlreadyOnNavigationControllerStack{
    MessageViewController *messageVc = [MessageViewController new];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:messageVc.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

@end
