//
//  HomeViewController.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-16.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //check what user 
    
    
}
- (IBAction)homeToExploreSegue {
    [self performSegueWithIdentifier:@"homeToExplore" sender:self];
}

- (IBAction)homeButtonAction:(id)sender {
}

- (IBAction)playerButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"homeToPlayer" sender:sender];
}



@end
