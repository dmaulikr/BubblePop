//
//  ScoreBoardViewController.h
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    NSArray *playerList;
}

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;

@end
