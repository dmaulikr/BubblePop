//
//  PlayingFieldViewController.m
//  BubblePop
//
//  Created by Nghia Quach on 5/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import "PlayingFieldViewController.h"
#import "Utility.h"
#import "Constant.h"

@interface PlayingFieldViewController ()
@end

@implementation PlayingFieldViewController
@synthesize playerName;

static int Width_Screen;
static int Height_Screen;

typedef enum BubbleType : NSUInteger {
    kRed=1,
    kPink=2,
    kGreen=3,
    kBlue=4,
    kBlack=5
} BubbleType;

typedef enum BubbleScore : NSUInteger {
    kRedScore = 1,
    kPinkScore = 2,
    kGreenScore = 5,
    kBlueScore = 8,
    kBlackScore = 10
} BubbleScore;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get current setting
    [self getSetting];
    
    //add bubbles to bubble list
    compareTimeForScore = [[NSMutableArray alloc] init];
    
    //init bubble list
    bubbleViewList = [[NSMutableArray alloc] init];
    
    //add bubble into bubble list
    [self addBubbblesToList];
    
    //star the game
    [self startTheGame];
}

//get and assign current setting from local persistence data
//ie time, max bubbles and screen size
//otherwise get default setting

-(void)getSetting{
    //Get current width and height of the screen
    Width_Screen = [[UIScreen mainScreen] bounds].size.width - 70;
    Height_Screen = [[UIScreen mainScreen] bounds].size.height - 110;
    
    timeDuration = [[Utility sharedIntance] getSettingValueWithKey:GAME_DURATION_KEY];
    
    if(timeDuration==0)timeDuration=Default_Duration_Time;
    
    maxBubbles = [[Utility sharedIntance] getSettingValueWithKey:MAX_BUBBLE_KEY];
    
    if(maxBubbles==0)maxBubbles=Default_Max_Bubble;
    
    countDown = timeDuration;
}

#pragma mark - Start the game

-(void)startTheGame{
    
    gameSpeed = DEFAULT_GAME_SPEED;
    
    highestScore = [[Utility sharedIntance] getHighestScoreWithPlayerName:playerName];
    _highscoreLabel.text = [NSString stringWithFormat:@"%i",highestScore];
    
    [self.view setUserInteractionEnabled:YES];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(doCountDown:)
                                                    userInfo:nil
                                                     repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    timerForBubble = [NSTimer scheduledTimerWithTimeInterval:gameSpeed
                                                      target:self
                                                    selector:@selector(doShowBubble:)
                                                    userInfo:nil
                                                     repeats:YES];
    NSRunLoop *runLoopForBubble = [NSRunLoop currentRunLoop];
    [runLoopForBubble addTimer:timerForBubble forMode:NSDefaultRunLoopMode];
}

#pragma mark - Do count down timer
//update time label, add animation
//speed up if the game spend over 1/3 time
//and stop the game if timer == 0

-(void)doCountDown:(NSTimer *)thetimer {
    countDown--;
    _timeLeftLabel.text = [NSString stringWithFormat:@"%i",countDown];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLeftLabel.frame.origin.x+25, _timeLeftLabel.frame.origin.y, _timeLeftLabel.frame.size.width, _timeLeftLabel.frame.size.height)];
    [_timeLeftView addSubview:tmpLabel];
    
    //do animation for count down timer
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         
                         tmpLabel.frame = CGRectMake(_timeLeftLabel.frame.origin.x+25, _timeLeftLabel.frame.origin.y-50, _timeLeftLabel.frame.size.width, _timeLeftLabel.frame.size.height);
                         tmpLabel.text = [NSString stringWithFormat:@"%i",countDown+1];
                         tmpLabel.alpha = 0.3;
                     }
                     completion:^(BOOL finished){
                         tmpLabel.frame = CGRectMake(_timeLeftLabel.frame.origin.x+25, _timeLeftLabel.frame.origin.y, _timeLeftLabel.frame.size.width, _timeLeftLabel.frame.size.height);
                         tmpLabel.text = [NSString stringWithFormat:@"%i",countDown+1];
                         tmpLabel.alpha = 1;
                         [tmpLabel removeFromSuperview];
                     }];
    
    //Speed up time 1second for bubble if the game spends more than half of the time
    if(countDown==timeDuration/3){
        gameSpeed=1;
        [timerForBubble invalidate];
        timerForBubble = [NSTimer scheduledTimerWithTimeInterval:gameSpeed
                                                    target:self
                                                  selector:@selector(doShowBubble:)
                                                  userInfo:nil
                                                  repeats:YES];
    }
    //stop the timer if count down is 0
    if(countDown==0){
        [thetimer invalidate];
        [timerForBubble invalidate];
        
        [[Utility sharedIntance] addPlayer:playerName withScore:totalscore];
        
        //disable user interaction and show the message
        [self.view setUserInteractionEnabled:NO];
        [self showAlertMessage];
    }
}

//show alert message at the end of the game
//with user's score, and options to stop or play again
-(void)showAlertMessage{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Game Over!"
                                          message:[NSString stringWithFormat:@"Your score is %i",totalscore]
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Play Again", @"Play Again")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self reset];
                                   [self startTheGame];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - Create Bubble for each frame
//create bubble for each type
- (UIView*) creatBubble:(BubbleType) bubbleType{
    
    UIView *tmpBubbleView = [[UIView alloc] initWithFrame:CGRectMake(rand() % Width_Screen, rand() % Height_Screen,Bubble_Width,Bubble_height)];
    tmpBubbleView.layer.cornerRadius = Bubble_height/2;
    tmpBubbleView.alpha = 0.5;
    
    //handle touch event for the bubble
    UITapGestureRecognizer *tmpBubbleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleBubbleTap:)];
    [tmpBubbleView addGestureRecognizer:tmpBubbleTap];
    
    //assign bubble view with color and tag
    switch (bubbleType) {
        case kRed:
            tmpBubbleView.backgroundColor = [UIColor redColor];
            tmpBubbleView.tag=kRed;
            break;
        case kPink:
            tmpBubbleView.backgroundColor = [UIColor colorWithRed:1 green:0.4 blue:0.7 alpha:0.5];
            tmpBubbleView.tag=kPink;
            break;
        case kGreen:
            tmpBubbleView.backgroundColor = [UIColor greenColor];
            tmpBubbleView.tag=kGreen;
            break;
        case kBlue:
            tmpBubbleView.backgroundColor = [UIColor blueColor];
            tmpBubbleView.tag=kBlue;
            break;
        case kBlack:
            tmpBubbleView.backgroundColor = [UIColor blackColor];
            tmpBubbleView.tag=kBlack;
            break;
            
        default:
            break;
    }
    
    return tmpBubbleView;
}

//add bubble to the list
- (void)addBubbblesToList{
    //calculate number of bubble need for game
    [self calculateNoOfBubble];
   
    //random bubble in list
    [self randomBubblesInList];
    
    //Add no of bubbles for each scene
    [self addBubbleForEachScene];
}

//calculate the ratio of bubbles based on its color
-(void)calculateNoOfBubble{
    int randomNumber = maxBubbles*timeDuration;
    //calculate ratio apperance for each bubble color
    int noOfRed =40*randomNumber/100;
    int noOfPink =30*randomNumber/100;
    int noOfGreen =15*randomNumber/100;
    int noOfBlue =10*randomNumber/100;
    int noOfBlack =5*randomNumber/100;
    
    for(int i=0;i<noOfRed;i++){
        [bubbleViewList addObject:[self creatBubble:kRed]];
    }
    for(int i=0;i<noOfPink;i++){
        [bubbleViewList addObject:[self creatBubble:kPink]];
    }
    for(int i=0;i<noOfGreen;i++){
        [bubbleViewList addObject:[self creatBubble:kGreen]];
    }
    for(int i=0;i<noOfBlue;i++){
        [bubbleViewList addObject:[self creatBubble:kBlue]];
    }
    for(int i=0;i<noOfBlack;i++){
        [bubbleViewList addObject:[self creatBubble:kBlack]];
    }
}

-(void)randomBubblesInList{
    //Random bubbles list
    for (int i = 0; i < bubbleViewList.count; i++) {
        int randomInt1 = arc4random() % [bubbleViewList count];
        int randomInt2 = arc4random() % [bubbleViewList count];
        [bubbleViewList exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
}

-(void)addBubbleForEachScene{
    bubbleListEachScene = [[NSMutableArray alloc]init];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    int j=0;
    
    for (int i=0; i<[bubbleViewList count]; i++) {
        j++;
        UIView *currView = [bubbleViewList objectAtIndex:i];
        [arr addObject:currView];
        if(j==maxBubbles-1){
            [bubbleListEachScene addObject:arr];
            arr = [[NSMutableArray alloc]init];
            j=0;
        }
    }
}

#pragma mark - Show Bubbles

-(void)doShowBubble:(NSTimer *)thetimer {
    [self showBubbleWithIndex:countDown];
}

//Remove the prev bubbles in view and display new bubbles on the screen without overlap
-(void)showBubbleWithIndex:(int)index{
    
    NSMutableArray *tmpList = [[NSMutableArray alloc] init];
    NSMutableArray *bubbleList = [bubbleListEachScene objectAtIndex:index];
    
    //remove bubbles from the view
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        long tag = v.tag;
        if(tag>0){
            [v removeFromSuperview];
        }
    }
    //reload the view
    [self.view setNeedsDisplay];
    
    for (int i=0; i<[bubbleList count]; i++) {
        UIView *currView = [bubbleList objectAtIndex:i];
        //assign new frame for new bubble if it is overlapping
        while([self isBubbleOverlapping:tmpList bubbleView:currView]){
            currView.frame = CGRectMake(rand() % Width_Screen, rand() % Height_Screen,Bubble_Width,Bubble_height);
        }
        [tmpList addObject:currView];
    }
    
    for (UIView *aView in tmpList) {
        [self.view addSubview:aView];
    }
}

//checking overlap between bubbles
-(BOOL)isBubbleOverlapping:(NSArray *)array bubbleView:(UIView *)theView {
    for (UIView *aView in [array copy]) {
        if (CGRectIntersectsRect(aView.frame, theView.frame)) return YES;
    }
    return NO;
}


#pragma mark - Handle touch event for Bubble

//handle touch event and start animation
//for bubbles when they are popped
//update total score

- (void)handleBubbleTap:(UITapGestureRecognizer *)recognizer{
    int tag = (int)recognizer.view.tag;
    
    //start animation for bubble
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x-(Bubble_Width/2), recognizer.view.frame.origin.y-(Bubble_Width/2),Bubble_Width*2,Bubble_height*2);
                         recognizer.view.layer.cornerRadius = (Bubble_height*2)/2;
                     }
                     completion:^(BOOL finished){
                         //remove bubble from view
                         [recognizer.view removeFromSuperview];
                         
                         recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y,Bubble_Width,Bubble_height);
                         recognizer.view.layer.cornerRadius = Bubble_height/2;
                     }];

    //update score
    [self increaseScore:tag];
    [self updateTotalScore];
}

#pragma mark - Update Score

//update score & bonus rate with bubble type
//based on its pre-defined points

-(void)increaseScore:(int)bubbleType{
    
    int prevBubbleType = 0;
    int prevTime = 0;
    
    //check if user pops two bubble at the same frame
    if([compareTimeForScore count]>0){
        prevBubbleType = [[compareTimeForScore objectAtIndex:0] intValue];
        prevTime = [[compareTimeForScore objectAtIndex:1]intValue]-gameSpeed+1;
        compareTimeForScore = [[NSMutableArray alloc]init];
    }
    [compareTimeForScore addObject:[NSString stringWithFormat:@"%i",bubbleType]];
    [compareTimeForScore addObject:[NSString stringWithFormat:@"%i",countDown]];
    
    switch (bubbleType) {
        case kRed:
            if(prevTime==countDown && prevBubbleType == kRed)
                totalscore+= ceil((float)kRedScore*(float)Bonus_Rate);
            else
                totalscore+=kRedScore;
            break;
        case kPink:
            if(prevTime==countDown && prevBubbleType == kPink)
                totalscore+= ceil((float)kPinkScore*(float)Bonus_Rate);
            else
                totalscore+=kPink;
            break;
        case kGreen:
            if(prevTime==countDown && prevBubbleType == kGreen)
                totalscore+= ceil((float)kGreenScore*(float)Bonus_Rate);
            else
                totalscore+=kGreenScore;
            break;
        case kBlue:
            if(prevTime==countDown && prevBubbleType == kBlue)
                totalscore+= ceil((float)kBlueScore*(float)Bonus_Rate);
            else
                totalscore+=kBlueScore;
            break;
        case kBlack:
            if(prevTime==countDown && prevBubbleType == kBlack)
                totalscore+= ceil((float)kBlackScore*(float)Bonus_Rate);
            else
                totalscore+=kBlackScore;
            break;
            
        default:
            break;
    }
}

//update total score and high score lables
-(void)updateTotalScore{
    _scoreLabel.text=[NSString stringWithFormat:@"%i", totalscore];
    if(totalscore>highestScore)
        _highscoreLabel.text = [NSString stringWithFormat:@"%i",totalscore];
    else
        _highscoreLabel.text = [NSString stringWithFormat:@"%i",highestScore];
}

#pragma mark - Reset

-(void)reset{
    totalscore=0.0;
    countDown=timeDuration;
    _scoreLabel.text = [NSString stringWithFormat:@"%i",totalscore];
}


@end
