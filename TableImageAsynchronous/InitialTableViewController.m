//
//  InitialTableViewController.m
//  TableImageAsynchronous
//
//  Created by Jose Antonio Gabriel Massana on 16/10/12.
//  Copyright (c) 2012 Jose Antonio Gabriel Massana. All rights reserved.
//

#import "InitialTableViewController.h"


@implementation InitialTableViewController
{
    NSString *path;
    NSDictionary *rootLevel;
    NSString *imagePath;
    NSArray *countries;
    NSNumberFormatter * floatFormatter;
    /////////////////////////
    dispatch_queue_t mainQueue;
    
    NSMutableDictionary *imagesDictionary;    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    rootLevel = [[NSDictionary alloc] initWithContentsOfFile:path];
    countries = [rootLevel objectForKey:@"Countries"];
    imagePath = [rootLevel objectForKey:@"ImagePath"];
    
    


    mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    imagesDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    UILabel *label = (UILabel *)[cell viewWithTag:200];
    UIImageView *imageFlag = (UIImageView *)[cell viewWithTag:300];
    
    label.text = [[countries objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
        
    imageFlag.image = [UIImage imageNamed:@"Placeholder.png"];
    
    
       
    
        
        NSData *imageData = [imagesDictionary objectForKey:[[countries objectAtIndex:indexPath.row] objectForKey:@"Flag"]];
        
        if (imageData)
        {
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            
            imageFlag.image = image;
            NSLog(@" Reatriving ImageData...: %@", [[countries objectAtIndex:indexPath.row] objectForKey:@"Flag"]);

            
        }
        else
        {
        
        dispatch_async(mainQueue, ^(void) {
            
            NSString *url = [NSString stringWithFormat:@"%@%@", imagePath, [[countries objectAtIndex:indexPath.row] objectForKey:@"Flag"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            
            imageFlag.image = image;
            
            [imagesDictionary setObject:imageData forKey:[[countries objectAtIndex:indexPath.row] objectForKey:@"Flag"]];
            
            NSLog(@" Downloading Image...: %@", [[countries objectAtIndex:indexPath.row] objectForKey:@"Flag"]);
        
        });
            
        }
        
        
        
    

    
        
        
        
        
        
   
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
