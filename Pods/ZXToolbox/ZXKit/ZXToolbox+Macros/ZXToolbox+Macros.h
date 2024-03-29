//
// ZXToolbox+Macros.h
// https://github.com/xinyzhao/ZXToolbox
//
// Copyright (c) 2019 Zhao Xin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#ifdef __OBJC__

#import "NSDate+ZXToolbox.h"

// The __FILE__ lastPathComponent
#ifndef __FILENAME__
#define __FILENAME__ [[[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent] UTF8String]
#endif

// NSLogA will always output like NSLog
#define NSLogA(format, ...) printf("%s [%s:%d] %s\n%s\n", [[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSSZ"] UTF8String], __FILENAME__, __LINE__, __FUNCTION__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])

// NSLogD will output like NSLog only when the DEBUG variable is set
#ifdef DEBUG
#define NSLogD(format, ...) NSLogA(format, ##__VA_ARGS__)
#else
#define NSLogD(format, ...)
#endif

#define NSStringFromCGRect2(rect) [NSString stringWithFormat:@"{x:%.2f, y:%.2f, w:%.2f, h:%.2f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]
#define NSStringFromCGPoint2(point) [NSString stringWithFormat:@"{x:%.2f, y:%.2f}", point.x, point.y]
#define NSStringFromCGSize2(size) [NSString stringWithFormat:@"{w:%.2f, h:%.2f}", size.width, size.height]
#define NSStringFromUIEdgeInsets2(inset) [NSString stringWithFormat:@"{l:%.2f, t:%.2f, r:%.2f, b:%.2f}", inset.left, inset.top, inset.right, inset.bottom]

#endif // __OBJC__
