//
//  MessageViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageSectionHeader.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableview;

- (IBAction)backButtonAction:(id)sender;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UINib *messageHeaderXix = [UINib nibWithNibName:@"MessageSectionHeader" bundle:nil];
    [self.messageTableview registerNib:messageHeaderXix forHeaderFooterViewReuseIdentifier:@"messageSectionHeader"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.dateLabel.text = @"02 GENNIO 2017";
    cell.messageLabel.text = @"C'era un'atmosfera sombera negli stadi italiani il mercoledì sera durante un minuto di silenzio, seguito da quegli estratti del diario di Anne Frank, vittima dell'olocausto, che veniva letto attraverso altoparlanti prima di tutte le principali partite di calcio. I giocatori indossavano magliette con lo slogan No all'antisemitismo, con una foto di Anne Frank stampata su di essi, mentre le copie del suo diario sono state distribuite ai tifosi dello stadio.";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MessageSectionHeader *messageHeaderView = [self.messageTableview dequeueReusableHeaderFooterViewWithIdentifier:@"messageSectionHeader"];
    messageHeaderView.categotyNameLabel.text = @"Memo evento";
    //messageHeaderView.messageCategoryImageview.image = @"02 GENNAIO 2017";
    return messageHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

@end
