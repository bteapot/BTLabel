//
//  BTLabel.m
//  BTLabel
//
//  Created by Денис Либит on 26.12.2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import "BTLabel.h"


@interface BTLabel ()

@property (nonatomic, strong) UIFont *correctedFont;

@end


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
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		self.edgeInsets = [aDecoder decodeUIEdgeInsetsForKey:NSStringFromSelector(@selector(edgeInsets))];
		self.verticalAlignment = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(verticalAlignment))];
		self.decreasesFontSizeToFitNumberOfLines = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(decreasesFontSizeToFitNumberOfLines))];
		self.increasesFontSizeToFitNumberOfLines = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(increasesFontSizeToFitNumberOfLines))];
	}
	
	return self;
}

//
// -----------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	
	[aCoder encodeUIEdgeInsets:self.edgeInsets forKey:NSStringFromSelector(@selector(edgeInsets))];
	[aCoder encodeInteger:self.verticalAlignment forKey:NSStringFromSelector(@selector(verticalAlignment))];
	[aCoder encodeBool:self.decreasesFontSizeToFitNumberOfLines forKey:NSStringFromSelector(@selector(decreasesFontSizeToFitNumberOfLines))];
	[aCoder encodeBool:self.increasesFontSizeToFitNumberOfLines forKey:NSStringFromSelector(@selector(increasesFontSizeToFitNumberOfLines))];
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
	
	CGSize insettedSize = CGSizeMake(MAX(size.width - edgeInsets.left - edgeInsets.right, 0), CGFLOAT_MAX);
	CGRect rect = [self.attributedText boundingRectWithSize:insettedSize options:kDrawingOptions context:nil];
	
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	
	if (numberOfLines > 0) {
		CGFloat maxHeight = self.font.lineHeight * numberOfLines;
		
		if (numberOfLines > 1 && (self.decreasesFontSizeToFitNumberOfLines || self.increasesFontSizeToFitNumberOfLines)) {
			height = maxHeight;
		} else {
			if (height > maxHeight) {
				height = maxHeight;
			}
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
	
	if (insettedBounds.size.width < 0) {
		insettedBounds.size.width = 0;
	}
	
	if (insettedBounds.size.height < 0) {
		insettedBounds.size.height = 0;
	}
	
	CGRect textRect = CGRectZero;
	
	self.correctedFont = nil;
	UIFont *originalFont;
	
	if (self.adjustsFontSizeToFitWidth && numberOfLines == 1) {
		textRect.size = CGSizeMake([self.attributedText size].width, self.font.lineHeight);
		
		// не влезает?
		if (textRect.size.width > insettedBounds.size.width) {
			
			// сохраним текущий шрифт
			originalFont = self.font;
			CGFloat originalPointSize = originalFont.pointSize;
			
			// вычислим коэффициент уменьшения
			CGFloat ratio = insettedBounds.size.width / textRect.size.width;
			
			// предполагаемый кегель шрифта
			CGFloat currentFontSize = originalPointSize * MAX(ratio, self.minimumScaleFactor);
			self.font = [UIFont fontWithName:originalFont.fontName size:currentFontSize];
			textRect.size = CGSizeMake(MIN([self.attributedText size].width, insettedBounds.size.width), MIN(self.font.lineHeight, insettedBounds.size.height));
		}
	} else {
		BOOL decreasesFontSizeToFitNumberOfLines = self.decreasesFontSizeToFitNumberOfLines && numberOfLines > 1;
		BOOL increasesFontSizeToFitNumberOfLines = self.increasesFontSizeToFitNumberOfLines && numberOfLines > 1;
		
		if (decreasesFontSizeToFitNumberOfLines || increasesFontSizeToFitNumberOfLines) {
			CGFloat maxHeight = ceilf(self.font.lineHeight * numberOfLines);
			CGFloat ratio = MAX(insettedBounds.size.height / maxHeight, self.minimumScaleFactor);
			
			if ((decreasesFontSizeToFitNumberOfLines && ratio < 1) ||
				(increasesFontSizeToFitNumberOfLines && ratio > 1)) {
				originalFont = self.font;
				self.font = [self.font fontWithSize:originalFont.pointSize * ratio];
			}
		}
		
		textRect = [self.attributedText boundingRectWithSize:insettedBounds.size options:kDrawingOptions context:nil];
		
		if (numberOfLines > 0) {
			CGFloat maxHeight = self.font.lineHeight * numberOfLines;
			
			if (textRect.size.height > maxHeight) {
				textRect.size.height = maxHeight;
			}
		}
	}
	
	if (originalFont) {
		self.correctedFont = self.font;
		self.font = originalFont;
	}
	
	CGFloat textWidth = ceilf(textRect.size.width);
	CGFloat textHeight = ceilf(textRect.size.height);
	
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
	
	return CGRectIntersection(insettedBounds, CGRectMake(originX, originY, textWidth, textHeight));
}

//
// -----------------------------------------------------------------------------
- (void)drawTextInRect:(CGRect)rect
{
	CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
	
	// нулевая ширина или высота?
	if (textRect.size.width == 0 || textRect.size.height == 0) {
		return;
	}
	
	UIFont *originalFont;
	
	if (self.correctedFont) {
		originalFont = self.font;
		self.font = self.correctedFont;
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
	if (self.correctedFont) {
		self.font = originalFont;
		self.correctedFont = nil;
	}
}

@end
