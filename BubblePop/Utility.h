//
//  Utility.h
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(id)sharedIntance;
-(void)saveSettingValue:(int)value withKey:(NSString*)key;
-(int)getSettingValueWithKey:(NSString*)key;
-(NSMutableArray*)getPlayers;
-(void)addPlayer:(NSString*)playerName withScore:(int)score;
-(int)getHighestScoreWithPlayerName:(NSString*) thePlayerName;


@end
