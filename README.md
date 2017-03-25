# JDCHorizontalTableView

[![CI Status](http://img.shields.io/travis/nightwolf-chen/JDCHorizontalTableView.svg?style=flat)](https://travis-ci.org/nightwolf-chen/JDCHorizontalTableView)
[![Version](https://img.shields.io/cocoapods/v/JDCHorizontalTableView.svg?style=flat)](http://cocoapods.org/pods/JDCHorizontalTableView)
[![License](https://img.shields.io/cocoapods/l/JDCHorizontalTableView.svg?style=flat)](http://cocoapods.org/pods/JDCHorizontalTableView)
[![Platform](https://img.shields.io/cocoapods/p/JDCHorizontalTableView.svg?style=flat)](http://cocoapods.org/pods/JDCHorizontalTableView)

## Quick start

Create JDCHorizontalTableView as any other view and setup all the properties:
```objective-c
    self.tableView = [[JDCHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 300)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_tableView];
    _tableView.center = CGPointMake(screenWidth/2.0f,screenHeight/2.0f);

    [_tableView registerReuableCellClass:[JDCHorizontalTableCell class]
    reuabelIndentifier:kReuableIdentifier];

    UINib *nib = [UINib nibWithNibName:@"JDCCustomCell" bundle:[NSBundle mainBundle]];
    [_tableView registerReuableCellNib:nib
    reuabelIndentifier:kReuableIdentifier];
    [_tableView reloadData];
```

Just like UITableView. You just need setup delegate and data source first.
```objective-c
@interface JDCViewController : UIViewController<JDCHorizontalTableViewDataSource,JDCHorizontalTableViewDelegate>

@end
```

Implement the Datasource and Delegate methods
```objective-c

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

```

You are ready to go! 


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JDCHorizontalTableView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JDCHorizontalTableView"
```

## Author

Jidong Chen, jidongchen@gmail.com

## License

JDCHorizontalTableView is available under the MIT license. See the LICENSE file for more info.
