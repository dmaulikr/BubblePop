//
//  ScoreBoardViewController.m
//  BubblePop
//
//  Created by Nghia Quach on 8/05/2016.
//  Copyright © 2016 Nghia Quach. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "Utility.h"
#import "Constant.h"

@interface ScoreBoardViewController ()

@end

@implementation ScoreBoardViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //get players from user default 
    playerList = [[Utility sharedIntance] getPlayers];
    //sort player list by score
    playerList = [playerList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] < [obj2 intValue]) return NSOrderedDescending;
        else return NSOrderedAscending;
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE_NAME]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)sortedPlayerScore{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playerList==nil?0:[playerList count];
}

#pragma mark - TableViewCell with custom view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if([playerList count]>0){
        //create a view for cell
        UIView *cellView = [self getCustomViewForCell:cell withIndexPath:indexPath];
        //add temp view to a cell
        [cell.contentView addSubview:cellView];
    }
    
    return cell;
}

//get player list from local
//creat labels for player name & score
//add labels into a new view
-(UIView*)getCustomViewForCell:(UITableViewCell*)theCell withIndexPath:(NSIndexPath*) theIndexPath{
    
    NSString *playerData = [playerList objectAtIndex:theIndexPath.row];
    
    //seperate player name and score
    NSString *playerName = [[[playerData componentsSeparatedByString: @"@"]objectAtIndex:1] capitalizedString];
    int score = [[[playerData componentsSeparatedByString: @"@"]objectAtIndex:0]intValue];
    
    //create temp view for cell
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10, 0, theCell.frame.size.width, theCell.frame.size.height)];
    
    //create player name lable for cell
    UILabel *playerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, theCell.frame.size.width/2-20, theCell.frame.size.height)];
    NSString *playerNameFormat = [NSString stringWithFormat:@"%i. %@",(int)theIndexPath.row+1,playerName];
    playerNameLabel.text = playerNameFormat;
    playerNameLabel.textAlignment = NSTextAlignmentLeft;
    playerNameLabel.font = [UIFont boldSystemFontOfSize:17];
    
    //creat score label for cell
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(theCell.frame.size.width-theCell.frame.size.width/2-20, 0, theCell.frame.size.width/2, theCell.frame.size.height)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.text = [NSString stringWithFormat:@"%i points", score];
    scoreLabel.font = [UIFont boldSystemFontOfSize:17];
    
    //add labels into view
    [v addSubview:playerNameLabel];
    [v addSubview:scoreLabel];
    
    return v;
}

@end
