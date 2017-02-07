//
//  SettingViewController.h
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *maxBubbleSlider;
@property (weak, nonatomic) IBOutlet UISlider *gameDurationSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxBubbleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameDurationLabel;

@end
