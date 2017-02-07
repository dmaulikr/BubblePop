//
//  PlayingFieldViewController.h
//  BubblePop
//
//  Created by Nghia Quach on 5/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingFieldViewController : UIViewController{
    
    NSString *playerName;
    NSMutableArray *bubbleViewList;
    NSMutableArray *bubbleListEachScene;
    NSMutableArray *compareTimeForScore;
    NSTimer *timerForBubble;
    
    int totalscore;
    int countDownTime;
    int timeDuration;
    int countDown;
    int timeLeft;
    int highestScore;
    int maxBubbles;
    int gameSpeed;
}

@property (weak, nonatomic) IBOutlet UIView *timeLeftView;
@property (retain, nonatomic) NSString *playerName;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic,retain) IBOutlet UIView *redBubbleView;
@property (nonatomic,retain) IBOutlet UIView *pinkBubbleView;
@property (nonatomic,retain) IBOutlet UIView *greenBubbleView;
@property (nonatomic,retain) IBOutlet UIView *blueBubbleView;
@property (nonatomic,retain) IBOutlet UIView *blackBubbleView;
@end
