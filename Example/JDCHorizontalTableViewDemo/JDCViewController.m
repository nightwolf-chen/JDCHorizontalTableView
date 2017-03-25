//
//  ViewController.m
//  HorizontalTableView
//
//  Created by exitingchen on 15/1/27.
//  Copyright (c) 2015年 Nirvawolf. All rights reserved.
//

#import "JDCViewController.h"

static NSString *const kReuableIdentifier = @"ReuableCell";

@interface JDCViewController ()
@property (nonatomic,strong) JDCHorizontalTableView *tableView;
@end

@implementation JDCViewController

- (void)viewDidLoad {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.tableView = [[JDCHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 300)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
    _tableView.center = CGPointMake(screenWidth/2.0f,screenHeight/2.0f);
    
    
    [_tableView registerReuableCellClass:[JDCHorizontalTableCell class]
                      reuabelIndentifier:kReuableIdentifier];
    
    UINib *nib = [UINib nibWithNibName:@"JDCCustomCell" bundle:[NSBundle mainBundle]];
    [_tableView registerReuableCellNib:nib
                    reuabelIndentifier:kReuableIdentifier];
    
    [_tableView reloadData];
    
//    _tableView.pagingEnabled = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate and datasouce
- (JDCHorizontalTableCell *)ps_tableView:(JDCHorizontalTableView *)tableView columForIndexPath:(NSUInteger)index
{
    JDCHorizontalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuableIdentifier];
    
    if (index % 2 == 0) {
        cell.backgroundColor = [UIColor orangeColor];
    }else{
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}

- (CGFloat)ps_tableViewWidthForColum:(JDCHorizontalTableView *)tableView colum:(NSUInteger)colum
{
    return 80;
}

- (NSUInteger)numberOfColums:(JDCHorizontalTableView *)tableView
{
    return 10;
}


@end
