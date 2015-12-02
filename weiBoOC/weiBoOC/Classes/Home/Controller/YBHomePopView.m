//
//  YBHomePopView.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePopView.h"

@interface YBHomePopView () <UITableViewDataSource, UITableViewDelegate>

/// 数据源
@property(nonatomic, strong) NSArray *dataArr;

@end

@implementation YBHomePopView

#pragma mark - 构造方法
- (instancetype)init {
    if (self = [super init]) {
        // 设置代理
        self.delegate = self;
        self.dataSource = self;
        // 注册Cell
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YBHomePopViewCell"];
        // 
    }
    return self;
}

#pragma mark - 数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBHomePopViewCell"];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YBLog(@"%zd",indexPath.row);
}

#pragma mark - 懒加载
/// 数据源懒加载
- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"000",@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888",@"999"];
    }
    return _dataArr;
}

@end
