//
//  Utility.m
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import "Utility.h"
#import "Constant.h"

@implementation Utility

+ (id)sharedIntance {
    static Utility *shareInstance = nil;
    @synchronized(self) {
        if (shareInstance == nil)
            shareInstance = [[self alloc] init];
    }
    return shareInstance;
}

//save setting value
-(void)saveSettingValue:(int)value withKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
}

//get setting value by key
-(int)getSettingValueWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[NSString stringWithFormat:@"%@",[defaults objectForKey:key]]intValue];
}

//get platers
-(NSMutableArray*)getPlayers{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PLAYER_KEY];
}
//add new player name and player score to NSUserDefaults
-(void)addPlayer:(NSString*)playerName withScore:(int)score{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *players = [[defaults objectForKey:PLAYER_KEY] mutableCopy];
    
    if(players==nil){
        players = [[NSMutableArray alloc] init];
    }
    [players addObject:[NSString stringWithFormat:@"%i@%@",score,playerName]];
    [defaults setObject:players forKey:PLAYER_KEY];
    [defaults synchronize];
}
//get highest score of the player
-(int)getHighestScoreWithPlayerName:(NSString*) thePlayerName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *players = [defaults objectForKey:PLAYER_KEY];
    
    int highestScore = 0;
    for (int i=0; i<[players count]; i++) {
        NSString *playerName = [[[players objectAtIndex:i] componentsSeparatedByString: @"@"]objectAtIndex:1];
        int score = [[[[players objectAtIndex:i] componentsSeparatedByString: @"@"]objectAtIndex:0]intValue];
        
        if([playerName isEqualToString:thePlayerName]){
            if(score>highestScore){
                highestScore = score;
            }
        }
    }
    return highestScore;
}


@end
