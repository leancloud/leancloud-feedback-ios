//
//  AVUserFeedbackViewController.m
//  paas
//
//  Created by yang chaozhong on 4/24/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "LCUserFeedbackViewController.h"
#import "LCUserFeedbackLeftCell.h"
#import "LCUserFeedbackRightCell.h"
#import "LCUserFeedback.h"
#import "LCUserFeedback_Internal.h"
#import "LCUserFeedbackThread.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define TOP_MARGIN 20.0f

#define TAG_TABLEView_Header 1
#define TAG_InputFiled 2

@interface LCUserFeedbackViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_feedbackThreads;
    UIRefreshControl *_refreshControl;
    LCUserFeedback *_userFeedback;
    
    BOOL _shouldScrollToBottom;
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *tableViewHeader;
@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) UIButton *sendButton;

@end

@implementation LCUserFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _feedbackThreads = [[NSMutableArray alloc] init];
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self keyboardWillHide:nil];
    
    _shouldScrollToBottom = YES;
    [self loadFeedbackThreads];
}

- (void)setupUI {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeButtonImage = [UIImage imageNamed:@"back.png"];
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, 0, closeButtonImage.size.width, closeButtonImage.size.height);
    closeButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    [self.navigationItem setTitle:@"意见反馈"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:85.0f/255 green:184.0f/255 blue:244.0f/255 alpha:1]];
    } else {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:85.0f/255 green:184.0f/255 blue:244.0f/255 alpha:1]];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 48)
                                                  style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 48, CGRectGetWidth(self.view.frame)-60, 48)];
    self.inputTextField.tag = TAG_InputFiled;
    [self.inputTextField setFont:[UIFont systemFontOfSize:12]];
    [self.inputTextField setBackgroundColor:[UIColor colorWithRed:247.0f/255 green:248.0f/255 blue:248.0f/255 alpha:1]];
    self.inputTextField.placeholder = @"填写反馈";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.inputTextField.leftView = paddingView;
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    self.inputTextField.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.inputTextField.delegate = (id <UITextFieldDelegate>) self;
    [self.view addSubview:_inputTextField];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60, CGRectGetHeight(self.view.frame) - 48, 60, 48);
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.sendButton setTitleColor:[UIColor colorWithRed:137.0f/255 green:137.0f/255 blue:137.0f/255 alpha:1] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:[UIColor colorWithRed:247.0f/255 green:248.0f/255 blue:248.0f/255 alpha:1]];
    [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendButton];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
}

- (void)loadFeedbackThreads {
    if (![_refreshControl isRefreshing]) {
        [_refreshControl beginRefreshing];
    }
    
    [LCUserFeedback fetchFeedbackWithContact:_contact withBlock:^(id object, NSError *error) {
        if (!error) {
            NSArray* results = [(NSDictionary*)object objectForKey:@"results"];
            if (results && results.count > 0) {
                _userFeedback = [[LCUserFeedback alloc] initWithDictionary:results[0]];
            }
            if (_userFeedback) {
                [LCUserFeedbackThread fetchFeedbackThreadsInBackground:_userFeedback withBlock:^(NSArray *objects, NSError *error) {
                    [_feedbackThreads removeAllObjects];
                    [_feedbackThreads addObjectsFromArray:objects];
                    
                    [_tableView reloadData];
                    [_refreshControl endRefreshing];
                    
                    if (_shouldScrollToBottom) {
                        _shouldScrollToBottom = NO;
                        [self scrollToBottom];
                    }
                }];
            } else {
                [_refreshControl endRefreshing];
            }
        } else {
            [_refreshControl endRefreshing];
        }
    }];
}

- (void)handleRefresh:(id)sender {
    [self loadFeedbackThreads];
}

- (void)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)sendButtonClicked:(id)sender {
    if ([self.inputTextField.text length] > 0) {
        if (!_userFeedback) {
            if (self.tableViewHeader.text.length > 0) {
                _contact = self.tableViewHeader.text;
            }
            [LCUserFeedback feedbackWithContent:_feedbackTitle contact:_contact create:YES withBlock:^(id object, NSError *error) {
                if (!error) {
                    LCUserFeedback *feedback = (LCUserFeedback *)object;
                    _userFeedback = feedback;
                    LCUserFeedbackThread *feedbackThread = [LCUserFeedbackThread feedbackThread:self.inputTextField.text
                                                                                           type:@"user"
                                                                                   withFeedback:_userFeedback];
                    [LCUserFeedbackThread saveFeedbackThread:feedbackThread withBlock:^(id object, NSError *error) {
                        if (!error) {
                            [_feedbackThreads addObject:feedbackThread];
                            [_tableView reloadData];
                            if ([_inputTextField isFirstResponder]) {
                                [_inputTextField resignFirstResponder];
                            }
                            
                            if ([_inputTextField.text length] > 0) {
                                _inputTextField.text = @"";
                            }
                            
                            _shouldScrollToBottom = YES;
                            [self loadFeedbackThreads];
                        }
                    }];
                    
                }
            }];
        } else {
            LCUserFeedbackThread *feedbackThread = [LCUserFeedbackThread feedbackThread:self.inputTextField.text type:@"user" withFeedback:_userFeedback];
            [LCUserFeedbackThread saveFeedbackThread:feedbackThread withBlock:^(id object, NSError *error) {
                if (!error) {
                    [_feedbackThreads addObject:feedbackThread];
                    [_tableView reloadData];
                    if ([_inputTextField isFirstResponder]) {
                        [_inputTextField resignFirstResponder];
                    }
                    
                    if ([_inputTextField.text length] > 0) {
                        _inputTextField.text = @"";
                    }
                    
                    _shouldScrollToBottom = YES;
                    [self loadFeedbackThreads];
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIKeyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    if ([self.tableViewHeader isFirstResponder]) {
        return;
    }
    
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect inputTextFiledFrame = self.inputTextField.frame;
                         inputTextFiledFrame.origin.y = self.view.bounds.size.height - keyboardHeight - inputTextFiledFrame.size.height;
                         self.inputTextField.frame = inputTextFiledFrame;
                         
                         CGRect sendButtonFrame = self.sendButton.frame;
                         sendButtonFrame.origin.y = self.view.bounds.size.height - keyboardHeight - sendButtonFrame.size.height;
                         self.sendButton.frame = sendButtonFrame;
                         
                         CGRect tableViewFrame = self.tableView.frame;
                         tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - keyboardHeight;
                         self.tableView.frame = tableViewFrame;
                     }
                     completion:^(BOOL finished) {
                         [self scrollToBottom];
                     }
     ];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([self.tableViewHeader isFirstResponder]) {
        return;
    }
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect inputTextFieldFrame = self.inputTextField.frame;
    inputTextFieldFrame.origin.y = self.view.bounds.size.height - inputTextFieldFrame.size.height;
    self.inputTextField.frame = inputTextFieldFrame;
    
    CGRect sendButtonFrame = self.sendButton.frame;
    sendButtonFrame.origin.y = self.view.bounds.size.height - sendButtonFrame.size.height;
    self.sendButton.frame = sendButtonFrame;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = CGRectGetHeight(self.view.frame) - 48;
    self.tableView.frame = tableViewFrame;
    
    [UIView commitAnimations];
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == TAG_TABLEView_Header && [textField.text length] > 0 && _userFeedback) {
        _userFeedback.contact = textField.text;
        [LCUserFeedback updateFeedback:_userFeedback withBlock:^(id object, NSError *error) {
            // do something...
        }];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollToBottom {
    if ([self.tableView numberOfRowsInSection:0] > 1) {
        NSInteger lastRowNumber = [self.tableView numberOfRowsInSection:0] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_feedbackThreads count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.tableViewHeader = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.tableViewHeader.leftView = paddingView;
    self.tableViewHeader.leftViewMode = UITextFieldViewModeAlways;
    
    self.tableViewHeader.delegate = (id <UITextFieldDelegate>) self;
    self.tableViewHeader.tag = TAG_TABLEView_Header;
    [self.tableViewHeader setBackgroundColor:[UIColor colorWithRed:247.0f/255 green:248.0f/255 blue:248.0f/255 alpha:1]];
    self.tableViewHeader.textAlignment = NSTextAlignmentLeft;
    self.tableViewHeader.placeholder = @"Email或QQ号";
    [self.tableViewHeader setFont:[UIFont systemFontOfSize:12.0f]];
    if (_contact) {
        self.tableViewHeader.text = _contact;
    }
    return _tableViewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = ((LCUserFeedbackThread *)_feedbackThreads[indexPath.row]).content;
    
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:12.0f]
                           constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 40 + TOP_MARGIN;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserFeedbackThread *feedbackThread = _feedbackThreads[indexPath.row];
    
    if ([feedbackThread.type isEqualToString:@"dev"]) {
        LCUserFeedbackLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCellLeft"];
        if (cell == nil) {
            cell = [[LCUserFeedbackLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedbackCellLeft"];
        }
        cell.textLabel.text = feedbackThread.content;
        cell.timestampLabel.text = [self formatDateString:feedbackThread.createAt];
        return cell;
    } else {
        LCUserFeedbackRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCellRight"];
        if (cell == nil) {
            cell = [[LCUserFeedbackRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedbackCellRight"];
        }
        
        cell.textLabel.text = feedbackThread.content;
        cell.timestampLabel.text = [self formatDateString:feedbackThread.createAt];
        return cell;
    }
}

- (NSString *)formatDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end


