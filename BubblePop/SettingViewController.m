//
//  SettingViewController.m
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import "SettingViewController.h"
#import "Utility.h"
#import "Constant.h"

@interface SettingViewController ()

@end

@implementation SettingViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE_NAME]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get max bubble with key from NSUserDefaults
    int maxBubble = [[Utility sharedIntance] getSettingValueWithKey:MAX_BUBBLE_KEY];
    
    //get default max bubble if it does not set before
    if(maxBubble==0) maxBubble=Default_Max_Bubble;
    
    //get game duaration with key from NSUserDefaults
    int gameDuration = [[Utility sharedIntance] getSettingValueWithKey:GAME_DURATION_KEY];
    
    //get default game duration if it does not set before
    if(gameDuration==0) gameDuration=Default_Duration_Time;
    
    //set values to sliders
    [_maxBubbleSlider setValue:maxBubble];
    [_gameDurationSlider setValue:gameDuration];
    
    //set value for labels
    _maxBubbleLabel.text = [NSString stringWithFormat:@"Max Bubbles: %i bubble(s)",maxBubble];
    _gameDurationLabel.text = [NSString stringWithFormat:@"Game Durations: %i second(s)",gameDuration];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle slider action

- (IBAction)maxBubbleValueChange:(id)sender {
    UISlider *aSlider = (UISlider *)sender;
    _maxBubbleLabel.text = [NSString stringWithFormat:@"Max Bubbles: %i bubble(s)",(int)aSlider.value];
    
    //store setting value into NSUserDefaults
    [[Utility sharedIntance] saveSettingValue:(int)aSlider.value withKey:MAX_BUBBLE_KEY];
}

- (IBAction)gameDurationValueChange:(id)sender {
    UISlider *aSlider = (UISlider *)sender;
    _gameDurationLabel.text = [NSString stringWithFormat:@"Game Durations: %i second(s)",(int)aSlider.value];
    
    //store game duration value into NSUserDefaults
    [[Utility sharedIntance] saveSettingValue:(int)aSlider.value withKey:GAME_DURATION_KEY];
}



@end
