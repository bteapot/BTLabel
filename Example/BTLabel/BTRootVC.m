//
//  BTRootVC.m
//  BTInfiniteScrollView
//
//  Created by Денис Либит on 12/22/2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import "BTRootVC.h"


@implementation BTRootVC

#pragma mark - Lifecycle

//
// -----------------------------------------------------------------------------
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.autoresizesSubviews = NO;
	
	BTLabel *label;
	
	CGFloat fontSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 13 : 8;
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
	CGColorRef color = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1].CGColor;
	NSDictionary *attributes = @{
		NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:28],
		NSForegroundColorAttributeName: [UIColor orangeColor]
	};
	NSString *overflowingText = @"\rOverflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text. Overflowing text.";
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
	label.font = font;
	label.text = @"Top- and left-aligned text with zero insets.";
	label.verticalAlignment = BTVerticalAlignmentTop;
	label.textAlignment = NSTextAlignmentLeft;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
	label.font = font;
	label.text = @"Centered text with zero insets.";
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
	label.font = font;
	label.text = @"Centered text with top inset of 20 pixels.";
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
	label.font = font;
	label.text = [NSString stringWithFormat:@"Overflowing justified text with UIEdgeInsetsMake(10, 20, 10, 10).%@", overflowingText];
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentJustified;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
	label.font = font;
	label.attributedText = [[NSAttributedString alloc] initWithString:@"Attributed text." attributes:attributes];
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
	label.font = font;
	label.text = @"Bottom- and right-aligned text with UIEdgeInsetsMake(20, 20, 20, 20).";
	label.verticalAlignment = BTVerticalAlignmentBottom;
	label.textAlignment = NSTextAlignmentRight;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
	label.font = font;
	label.text = @"Long text with adjustsFontSizeToFitWidth = YES and numberOfLines = 1";
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentRight;
	label.adjustsFontSizeToFitWidth = YES;
	label.numberOfLines = 1;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	label.font = font;
	label.text = [NSString stringWithFormat:@"Overflowing bottom- and right-aligned text with UIEdgeInsetsMake(10, 10, 10, 10) and numberOfLines = 4.%@", overflowingText];
	label.verticalAlignment = BTVerticalAlignmentBottom;
	label.textAlignment = NSTextAlignmentRight;
	label.numberOfLines = 4;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
	
	label = [[BTLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	label.font = font;
	label.text = [NSString stringWithFormat:@"Overflowing centered text with UIEdgeInsetsMake(10, 10, 10, 10) and numberOfLines = 4.%@", overflowingText];
	label.verticalAlignment = BTVerticalAlignmentCenter;
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 4;
	label.layer.borderWidth = 1;
	label.layer.borderColor = color;
	[self.view addSubview:label];
}

//
// -----------------------------------------------------------------------------
- (void)viewWillLayoutSubviews
{
	CGRect bounds = self.view.bounds;
	CGFloat topMargin = 20;
	CGFloat inset = 10;
	
	NSArray *labels = self.view.subviews;
	NSUInteger sideCount = ceil(sqrt(labels.count));
	
	CGFloat labelWidth = (bounds.size.width - inset) / sideCount - inset;
	CGFloat labelHeight = (bounds.size.height - topMargin - inset) / sideCount - inset;
	
	NSUInteger index = 0;
	
	for (BTLabel *label in labels) {
		label.frame = CGRectMake(inset + (labelWidth + inset) * (index % sideCount),
								 topMargin + inset + (labelHeight + inset) * (index / sideCount),
								 labelWidth,
								 labelHeight);
		index++;
	}
}

@end
