/**
 MIT License
 
 Copyright (c) 2018 Scott Ban (https://github.com/reference/SpiderForLeanCloud)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)loadData
{
    [SPTechnicianModel requestList:^(NSArray *data, NSError *error) {
        if (error) {
            NSLog(@"错误了：%@",error);
        }else{
            [self.dataArray addObjectsFromArray:data];
            [self insertIntoLeanCloud];
        }
    }];
}

- (void)insertIntoLeanCloud
{
    if (self.dataArray.count) {
        NSDictionary *info = self.dataArray.lastObject;
        AVObject *lc = [[AVObject alloc] initWithClassName:@"SpiderData"];// 构建对象
        NSString *avatar = info[@"workPhoto"];
        if ([avatar isKindOfClass:NSNull.class] || [avatar isEmpty]) {
            [self.dataArray removeLastObject];
            [self insertIntoLeanCloud];
        }
        else{
            [lc setObject:info[@"tags"] forKey:@"tags"];
            [lc setObject:info[@"age"] forKey:@"age"];
            [lc setObject:info[@"gender"] forKey:@"sex"];
            [lc setObject:info[@"description"] forKey:@"descrip"];
            [lc setObject:info[@"name"] forKey:@"name"];
            [lc setObject:info[@"city"] forKey:@"city"];
            [lc setObject:info[@"level"] forKey:@"rate"];
            [lc setObject:info[@"level"] forKey:@"level"];
            [lc setObject:info[@"isFavorite"] forKey:@"isFavorite"];
            int price = [self getRandomNumber:400 to:500];
            [lc setObject:@(price) forKey:@"price"];
            [lc setObject:info[@"workPhoto"] forKey:@"avatar"];// 设置名称
            [lc saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self.dataArray removeLastObject];
                if (self.dataArray.count == 0) {
                    NSLog(@"数据插入完毕");
                }else{
                    [self insertIntoLeanCloud];
                }
            }];
        }
    }
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}
@end
