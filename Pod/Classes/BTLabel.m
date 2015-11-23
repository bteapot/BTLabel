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
@property (nonatomic, assign) CGRect calculatedImageRect;

@end


@implementation BTLabel

#pragma mark - Constants

const NSStringDrawingOptions kDrawingOptions = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine;


#pragma mark - Class methods

//
// -----------------------------------------------------------------------------
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font edgeInsets:(UIEdgeInsets)edgeInsets numberOfLines:(NSUInteger)numberOfLines imageSize:(CGSize)imageSize imagePosition:(UIRectEdge)imagePosition imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
	// вычтем размер картинки
	CGFloat imageWidth = 0;
	CGFloat imageHeight = 0;
	
	switch (imagePosition) {
		case UIRectEdgeTop:
		case UIRectEdgeBottom: {
			imageHeight	= imageSize.height + imageEdgeInsets.top + imageEdgeInsets.bottom;
			break;
		}
		case UIRectEdgeLeft:
		case UIRectEdgeRight: {
			imageWidth	= imageSize.width + imageEdgeInsets.left + imageEdgeInsets.right;
			imageHeight	= imageSize.height + imageEdgeInsets.top + imageEdgeInsets.bottom;
			break;
		}
		default: {
			break;
		}
	}
	
	// область текста
	CGSize insettedSize = CGSizeMake(MAX(width - edgeInsets.left - edgeInsets.right - imageWidth, 0), CGFLOAT_MAX);
	
	// фактическая высота текста
	CGFloat height;
	
	if ([text isKindOfClass:[NSString class]]) {
		height = [text boundingRectWithSize:insettedSize options:kDrawingOptions attributes:@{NSFontAttributeName: font} context:nil].size.height;
	} else {
		height = [text boundingRectWithSize:insettedSize options:kDrawingOptions context:nil].size.height;
	}
	
	// ограничение по количеству линий
	if (numberOfLines > 0) {
		CGFloat maxHeight = font.lineHeight * numberOfLines;
		
		if (height > maxHeight) {
			height = maxHeight;
		}
	}
	
	// прибавим размер полей
	width	+= edgeInsets.left + edgeInsets.right;
	height	+= edgeInsets.top + edgeInsets.bottom;
	
	// прибавим размер картинки
	switch (imagePosition) {
		case UIRectEdgeTop:
		case UIRectEdgeBottom: {
			height += imageHeight;
			break;
		}
		case UIRectEdgeLeft:
		case UIRectEdgeRight: {
			height = MAX(height, imageHeight);
			break;
		}
		default: {
			break;
		}
	}
	
	return ceilf(height);
}

//
// -----------------------------------------------------------------------------
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font edgeInsets:(UIEdgeInsets)edgeInsets
{
	return [self heightForWidth:width text:text font:font edgeInsets:edgeInsets numberOfLines:0 imageSize:CGSizeZero imagePosition:UIRectEdgeNone imageEdgeInsets:UIEdgeInsetsZero];
}

//
// -----------------------------------------------------------------------------
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font
{
	return [self heightForWidth:width text:text font:font edgeInsets:UIEdgeInsetsZero numberOfLines:0 imageSize:CGSizeZero imagePosition:UIRectEdgeNone imageEdgeInsets:UIEdgeInsetsZero];
}


#pragma mark - Initialization

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


#pragma mark - NSCoding protocol

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


#pragma mark - Layout

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


#pragma mark - Text size

//
// -----------------------------------------------------------------------------
- (CGSize)sizeThatFits:(CGSize)size
{
	// текущие параметры
	UIEdgeInsets edgeInsets			= self.edgeInsets;
	NSInteger numberOfLines			= self.numberOfLines;
	BOOL hasImage					= self.hasImage;
	CGSize imageSize				= self.imageSize;
	UIRectEdge imagePosition		= self.imagePosition;
	UIEdgeInsets imageEdgeInsets	= self.imageEdgeInsets;
	
	// вычтем размер картинки
	CGFloat imageWidth = 0;
	CGFloat imageHeight = 0;
	
	if (hasImage) {
		switch (imagePosition) {
			case UIRectEdgeTop:
			case UIRectEdgeBottom: {
				imageHeight	= imageSize.height + imageEdgeInsets.top + imageEdgeInsets.bottom;
				break;
			}
			case UIRectEdgeLeft:
			case UIRectEdgeRight: {
				imageWidth	= imageSize.width + imageEdgeInsets.left + imageEdgeInsets.right;
				imageHeight	= imageSize.height + imageEdgeInsets.top + imageEdgeInsets.bottom;
				break;
			}
			default: {
				break;
			}
		}
	}
	
	// область текста
	CGSize insettedSize = CGSizeMake(MAX(size.width - edgeInsets.left - edgeInsets.right - imageWidth, 0), CGFLOAT_MAX);
	
	// фактический размер текста
	CGRect rect = [self.attributedText boundingRectWithSize:insettedSize options:kDrawingOptions context:nil];
	
	CGFloat width	= rect.size.width;
	CGFloat height	= rect.size.height;
	
	// ограничение по количеству линий
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
	
	// прибавим размер полей
	width	+= edgeInsets.left + edgeInsets.right;
	height	+= edgeInsets.top + edgeInsets.bottom;
	
	// прибавим размер картинки
	if (hasImage) {
		switch (imagePosition) {
			case UIRectEdgeTop:
			case UIRectEdgeBottom: {
				height += imageHeight;
				break;
			}
			case UIRectEdgeLeft:
			case UIRectEdgeRight: {
				height = MAX(height, imageHeight);
				break;
			}
			default: {
				break;
			}
		}
		
		width += imageWidth;
	}
	
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


#pragma mark - Geometry

//
// -----------------------------------------------------------------------------
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	// текущие параметры
	UIEdgeInsets edgeInsets			= self.edgeInsets;
	BOOL hasImage					= self.hasImage;
	CGSize imageSize				= self.imageSize;
	UIRectEdge imagePosition		= self.imagePosition;
	NSTextAlignment imageAlignment	= self.imageAlignment;
	UIEdgeInsets imageEdgeInsets	= self.imageEdgeInsets;
	
	// вычислим рамку картинки и учтём её размер при вычислении рамки текста
	CGRect imageRect = CGRectZero;
	
	if (hasImage) {
		
		// авторазмер картики
		if (imageSize.width == 0) {
			imageSize.width = bounds.size.width - imageEdgeInsets.left - imageEdgeInsets.right;
		}
		
		if (imageSize.height == 0) {
			imageSize.height = bounds.size.height - imageEdgeInsets.top - imageEdgeInsets.bottom;
		}
		
		// размер картинки вместе с отступами
		imageSize = CGSizeMake(imageSize.width + imageEdgeInsets.left + imageEdgeInsets.right, imageSize.height + imageEdgeInsets.top + imageEdgeInsets.bottom);
		
		// положение картинки
		switch (imagePosition) {
				
			// верхний край
			case UIRectEdgeTop: {
				
				switch (imageAlignment) {
					// верхний край, слева
					case NSTextAlignmentLeft:
						imageRect = CGRectMake(bounds.origin.x,
											   bounds.origin.y,
											   imageSize.width,
											   imageSize.height);
						break;
					// верхний край, справа
					case NSTextAlignmentRight:
						imageRect = CGRectMake(bounds.origin.x + bounds.size.width - imageSize.width,
											   bounds.origin.y,
											   imageSize.width,
											   imageSize.height);
						break;
					// верхний край, центр
					case NSTextAlignmentCenter:
					default:
						imageRect = CGRectMake(bounds.origin.x + (bounds.size.width - imageSize.width) / 2,
											   bounds.origin.y,
											   imageSize.width,
											   imageSize.height);
						break;
				}
				
				bounds.origin.y += imageRect.size.height;
				bounds.size.height -= imageRect.size.height;
				
				break;
			}
				
			// нижний край
			case UIRectEdgeBottom: {
				
				switch (imageAlignment) {
					// нижний край, слева
					case NSTextAlignmentLeft:
						imageRect = CGRectMake(bounds.origin.x,
											   bounds.origin.y + bounds.size.height - imageSize.height,
											   imageSize.width,
											   imageSize.height);
						break;
					// нижний край, справа
					case NSTextAlignmentRight:
						imageRect = CGRectMake(bounds.origin.x + bounds.size.width - imageSize.width,
											   bounds.origin.y + bounds.size.height - imageSize.height,
											   imageSize.width,
											   imageSize.height);
						break;
					// нижний край, центр
					case NSTextAlignmentCenter:
					default:
						imageRect = CGRectMake(bounds.origin.x + (bounds.size.width - imageSize.width) / 2,
											   bounds.origin.y + bounds.size.height - imageSize.height,
											   imageSize.width,
											   imageSize.height);
						break;
				}
				
				bounds.size.height -= imageRect.size.height;
				
				break;
			}
			
			// левый край
			case UIRectEdgeLeft: {
				
				switch (imageAlignment) {
					// левый край, сверху
					case NSTextAlignmentLeft:
						imageRect = CGRectMake(bounds.origin.x,
											   bounds.origin.y,
											   imageSize.width,
											   imageSize.height);
						break;
					// левый край, снизу
					case NSTextAlignmentRight:
						imageRect = CGRectMake(bounds.origin.x,
											   bounds.origin.y + bounds.size.height - imageSize.height,
											   imageSize.width,
											   imageSize.height);
						break;
					// левый край, центр
					case NSTextAlignmentCenter:
					default:
						imageRect = CGRectMake(bounds.origin.x,
											   bounds.origin.y + (bounds.size.height - imageSize.height) / 2,
											   imageSize.width,
											   imageSize.height);
						break;
				}
				
				bounds.origin.x += imageRect.size.width;
				bounds.size.width -= imageRect.size.width;
				
				break;
			}
				
			// правый край
			case UIRectEdgeRight: {
				
				switch (imageAlignment) {
					// правый край, сверху
					case NSTextAlignmentLeft:
						imageRect = CGRectMake(bounds.origin.x + bounds.size.width - imageSize.width,
											   bounds.origin.y,
											   imageSize.width,
											   imageSize.height);
						break;
					// правый край, снизу
					case NSTextAlignmentRight:
						imageRect = CGRectMake(bounds.origin.x + bounds.size.width - imageSize.width,
											   bounds.origin.y + bounds.size.height - imageSize.height,
											   imageSize.width,
											   imageSize.height);
						break;
					// правый край, центр
					case NSTextAlignmentCenter:
					default:
						imageRect = CGRectMake(bounds.origin.x + bounds.size.width - imageSize.width,
											   bounds.origin.y + (bounds.size.height - imageRect.size.height) / 2,
											   imageSize.width,
											   imageSize.height);
						break;
				}
				
				bounds.size.width -= imageRect.size.width;
				
				break;
			}
			default: {
				break;
			}
		}
		
		// вычтем отступы картинки
		imageRect = UIEdgeInsetsInsetRect(imageRect, imageEdgeInsets);
	}
	
	// запомним рамку картинки
	self.calculatedImageRect = CGRectIntegral(imageRect);
	
	// вычтем отступы текста
	bounds = UIEdgeInsetsInsetRect(bounds, edgeInsets);
	
	// поправим bounds
	if (bounds.size.width < 0) {
		bounds.size.width = 0;
	}
	
	if (bounds.size.height < 0) {
		bounds.size.height = 0;
	}
	
	// вычислим рамку текста
	CGRect textRect = CGRectZero;
	
	// будем менять размер шрифта?
	self.correctedFont = nil;
	UIFont *originalFont;
	
	if (self.adjustsFontSizeToFitWidth && numberOfLines == 1) {
		textRect.size = CGSizeMake([self.attributedText size].width, self.font.lineHeight);
		
		// не влезает?
		if (textRect.size.width > bounds.size.width) {
			
			// сохраним текущий шрифт
			originalFont = self.font;
			CGFloat originalPointSize = originalFont.pointSize;
			
			// вычислим коэффициент уменьшения
			CGFloat ratio = bounds.size.width / textRect.size.width;
			
			// предполагаемый кегель шрифта
			CGFloat currentFontSize = originalPointSize * MAX(ratio, self.minimumScaleFactor);
			self.font = [UIFont fontWithName:originalFont.fontName size:currentFontSize];
			textRect.size = CGSizeMake(MIN([self.attributedText size].width, bounds.size.width), MIN(self.font.lineHeight, bounds.size.height));
		}
	} else {
		BOOL decreasesFontSizeToFitNumberOfLines = self.decreasesFontSizeToFitNumberOfLines && numberOfLines > 1;
		BOOL increasesFontSizeToFitNumberOfLines = self.increasesFontSizeToFitNumberOfLines && numberOfLines > 1;
		
		if (decreasesFontSizeToFitNumberOfLines || increasesFontSizeToFitNumberOfLines) {
			CGFloat maxHeight = ceilf(self.font.lineHeight * numberOfLines);
			CGFloat ratio = MAX(bounds.size.height / maxHeight, self.minimumScaleFactor);
			
			if ((decreasesFontSizeToFitNumberOfLines && ratio < 1) ||
				(increasesFontSizeToFitNumberOfLines && ratio > 1)) {
				originalFont = self.font;
				self.font = [self.font fontWithSize:originalFont.pointSize * ratio];
			}
		}
		
		textRect = [self.attributedText boundingRectWithSize:bounds.size options:kDrawingOptions context:nil];
		
		if (numberOfLines > 0) {
			CGFloat maxHeight = self.font.lineHeight * numberOfLines;
			
			if (textRect.size.height > maxHeight) {
				textRect.size.height = maxHeight;
			}
		}
	}
	
	// восстановим, если надо, шрифт
	if (originalFont) {
		self.correctedFont = self.font;
		self.font = originalFont;
	}
	
	// размеры тектового блока
	CGFloat textWidth = ceilf(textRect.size.width);
	CGFloat textHeight = ceilf(textRect.size.height);
	
	// позиция текстового блока
	CGFloat originX;
	CGFloat originY;
	
	switch (self.verticalAlignment) {
		case BTVerticalAlignmentTop:
			originY = bounds.origin.y;
			break;
			
		case BTVerticalAlignmentCenter:
			originY = bounds.origin.y + (bounds.size.height - textHeight) / 2;
			break;
			
		case BTVerticalAlignmentBottom:
			originY = bounds.origin.y + (bounds.size.height - textHeight);
			break;
			
		default:
			break;
	}
	
	switch (self.textAlignment) {
		case NSTextAlignmentJustified:
		case NSTextAlignmentLeft:
		case NSTextAlignmentNatural:
			originX = bounds.origin.x;
			break;
			
		case NSTextAlignmentCenter:
			originX = bounds.origin.x + (bounds.size.width - textWidth) / 2;
			break;
			
		case NSTextAlignmentRight:
			originX = bounds.origin.x + (bounds.size.width - textWidth);
			break;
			
		default:
			break;
	}
	
	return CGRectIntersection(CGRectIntegral(bounds), CGRectMake(originX, originY, textWidth, textHeight));
}

//
// -----------------------------------------------------------------------------
- (void)drawTextInRect:(CGRect)rect
{
	CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
	
	// нулевая ширина или высота?
	if (textRect.size.width > 0 && textRect.size.height > 0) {
		UIFont *originalFont;
		
		if (self.correctedFont) {
			originalFont = self.font;
			self.font = self.correctedFont;
		}
		
		// рисуем текст
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
	
	// рисуем картинку?
	UIImage *image = self.image;
	CGRect imageFrame = self.calculatedImageRect;
	
	if (self.hasImage && image && CGRectIntersectsRect(imageFrame, rect)) {
		
		CGSize imageSize = image.size;
		CGRect imageRect;
		
		switch (self.imageContentMode) {
			case UIViewContentModeScaleToFill: {
				imageRect = imageFrame;
				break;
			}
			case UIViewContentModeScaleAspectFit: {
				CGFloat ratio = MIN(imageFrame.size.width / imageSize.width, imageFrame.size.height / imageSize.height);
				CGFloat dx = (imageFrame.size.width - imageSize.width * ratio) / 2;
				CGFloat dy = (imageFrame.size.height - imageSize.height * ratio) / 2;
				imageRect = CGRectInset(imageFrame, dx, dy);
				break;
			}
			case UIViewContentModeScaleAspectFill: {
				CGFloat ratio = MAX(imageFrame.size.width / imageSize.width, imageFrame.size.height / imageSize.height);
				CGFloat dx = (imageFrame.size.width - imageSize.width * ratio) / 2;
				CGFloat dy = (imageFrame.size.height - imageSize.height * ratio) / 2;
				imageRect = CGRectInset(imageFrame, dx, dy);
				break;
			}
			case UIViewContentModeRedraw: {
				imageRect = imageFrame;
				break;
			}
			case UIViewContentModeCenter: {
				CGFloat x = imageFrame.origin.x + (imageFrame.size.width - imageSize.width) / 2;
				CGFloat y = imageFrame.origin.y + (imageFrame.size.height - imageSize.height) / 2;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeTop: {
				CGFloat x = imageFrame.origin.x + (imageFrame.size.width - imageSize.width) / 2;
				CGFloat y = imageFrame.origin.y;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeBottom: {
				CGFloat x = imageFrame.origin.x + (imageFrame.size.width - imageSize.width) / 2;
				CGFloat y = imageFrame.origin.y + imageFrame.size.height - imageSize.height;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeLeft: {
				CGFloat x = imageFrame.origin.x;
				CGFloat y = imageFrame.origin.y + (imageFrame.size.height - imageSize.height) / 2;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeRight: {
				CGFloat x = imageFrame.origin.x + imageFrame.size.width - imageSize.width;
				CGFloat y = imageFrame.origin.y + (imageFrame.size.height - imageSize.height) / 2;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeTopLeft: {
				CGFloat x = imageFrame.origin.x;
				CGFloat y = imageFrame.origin.y;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeTopRight: {
				CGFloat x = imageFrame.origin.x + imageFrame.size.width - imageSize.width;
				CGFloat y = imageFrame.origin.y;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeBottomLeft: {
				CGFloat x = imageFrame.origin.x;
				CGFloat y = imageFrame.origin.y + imageFrame.size.height - imageSize.height;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
			case UIViewContentModeBottomRight: {
				CGFloat x = imageFrame.origin.x + imageFrame.size.width - imageSize.width;
				CGFloat y = imageFrame.origin.y + imageFrame.size.height - imageSize.height;
				imageRect = CGRectMake(x, y, imageSize.width, imageSize.height);
				break;
			}
		}
		
		UIRectClip(imageFrame);
		[image drawInRect:CGRectIntegral(imageRect)];
	}
}


#pragma mark - Image

//
// -----------------------------------------------------------------------------
- (void)setHasImage:(BOOL)hasImage
{
	_hasImage = hasImage;
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setImageSize:(CGSize)imageSize
{
	_imageSize = imageSize;
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setImagePosition:(UIRectEdge)imagePosition
{
	_imagePosition = imagePosition;
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setImageContentMode:(UIViewContentMode)imageContentMode
{
	_imageContentMode = imageContentMode;
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
	_imageEdgeInsets = imageEdgeInsets;
	[self setNeedsDisplay];
}

//
// -----------------------------------------------------------------------------
- (void)setImage:(UIImage *)image
{
	_image = image;
	[self setNeedsDisplay];
}

@end
