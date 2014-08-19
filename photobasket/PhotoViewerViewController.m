//
//  PhotoViewerViewController.m
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import "PhotoViewerViewController.h"
#import <AFNetworking.h>
#import "ImagesCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "basketImage.h"

@interface PhotoViewerViewController ()
@property (nonatomic, strong) NSMutableArray* mRIghtPhotoURLs;
@property (nonatomic, strong) NSMutableArray* mLeftPhotoURLs;
@end

@implementation PhotoViewerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.mRIghtPhotoURLs = [[NSMutableArray alloc] init];
        self.mLeftPhotoURLs = [[NSMutableArray alloc] init];
        
        [self.mRIghtPhotoURLs addObject:@"https://lh5.googleusercontent.com/-QNfibr5e5ZE/Umvy0DXtRTI/AAAAAAAAACc/vA8WwhkgSwE/eiffel-tower-paris-france.jpg"];
        [self.mRIghtPhotoURLs addObject:@"https://lh3.googleusercontent.com/-2J1asVaAhEA/UmvmZMULAZI/AAAAAAAAAIY/q8qVSy_pOGg/Hemingway%252520Bar%252520Paris.JPG"];
        [self.mRIghtPhotoURLs addObject:@"https://lh6.googleusercontent.com/-YrPKAxP-Gfo/UmvSIw67F9I/AAAAAAAAADA/T7Z7MRvl8wk/paris_%25252Bfrance.jpg"];
        [self.mRIghtPhotoURLs addObject:@"https://lh5.googleusercontent.com/-bZCxVEGGLYo/UmvPcbys2fI/AAAAAAAAAIs/j_JeSHQOYrs/paris-france-eiffel-tower.jpg"];

        
        [self.mLeftPhotoURLs addObject:@"https://lh5.googleusercontent.com/-NQrXrdPpk-Q/UmvqERqcBdI/AAAAAAAAAG0/GZSTRZGhcko/Ansel%252520Adams%252520Yosemite.jpg"];
        [self.mLeftPhotoURLs addObject:@"https://lh3.googleusercontent.com/-r5HLkQEN810/UmusRfyeUqI/AAAAAAAAACw/Bc6oDRBHReY/drop%252520the%252520bass%2525201.jpg"];
        [self.mLeftPhotoURLs addObject:@"https://lh5.googleusercontent.com/-k70iOkMKdN4/Umurwmh3wqI/AAAAAAAAADE/VxNg6nl2bes/wwt.jpg"];
        [self.mLeftPhotoURLs addObject:@"https://lh6.googleusercontent.com/-1uyfORp6Q5U/Umut6WI9zfI/AAAAAAADXog/0kp9TPwGZnk/1004995_457011074409562_1485946774_n.jpg"];

    }
    return self;
}

-(void) getPhotos
{
    self.mRIghtPhotoURLs = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString* url = @"https://picasaweb.google.com/data/feed/api/all?q=beach%20pictures&max-results=1000&alt=json";
    NSLog(@"URL %@", url);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* feed = responseObject[@"feed"];
         
         NSArray* entry = feed[@"entry"];
         
         uint index = 0;
         
         for (NSDictionary* anEntry in entry)
         {
             NSDictionary* mediaGroup = anEntry[@"media$group"];
             NSArray* mediaContent = mediaGroup[@"media$content"];
             NSDictionary* firstContent = mediaContent[0];
             NSString* PhotoUrl = firstContent[@"url"];
             NSLog(@"URL = %@", PhotoUrl);
             
             if(index%2)
                 [self.mRIghtPhotoURLs addObject:PhotoUrl];
             else
                 [self.mLeftPhotoURLs addObject:PhotoUrl];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.mRIghtPhotoURLs.count + self.mLeftPhotoURLs.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView* image = [[UIImageView alloc] init];
    [image setImageWithURL:self.mRIghtPhotoURLs[indexPath.row]];
    [cell addSubview:image];
    return cell;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (([[UIScreen mainScreen] bounds].size.height/2) - 30);
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
    NSLog(@"Number of rows = %d", self.mRIghtPhotoURLs.count);
    return (self.mRIghtPhotoURLs.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell.mLeftImage setImageWithURL:self.mLeftPhotoURLs[indexPath.row]];
    [cell.mRightImage setImageWithURL:self.mRIghtPhotoURLs[indexPath.row]];
    
    CGSize rightSize = cell.mRightImage.image.size;
    CGSize leftSize = cell.mLeftImage.image.size;
    return cell;
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
