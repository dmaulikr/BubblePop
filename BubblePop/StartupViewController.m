//
//  StartupViewController.m
//  BubblePop
//
//  Created by Nghia Quach on 5/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import "StartupViewController.h"
#import "PlayingFieldViewController.h"
#import "Constant.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE_NAME]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    //reset textfield value
    _playerNameTextField.text = @"";
}

#pragma mark - handle button action
- (IBAction)startGame:(id)sender {
    
    NSString *playerName =[_playerNameTextField.text capitalizedString];
    //validate player name input
    if(![playerName isEqualToString:@""]){
        
        PlayingFieldViewController *pfv = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayingFieldViewController"];
        pfv.playerName = playerName;
        //open player field view controller
        [self presentViewController:pfv animated:YES completion:nil];
    }
    else{
        [self showAlertMessage:@"Please enter your name"];
    }
}

// validate user input & display warning message (invalid input)
-(void)showAlertMessage:(NSString*)theMessage{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning!"
                                          message:theMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
