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
#import "ABHTTP.h"

@implementation ABHTTP
+ (void)requestWithURL:(NSString *)url
                params:(NSDictionary *)params
                  body:(id)body
         responseClass:(Class)responseClass
     responseDataClass:(NSDictionary *)responseDataClass
            completion:(void(^)(id responseObject, NSError *error))completion {
    [ABHTTP requestWithURL:url params:params body:body completion:^(id responseObject, NSError *error) {
        id response = responseObject;
        if (response && responseClass) {
            if ([response isKindOfClass:[NSArray class]]) {
                response = [NSArray yy_modelArrayWithClass:responseClass json:responseObject];
            } else {
                response = [responseClass yy_modelWithJSON:responseObject];
            }
            if (response) {
                NSArray *keys = [responseDataClass allKeys];
                for (NSString *key in keys) {
                    if ([response respondsToSelector:NSSelectorFromString(key)]) {
                        id data = [response valueForKey:key];
                        Class dataClass = [responseDataClass objectForKey:key];
                        if (data && dataClass) {
                            if ([data isKindOfClass:[NSArray class]]) {
                                data = [NSArray yy_modelArrayWithClass:dataClass json:data];
                            } else {
                                data = [dataClass yy_modelWithJSON:data];
                            }
                            if (data) {
                                [response setValue:data forKey:key];
                            }
                        }
                    }
                }
            }
        }
        if (completion) {
            completion(response, error);
        }
    }];
}

+ (void)requestWithURL:(NSString *)url
                params:(NSDictionary *)params
                  body:(id)body
            completion:(void(^)(id responseObject, NSError *error))completion {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"charset=UTF-8"];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        manager.responseSerializer.acceptableContentTypes = contentTypes;
    });
    NSString *query = AFQueryStringFromParameters(params);
    if (query) {
        url = [url stringByAppendingFormat:@"?%@", query];
    }
    
    if (body == nil) {
        //header
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLogD(@"GET %@\nParams:%@\nResponse:%@", url, [params yy_modelToJSONObject], [responseObject yy_modelToJSONObject]);
            if (![responseObject[@"status"] isEqualToString:@"ok"]) {
                if (completion) {
                    completion(nil, [NSError errorWithDomain:@"HTTP" code:[responseObject[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"]}]);
                }
            }
            else{
                if (completion) {
                    completion(responseObject, nil);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLogA(@"GET %@\n%@", url, error.localizedDescription);
            if (completion) {
                completion(task.response, error);
            }
        }];
    } else {
        // JSON
        if ([JSONObject isValidJSONObject:body]) {
            params = body;
        } else { // params in body
            if ([body isKindOfClass:NSData.class]) {
                params = [JSONObject JSONObjectWithData:body];
            } else if ([body isKindOfClass:NSString.class]) {
                params = [JSONObject JSONObjectWithString:body];
            }
            if (params == nil) {
                params = body;
            }
        }
        //
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLogD(@"POST %@\nPARAMS:%@\nRESPONSE:%@", url, [params yy_modelToJSONObject], [responseObject yy_modelToJSONObject]);
            if (![responseObject[@"status"] isEqualToString:@"ok"]) {
                if (completion) {
                    completion(nil, [NSError errorWithDomain:@"HTTP" code:[responseObject[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"]}]);
                }
            }
            else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLogA(@"POST %@\n%@", url, error.localizedDescription);
            if (completion) {
                completion(task.response, error);
            }
        }];
    }
}

+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params data:(NSArray<ZXHTTPFormData *> *)data responseClass:(Class)responseClass completion:(void (^)(id, NSError *))completion {
    [ZXHTTPClient POST:url params:params formData:data requestHandler:^(NSMutableURLRequest *request) {
        //
    } completionHandler:^(NSURLSessionDataTask *task, NSData *data, NSError *error) {
        id response = task.response;
        if (data && responseClass) {
            if ([response isKindOfClass:[NSArray class]]) {
                response = [NSArray yy_modelArrayWithClass:responseClass json:data];
            } else {
                response = [responseClass yy_modelWithJSON:data];
            }
        }
        if (completion) {
            completion(response, error);
        }
    }];
}

+ (void)uploadWithURL:(NSString *)url
               params:(NSDictionary *)params
                 data:(NSArray<ZXHTTPFormData *> *)data
        responseClass:(Class)responseClass
    responseDataClass:(NSDictionary *)responseDataClass
             progress:(void(^)(NSProgress *progress))progressCallback
           completion:(void(^)(id responseObject, NSError *error))completion
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"charset=UTF-8"];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        manager.responseSerializer.acceptableContentTypes = contentTypes;
    });
    
    //post
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data.lastObject.data name:data.lastObject.name fileName:data.lastObject.fileName mimeType:data.lastObject.mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressCallback) {
            progressCallback(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        NSLogD(@"POST %@\nPARAMS:%@\nRESPONSE:%@", url, [params yy_modelToJSONObject], [responseObject yy_modelToJSONObject]);
        NSDictionary *respObj = responseObject;
        if (![respObj.allKeys containsObject:@"data"]) {
            responseObject = @{@"success":@(YES),@"msg":[NSNull null],@"data":responseObject,@"code":@(200)};
        }
        if (![responseObject[@"status"] isEqualToString:@"ok"]) {
            if (completion) {
                completion(nil, [NSError errorWithDomain:@"HTTP" code:[responseObject[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"]}]);
            }
        }
        else{
            id response = responseObject;
            if (response && responseClass) {
                if ([response isKindOfClass:[NSArray class]]) {
                    response = [NSArray yy_modelArrayWithClass:responseClass json:responseObject];
                } else {
                    response = [responseClass yy_modelWithJSON:responseObject];
                }
                if (response) {
                    NSArray *keys = [responseDataClass allKeys];
                    for (NSString *key in keys) {
                        if ([response respondsToSelector:NSSelectorFromString(key)]) {
                            id data = [response valueForKey:key];
                            Class dataClass = [responseDataClass objectForKey:key];
                            if (data && dataClass) {
                                if ([data isKindOfClass:[NSArray class]]) {
                                    data = [NSArray yy_modelArrayWithClass:dataClass json:data];
                                } else {
                                    data = [dataClass yy_modelWithJSON:data];
                                }
                                if (data) {
                                    [response setValue:data forKey:key];
                                }
                            }
                        }
                    }
                }
            }
            if (completion) {
                completion(response, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLogA(@"POST %@\n%@", url, error.localizedDescription);
        if (completion) {
            completion(task.response, error);
        }
    }];
}
@end
