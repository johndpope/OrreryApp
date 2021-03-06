//
//  SunViewController.m
//  Space
//
//  Created by Alana Hosick on 1/27/14.
//  Copyright (c) 2014 Alana Hosick. All rights reserved.
//

#import "SunViewController.h"
#import "SunriseViewController.h"
#import "Sun.h"
#import "Math.h"
#import "SWRevealViewController.h"



@interface SunViewController ()

@end

@implementation SunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringWithDefaultValue(@"Sun page title", @"Localizable", [NSBundle mainBundle], @"Sun", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"sun32"];
        self.view.backgroundColor = [UIColor grayColor];
        self.date = [NSDate date];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
	locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startMonitoringSignificantLocationChanges];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = locations.lastObject;
    
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    
    [self fillSplashView];
    
}

- (void)fillSplashView
{
    CGRect rect = [self.view bounds];
    int y;
    int dstLabelHeight = 50;
    int spacer;
    int labelHeight;
    int font;
    int rightMargin;
    int leftMargin;
    if (rect.size.height > 1000){
        y = 150;
        spacer = 80;
        labelHeight = 80;
        font = 45;
        leftMargin = 50;
        rightMargin = 100;
    }
        else if (rect.size.height > 560){
            y = 100;
            spacer = 45;
            labelHeight = 40;
            font = 18;
            leftMargin = 20;
            rightMargin = 40;

        
    }else{
        y = 80;
        spacer = 40;
        labelHeight = 40;
        font = 18;
        leftMargin = 20;
        rightMargin = 40;
    }
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submit.frame = CGRectMake(leftMargin,y,rect.size.width - rightMargin,labelHeight);
    y = y +spacer;
    
    UILabel *latLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin,y, rect.size.width - rightMargin,labelHeight)];//12 280
    y = y + spacer;
    
    self.lat = [[UITextView alloc] initWithFrame:CGRectMake(leftMargin,y,rect.size.width - rightMargin,labelHeight)]; //12 300
    y = y + spacer;
    
    UILabel *longLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin,y,rect.size.width - rightMargin,labelHeight)];//12 280
    y = y + spacer;
    
    self.lon = [[UITextView alloc] initWithFrame:CGRectMake(leftMargin,y,rect.size.width - rightMargin,labelHeight)];//12 300
    y = y + spacer;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin,y,rect.size.width - rightMargin,labelHeight)];//12 280
    y = y + spacer;
    
    UIButton *date = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    date.frame = CGRectMake(leftMargin,y,rect.size.width - rightMargin,labelHeight);
    y = y + spacer + ( 0.5 * spacer);
    
    UILabel *dstLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin,y,rect.size.width - (rect.size.width/2),dstLabelHeight)];//12 200
    self.dst = [[UISwitch alloc] initWithFrame:(CGRectMake((rect.size.width - (rect.size.width / 3)),y+10,30,dstLabelHeight))];//220 30
    
    
    
    
    submit.backgroundColor =[UIColor yellowColor];
    submit.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:font];
    [submit setTitle:NSLocalizedString(@"find sunrise/sunset times",nil) forState:UIControlStateNormal];
    [self.view addSubview:submit];
    [submit addTarget:self action:@selector(submitPressed)forControlEvents:UIControlEventTouchUpInside];
    

    
    latLabel.font = [UIFont fontWithName:@"Helvetica" size:font];
    latLabel.textColor = [UIColor whiteColor];
    latLabel.textAlignment = NSTextAlignmentCenter;
    latLabel.text = [NSString stringWithFormat:NSLocalizedString(@"latitude", nil)];
    [self.view addSubview:latLabel];
    
    self.lat.font = [UIFont fontWithName:@"Helvetica" size:font];
    self.lat.textColor = [UIColor blackColor];
    self.lat.editable = YES;
    self.lat.text = [NSString stringWithFormat:@"%Lf", self.latitude];
    [self.view addSubview:self.lat];
    
    
    longLabel.font = [UIFont fontWithName:@"Helvetica" size:font];
    longLabel.textColor = [UIColor whiteColor];
    longLabel.textAlignment = NSTextAlignmentCenter;
    longLabel.text = [NSString stringWithFormat:NSLocalizedString(@"longitude", nil)];
    [self.view addSubview:longLabel];
    
    self.lon.font = [UIFont fontWithName:@"Helvetica" size:font];
    self.lon.textColor = [UIColor blackColor];
    self.lon.editable = YES;
    self.lon.text = [NSString stringWithFormat:@"%Lf", self.longitude];
    [self.view addSubview:self.lon];

    dstLabel.font = [UIFont fontWithName:@"Helvetica" size:font];
    dstLabel.textColor = [UIColor whiteColor];
    dstLabel.textAlignment = NSTextAlignmentCenter;
    dstLabel.text = [NSString stringWithFormat:NSLocalizedString(@"daylight savings?", nil)];
    [self.view addSubview:dstLabel];
    
    //BOOL on = [[newContact objectForKey:@"important"] boolValue];
   
    [self.view addSubview:self.dst];
    
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:font];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"date",nil)];
    [self.view addSubview:dateLabel];
    
    
    date.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:font];
    date.backgroundColor =[UIColor whiteColor];
    [date setTitle:[Math formatDate:self.date] forState:UIControlStateNormal];
    [self.view addSubview:date];
    [date addTarget:self action:@selector(callDP:)forControlEvents:UIControlEventTouchUpInside];
   
    date.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview:date];

   
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.latitude) {
        [super viewWillAppear:animated];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillSplashView) name:@"initWithJSONFinishedLoading" object:nil];
    }else{
        NSLog(@"GPS information loaded");
    }
    
}

- (id) submitPressed
{
    
    SunriseViewController *sunriseVC = [[SunriseViewController alloc] init];
    
    NSLog(@"sun %@", self.lon.text);
    NSLog(@"sun %@", self.lat.text);

    NSLog(@"sun %f", [self.lon.text doubleValue]);
    NSLog(@"sun %f", [self.lat.text doubleValue]);

    sunriseVC.longitude = [self.lon.text doubleValue];  //doubleValue];
    sunriseVC.dst = self.dst.isOn;
    sunriseVC.latitude = [self.lat.text doubleValue];
    sunriseVC.title = NSLocalizedString(@"Sunrise / Sunset",nil);
    sunriseVC.date = self.date;
    
    [self.navigationController pushViewController:sunriseVC animated:YES];

    return self;
}
- (void)changeDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    self.date = sender.date;
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
    
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    
    //TODO - set method to use date and lat
    
    [self fillSplashView];
}

- (IBAction)callDP:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 9;
    darkView.backgroundColor = [UIColor whiteColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    self.date = [datePicker date];
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
