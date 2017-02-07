//
//  Setting.h
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject{
    int duration;
    int noOfBubble;
}

@property (nonatomic,readwrite) int duration;
@property (nonatomic,readwrite) int noOfBubble;


@end
