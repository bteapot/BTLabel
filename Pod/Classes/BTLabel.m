//
//  BTLabel.m
//  BTLabel
//
//  Created by Денис Либит on 26.12.2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import "BTLabel.h"


@implementation BTLabel

const NSStringDrawingOptions kDrawingOptions = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine;

//
// -----------------------------------------------------------------------------
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font
{
	CGFloat height;
	
	if ([text isKindOfClass:[NSString class]]) {
		height = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:kDrawingOptions attributes:@{NSFontAttributeName: font} context:nil].size.height;
	} else {
		height = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:kDrawingOptions context:nil].size.height;
	}
	
	return ceilf(height);
}

//
// -----------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
}

//
// -----------------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame edgeInsets:UIEdgeInsetsZero];
}

//
// -----------------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)frame edgeInsets:(UIEdgeInsets)edgeInsets
{
	self = [super initWithFrame:frame];
	
	if (self) {
		self.clipsToBounds = NO;
		self.verticalAlignment = BTVerticalAlignmentCenter;
		self.edgeInsets = edgeInsets;
		self.font = [UIFont systemFontOfSize:12];
		self.textColor = [UIColor blackColor];
		self.backgroundColor = [UIColor clearColor];
		self.lineBreakMode = NSLineBreakByWordWrapping;
		self.numberOfLines = 0;
	}
	
	return self;
}

//
// -----------------------------------------------------------------------------
- (void)updateContentMode
{
	switch (self.verticalAlignment) {
		case BTVerticalAlignmentTop:
			switch (self.textAlignment) {
				case NSTextAlignmentLeft:
					self.contentMode = UIViewContentModeTopLeft;
					break;
					
				case NSTextAlignmentCenter:
				case NSTextAlignmentJustified:
				case NSTextAlignmentNatural:
					self.contentMode = UIViewContentModeTop;
					break;
					
				case NSTextAlignmentRight:
					self.contentMode = UIViewContentModeTopRight;
					break;
			}
			break;
		
		case BTVerticalAlignmentCenter:
			switch (self.textAlignment) {
				case NSTextAlignmentLeft:
					self.contentMode = UIViewContentModeLeft;
					break;
					
				case NSTextAlignmentCenter:
				case NSTextAlignmentJustified:
				case NSTextAlignmentNatural:
					self.contentMode = UIViewContentModeCenter;
					break;
					
				case NSTextAlignmentRight:
					self.contentMode = UIViewContentModeRight;
					break;
			}
			break;
		
		case BTVerticalAlignmentBottom:
			switch (self.textAlignment) {
				case NSTextAlignmentLeft:
					self.contentMode = UIViewContentModeBottomLeft;
					break;
					
				case NSTextAlignmentCenter:
				case NSTextAlignmentJustified:
				case NSTextAlignmentNatural:
					self.contentMode = UIViewContentModeBottom;
					break;
					
				case NSTextAlignmentRight:
					self.contentMode = UIViewContentModeBottomRight;
					break;
			}
			break;
	}
}

//
// -----------------------------------------------------------------------------
- (void)setVerticalAlignment:(BTVerticalAlignment)verticalAlignment
{
	_verticalAlignment = verticalAlignment;
	[self updateContentMode];
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
	[super setTextAlignment:textAlignment];
	[self updateContentMode];
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
	_edgeInsets = edgeInsets;
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (CGSize)sizeThatFits:(CGSize)size
{
	UIEdgeInsets edgeInsets = self.edgeInsets;
	NSInteger numberOfLines = self.numberOfLines;
	
	CGSize insettedSize = CGSizeMake(size.width - edgeInsets.left - edgeInsets.right, size.height - edgeInsets.top - edgeInsets.bottom);
	CGRect rect = [self.attributedText boundingRectWithSize:insettedSize options:kDrawingOptions context:nil];
	
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	
	if (numberOfLines > 0) {
		CGFloat maxHeight = self.font.lineHeight * numberOfLines;
		
		if (height > maxHeight) {
			height = maxHeight;
		}
	}
	
	width += edgeInsets.left + edgeInsets.right;
	height += edgeInsets.top + edgeInsets.bottom;
	
	return CGSizeMake(ceilf(width), ceilf(height));
}

//
// -----------------------------------------------------------------------------
- (CGFloat)heightForWidth:(CGFloat)width
{
	return [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
}

//
// -----------------------------------------------------------------------------
- (CGFloat)heightAdjustedForWidth:(CGFloat)width
{
	CGFloat textHeight = [self heightForWidth:width];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, textHeight);
	
	return textHeight;
}

//
// -----------------------------------------------------------------------------
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	UIEdgeInsets edgeInsets = self.edgeInsets;
	CGRect insettedBounds = UIEdgeInsetsInsetRect(bounds, edgeInsets);
	CGRect textRect = CGRectZero;
	BOOL adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth && numberOfLines == 1;
	
	if (adjustsFontSizeToFitWidth) {
		textRect.size = [self.attributedText size];
	} else {
		textRect = [self.attributedText boundingRectWithSize:insettedBounds.size options:kDrawingOptions context:nil];
	}
	
	CGFloat textWidth = ceilf(textRect.size.width);
	CGFloat textHeight = ceilf(textRect.size.height);
	
	if (!adjustsFontSizeToFitWidth) {
		if (textWidth > insettedBounds.size.width) {
			textWidth = insettedBounds.size.width;
		}
		
		if (textHeight > insettedBounds.size.height) {
			textHeight = insettedBounds.size.height;
		}
	}
	
	if (numberOfLines > 0) {
		CGFloat maxHeight = ceilf(self.font.lineHeight * numberOfLines);
		
		if (textHeight > maxHeight) {
			textHeight = maxHeight;
		}
	}
	
	CGFloat originX;
	CGFloat originY;
	
	switch (self.verticalAlignment) {
		case BTVerticalAlignmentTop:
			originY = insettedBounds.origin.y;
			break;
			
		case BTVerticalAlignmentCenter:
			originY = insettedBounds.origin.y + (insettedBounds.size.height - textHeight) / 2;
			break;
			
		case BTVerticalAlignmentBottom:
			originY = insettedBounds.origin.y + (insettedBounds.size.height - textHeight);
			break;
			
		default:
			break;
	}
	
	switch (self.textAlignment) {
		case NSTextAlignmentJustified:
		case NSTextAlignmentLeft:
		case NSTextAlignmentNatural:
			originX = insettedBounds.origin.x;
			break;
			
		case NSTextAlignmentCenter:
			originX = insettedBounds.origin.x + (insettedBounds.size.width - textWidth) / 2;
			break;
			
		case NSTextAlignmentRight:
			originX = insettedBounds.origin.x + (insettedBounds.size.width - textWidth);
			break;
			
		default:
			break;
	}
	
	return CGRectMake(originX, originY, textWidth, textHeight);
}

//
// -----------------------------------------------------------------------------
- (void)drawTextInRect:(CGRect)rect
{
	NSInteger numberOfLines = self.numberOfLines;
	
	CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:numberOfLines];
	
	UIFont *savedFont;
	
	// надо уменьшать текст, ежели чего?
	if (self.adjustsFontSizeToFitWidth && numberOfLines == 1) {
		
		CGRect insettedRect = UIEdgeInsetsInsetRect(rect, self.edgeInsets);
		
		// не влезает?
		if (textRect.size.width > insettedRect.size.width || textRect.size.height > insettedRect.size.height) {
			
			// сохраним текущий шрифт
			savedFont = self.font;
			CGFloat savedPointSize = savedFont.pointSize;
			
			// вычислим коэффициент уменьшения
			CGFloat ratio = MIN(insettedRect.size.width / textRect.size.width, insettedRect.size.height / textRect.size.height);
			
			// предполагаемый кегель шрифта
			CGFloat currentFontSize = MAX(savedPointSize * ratio, savedPointSize * self.minimumScaleFactor);
			
			self.font = [UIFont fontWithName:savedFont.fontName size:currentFontSize];
			textRect = [self textRectForBounds:rect limitedToNumberOfLines:numberOfLines];
		}
	}
	
	// рисуем
	if (self.highlighted && self.highlightedTextColor) {
		NSMutableAttributedString *highlightedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
		[highlightedString addAttribute:NSForegroundColorAttributeName value:self.highlightedTextColor range:NSMakeRange(0, highlightedString.length)];
		[highlightedString drawWithRect:textRect options:kDrawingOptions context:nil];
	} else {
		[self.attributedText drawWithRect:textRect options:kDrawingOptions context:nil];
	}
	
	// надо восстановить шрифт?
	if (savedFont) {
		self.font = savedFont;
	}
}

@end
