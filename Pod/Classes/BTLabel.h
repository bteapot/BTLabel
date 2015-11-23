//
//  BTLabel.h
//  BTLabel
//
//  Created by Денис Либит on 26.12.2014.
//  Copyright (c) 2014 Денис Либит. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Options for aligning text vertically for BTLabel.
 */
typedef NS_ENUM(NSUInteger, BTVerticalAlignment) {
	/**
	 Align text to the top edge of label.
	 */
	BTVerticalAlignmentTop,
	/**
	 Align text to rhe middle of label.
	 */
	BTVerticalAlignmentCenter,
	/**
	 Align text to the bottom edge of label.
	 */
	BTVerticalAlignmentBottom,
};


/**
 UILabel subclass with vertical text alignment, insets and height calculation.
 */
@interface BTLabel : UILabel

#pragma mark - Properties
/// @name Properties

/**
 Insets from the edges of label to a text.
*/
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/**
 Vertical text alignment mode.
 */
@property (nonatomic, assign) BTVerticalAlignment verticalAlignment;
/**
 When set to YES and numberOfLines > 1, receiver will decrease its font size to fit specified number of lines into current bounds. Font size will be reduced by no more than minimumScaleFactor.
 */
@property (nonatomic, assign) BOOL decreasesFontSizeToFitNumberOfLines;
/**
 When set to YES and numberOfLines > 1, receiver will increase its font size to fit specified number of lines into current bounds.
 */
@property (nonatomic, assign) BOOL increasesFontSizeToFitNumberOfLines;
/**
 Show image within receiver.
 */
@property (nonatomic, assign) BOOL hasImage;
/**
 Image size.
 @discussion Will use receiver height for image size when imagePosition is equal to UIRectEdgeLeft or UIRectEdgeRight, and imageSize.height is set to zero. Will use receiver width when imagePosition is equal to UIRectEdgeTop or UIRectEdgeBottom, and imageSize.width is set to zero.
 */
@property (nonatomic, assign) CGSize imageSize;
/**
 Edge of the receiver rect at which image will be placed.
 @discussion Valid values are UIRectEdgeTop, UIRectEdgeLeft, UIRectEdgeBottom and UIRectEdgeRight.
 */
@property (nonatomic, assign) UIRectEdge imagePosition;
/**
 Alignment of image rect.
 @discussion Valid values are NSTextAlignmentLeft, NSTextAlignmentCenter and NSTextAlignmentRight. NSTextAlignmentLeft means top and NSTextAlignmentRight means bottom when using with imagePosition set to UIRectEdgeLeft or UIRectEdgeRight.
 */
@property (nonatomic, assign) NSTextAlignment imageAlignment;
/**
 A flag used to determine how an image will be placed within its rect.
 */
@property (nonatomic, assign) UIViewContentMode imageContentMode;
/**
 Insets from the edges of label to an image.
 */
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
/**
 The image displayed in the label.
 */
@property (nonatomic, strong) UIImage *image;

#pragma mark - Height of arbitrary text
/// @name Height of arbitrary text

/**
 Calculates height of arbitrary text with given width.
 @param width           Width of given text block to calculate the height for.
 @param text            Text for height calculation. Can be NSString or NSAttributedString.
 @param font            Font for given text. Used only when text is of NSString class.
 @param edgeInsets      The geometric padding for the text, in points.
 @param numberOfLines   The maximum number of lines.
 @param imageSize       Image size.
 @param imagePosition   Image position.
 @param imageEdgeInsets The geometric padding for the image, in points.
 @see heightForWidth:text:font:edgeInsets:
 @see heightForWidth:text:font:
 @return Height of given text for given width and parameters.
 */
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font edgeInsets:(UIEdgeInsets)edgeInsets numberOfLines:(NSUInteger)numberOfLines imageSize:(CGSize)imageSize imagePosition:(UIRectEdge)imagePosition imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;
/**
 Calculates height of arbitrary text with given width.
 @discussion Invokes -heightForWidth:text:font:numberOfLines:edgeInsets:imageSize:imagePosition:imageEdgeInsets: with zero numberOfLines, imageSize, imagePosition и imageEdgeInsets.
 @param width      Width of given text block to calculate the height for.
 @param text       Text for height calculation. Can be NSString or NSAttributedString.
 @param font       Font for given text. Used only when text is of NSString class.
 @param edgeInsets The geometric padding for the text, in points.
 @see heightForWidth:text:font:edgeInsets:numberOfLines:imageSize:imagePosition:imageEdgeInsets:
 @see heightForWidth:text:font:
 @return Height of given text for given width and parameters.
 */
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font edgeInsets:(UIEdgeInsets)edgeInsets;
/**
 Calculates height of arbitrary text with given width.
 @discussion Invokes -heightForWidth:text:font:numberOfLines:edgeInsets:imageSize:imagePosition:imageEdgeInsets: with zero edgeInsets, imageSize, imagePosition и imageEdgeInsets. Accepts `NSString` and `NSAttributedString` text. This method returns 'raw' text block height with no padding.
 @param width Width of given text block to calculate the height for.
 @param text  Text for height calculation. Can be NSString or NSAttributedString.
 @param font  Font for given text. Used only when text is of NSString class.
 @see heightForWidth:text:font:edgeInsets:numberOfLines:imageSize:imagePosition:imageEdgeInsets:
 @see heightForWidth:text:font:edgeInsets:
 @return Height of given text for given width.
 */
+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font;


#pragma mark - Initialization
/// @name Initialization

/**
 Initializes and returns a newly allocated label object with the specified frame rectangle and edge insets.
 @discussion Attribute `edgeInsets` will be set to `UIEdgeInsetsZero` if the label was initialized with `initWithFrame:` method.
 @param frame      The frame rectangle for the label, measured in points.
 @param edgeInsets The geometric padding for the text inside the label view, in points.
 @return An initialized view object or nil if the object couldn't be created.
 */
- (instancetype)initWithFrame:(CGRect)frame edgeInsets:(UIEdgeInsets)edgeInsets;


#pragma mark - Height of receiver's text
/// @name Height of receiver's text

/**
 Calculates the height of receiver's `frame` rectangle for current text and given width.
 @param width Width of reciiver `frame` rectangle to calculate the height for, in points.
 @return Calculated height in points.
 */
- (CGFloat)heightForWidth:(CGFloat)width;

/**
 Calculates the height of receiver's `frame` rectangle for current text and given width and changes `frame`'s size to this values.
 @param width Width of reciiver `frame` rectangle to calculate the height for, in points.
 @return Calculated height in points.
 */
- (CGFloat)heightAdjustedForWidth:(CGFloat)width;

@end
