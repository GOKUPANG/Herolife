//
//  DeviceListController.h
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

#pragma mark - Init

+ (instancetype)modelWithImageNamed:(NSString *)imageNamed
                        description:(NSString *)description {
    return [[self alloc] initWithImageNamed:imageNamed
                                description:description];
}

- (instancetype)initWithImageNamed:(NSString *)imageNamed
                       description:(NSString *)description {
    if (self = [super init]) {
        _image = [UIImage imageNamed:imageNamed];
        _imageDescription = description;
    }
    
    return self;
}

@end
