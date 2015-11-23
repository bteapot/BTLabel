# BTLabel

[![Version](https://img.shields.io/cocoapods/v/BTLabel.svg?style=flat)](http://cocoadocs.org/docsets/BTLabel)
[![License](https://img.shields.io/cocoapods/l/BTLabel.svg?style=flat)](http://cocoadocs.org/docsets/BTLabel)
[![Platform](https://img.shields.io/cocoapods/p/BTLabel.svg?style=flat)](http://cocoadocs.org/docsets/BTLabel)

UILabel subclass with vertical text alignment, insets, images and height calculation.

![screenshot](http://i.imgur.com/bgTDpF8.png)

Specifically designed to use with UITableView.

![screenshot](http://i.imgur.com/S5P46Un.png)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Examples

#### Simple initialization:

```objective-c
BTLabel *label = [[BTLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 80);
edgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
label.verticalAlignment = BTVerticalAlignmentCenter;
label.textAlignment = NSTextAlignmentLeft;
```

#### Using whithin UITableViewCell:

```objective-c
// in interface
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

// in implementation
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.texts = @[
		@"Text for row 0",
		@"Text for row 1",
		@"Text for row 2",
	];
	
	self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	self.edgeInsets = UIEdgeInsetsMake(10, 20, 10, 10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [BTLabel heightForWidth:tableView.bounds.size.width
							  text:self.texts[indexPath.row]
							  font:self.font
						edgeInsets:self.edgeInsets
					 numberOfLines:0
						 imageSize:CGSizeZero
					 imagePosition:UIRectEdgeTop
				   imageEdgeInsets:UIEdgeInsetsZero] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * const kCellID = @"kCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		
		BTLabel *label = [[BTLabel alloc] initWithFrame:cell.bounds];
		label.tag = 100;
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		label.font				= self.font;
		label.textAlignment		= NSTextAlignmentLeft;
		label.verticalAlignment	= BTVerticalAlignmentTop;
		label.edgeInsets		= self.edgeInsets;
		label.hasImage			= NO;
		
		[cell.contentView addSubview:label];
	}
	
	BTLabel *label = [cell viewWithTag:100];
	label.text = self.texts[indexPath.row];
	
	return cell;
}

```

## Installation

BTLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "BTLabel"

## Author

Денис Либит, bteapot@me.com

## License

BTLabel is available under the MIT license. See the LICENSE file for more info.

