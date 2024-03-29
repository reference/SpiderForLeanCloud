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
//// 技师列表
#import <Foundation/Foundation.h>

@interface SPTechnicianModel : NSObject
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSNumber *rate;
@property (nonatomic,strong) NSNumber *level;
@property (nonatomic,strong) NSString *descrip;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,assign) BOOL isFavorite;

+ (void)requestList:(void(^)(NSArray *data,NSError *error))completion;
@end
