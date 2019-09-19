//
//  BTLabelVC.m
//  BTLabel
//
//  Created by Денис Либит on 12/22/2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import "BTLabelVC.h"


@interface BTLabelVC ()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *texts;
@property (nonatomic, strong) NSMutableString *overflowingText;
@property (nonatomic, strong) NSString *repeatingText;
@property (nonatomic, assign) NSUInteger repeatingTextIndex;
@property (nonatomic, assign) NSInteger repeatingTextStep;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger state;

@end


@implementation BTLabelVC

#pragma mark - Initialization

//
// -----------------------------------------------------------------------------
- (instancetype)init
{
	self = [super init];
	
	if (self) {
		self.title = NSLocalizedString(@"Labels", comment: @"");
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.tabBarItem.image = [UIImage imageNamed:@"icon-label"];
	}
	
	return self;
}


#pragma mark - Lifecycle

//
// -----------------------------------------------------------------------------
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.autoresizesSubviews = NO;
	
	self.labels = [NSMutableArray arrayWithCapacity:9];
	self.texts = [NSMutableArray arrayWithCapacity:9];
	self.overflowingText = [NSMutableString string];
	self.repeatingText = @" Overflowing text.";
	self.repeatingTextStep = 1;
	
	BTLabel *label;
	
	CGFloat fontSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 13 : 8;
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
	CGColorRef color = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1].CGColor;
	NSDictionary *attributes = @{
		NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:28],
		NSForegroundColorAttributeName: [UIColor orangeColor]
	};
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentTop;
	label.textAlignment = NSTextAlignmentLeft;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Top- and left-aligned text with zero insets."];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Centered text with zero insets."];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Centered text with top inset of 20 pixels."];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentJustified;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Justified text with UIEdgeInsetsMake(10, 20, 10, 10)."];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Attributed text.", comment: @"") attributes:attributes]];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentBottom;
	label.textAlignment = NSTextAlignmentRight;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Bottom- and right-aligned text with UIEdgeInsetsMake(20, 20, 20, 20)."];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentRight;
	label.adjustsFontSizeToFitWidth = YES;
	label.numberOfLines = 1;
	label.minimumScaleFactor = 0.3;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Long text with adjustsFontSizeToFitWidth = YES and numberOfLines = 1"];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentBottom;
	label.textAlignment = NSTextAlignmentRight;
	label.numberOfLines = 4;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Bottom- and right-aligned text with UIEdgeInsetsMake(10, 10, 10, 10) and numberOfLines = 4."];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	label.font = font;
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 20;
	label.decreasesFontSizeToFitNumberOfLines = YES;
	label.minimumScaleFactor = 0.1;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	[self.labels addObject:label];
	[self.texts addObject:@"Centered text with UIEdgeInsetsMake(10, 10, 10, 10), numberOfLines = 20 and decreasesFontSizeToFitNumberOfLines = YES."];
	
	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[self.view addGestureRecognizer:gr];
}

//
// -----------------------------------------------------------------------------
- (void)viewWillLayoutSubviews
{
	CGRect bounds = self.view.bounds;
	CGFloat topMargin = 20;
	CGFloat inset = 10;
	
	NSUInteger sideCount = ceil(sqrt(self.labels.count));
	
	CGFloat labelWidth = (bounds.size.width - inset) / sideCount - inset;
	CGFloat labelHeight = (bounds.size.height - topMargin - inset) / sideCount - inset;
	
	NSUInteger index = 0;
	
	for (BTLabel *label in self.labels) {
		label.frame = CGRectMake(inset + (labelWidth + inset) * (index % sideCount),
								 topMargin + inset + (labelHeight + inset) * (index / sideCount),
								 labelWidth,
								 labelHeight);
		index++;
	}
}

//
// -----------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self timerDidFire:nil];
}

//
// -----------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

//
// -----------------------------------------------------------------------------
- (void)timerDidFire:(NSTimer *)timer
{
	if (self.state == 0) {
		
		if (self.repeatingTextStep > 0) {
			[self.overflowingText appendString:[self.repeatingText substringWithRange:NSMakeRange(self.repeatingTextIndex, 1)]];
		} else {
			[self.overflowingText deleteCharactersInRange:NSMakeRange(self.overflowingText.length - 1, 1)];
		}
		
		if (self.overflowingText.length > 1400) {
			self.repeatingTextStep = -1;
		}
		
		if (self.overflowingText.length == 0) {
			self.repeatingTextStep = 1;
			self.repeatingTextIndex = 0;
		}
		
		if (self.repeatingTextStep > 0) {
			if (self.repeatingTextIndex == self.repeatingText.length - 1) {
				self.repeatingTextIndex = 0;
			} else {
				self.repeatingTextIndex += self.repeatingTextStep;
			}
		}
	}
	
	[self.labels enumerateObjectsUsingBlock:^(BTLabel *label, NSUInteger idx, BOOL *stop) {
		id text = self.texts[idx];
		
		if ([text isKindOfClass:[NSString class]]) {
			label.text = [text stringByAppendingString:self.overflowingText];
		} else
		if ([text isKindOfClass:[NSAttributedString class]]) {
			label.attributedText = text;
		}
	}];
}

//
// -----------------------------------------------------------------------------
- (void)tapped:(UITapGestureRecognizer *)gr
{
	switch (self.state) {
		case 0: {
			self.state = 1;
			break;
		}
		case 1: {
			self.state = 2;
			[self.overflowingText deleteCharactersInRange:NSMakeRange(0, self.overflowingText.length)];
			self.repeatingTextStep = 1;
			self.repeatingTextIndex = 0;
			break;
		}
		case 2: {
			self.state = 0;
			break;
		}
		default:
			break;
	}
}

@end
