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
#import "SPTechnicianModel.h"

@implementation SPTechnicianModel

+ (void)requestList:(void(^)(NSArray *data,NSError *error))completion
{
    NSString *url = @"http://api.daoway.cn/daoway/rest/technician/800ff6443dd043b39c7f17ede21dfc9d/technician/list?city=%E5%8C%97%E4%BA%AC&idfa=084F5D64-3857-43CE-BE22-FF9F91C98CCA&lat=40.00217819213867&lot=116.4881820678711&size=1000&start=0&udid=084F5D64-3857-43CE-BE22-FF9F91C98CCA&userId=460e9180e8f14c5f922fa39b76c46987";
    [ABHTTP requestWithURL:url
                    params:nil
                      body:nil
             responseClass:StandardHTTPResponse.class
         responseDataClass:nil
                completion:^(id responseObject, NSError *error) {
                    if (completion) {
                        StandardHTTPResponse *resp = responseObject;
                        completion(resp.data,error);
                    }
                }];
}
@end
