//
//  NewsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/27/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsSectionHeader.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

- (IBAction)backButtonAction:(id)sender;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsTableView.estimatedRowHeight = 156;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.newsTableView.estimatedSectionHeaderHeight = 44;
    self.newsTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.newsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UINib *newsHeaderXix = [UINib nibWithNibName:@"NewsHeader" bundle:nil];
    [self.newsTableView registerNib:newsHeaderXix forHeaderFooterViewReuseIdentifier:@"newsSectionHeader"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    cell.newsDetailsLabel.text = @"C'era un'atmosfera sombera negli stadi italiani il mercoledì sera durante un minuto di silenzio, seguito da quegli estratti del diario di Anne Frank, vittima dell'olocausto, che veniva letto attraverso altoparlanti prima di tutte le principali partite di calcio. I giocatori indossavano magliette con lo slogan No all'antisemitismo, con una foto di Anne Frank stampata su di essi, mentre le copie del suo diario sono state distribuite ai tifosi dello stadio.";
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NewsSectionHeader *newsHeaderView = [self.newsTableView dequeueReusableHeaderFooterViewWithIdentifier:@"newsSectionHeader"];
    newsHeaderView.nameLabel.text = @"LA NUOVA SCIENZA";
    newsHeaderView.timeLabel.text = @"02 GENNAIO 2017";
    return newsHeaderView;
}


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
