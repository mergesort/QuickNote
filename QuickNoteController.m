#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SpringBoard/SpringBoard.h>
#import "BBWeeAppController-Protocol.h"

//@author: Joseph Fabisevich
//@version: 1.0

float VIEW_HEIGHT = 70.0f;
float BUTTON_WIDTH = 76.0f;
@interface UIImage (LolAdditions)
-(UIImage*)resizableImageWithCapInsets:(UIEdgeInsets)arg1;
 @end

@interface QuickNoteController : NSObject <BBWeeAppController, UITextViewDelegate>
{
	UIView *_view;
    UITextView *_textview;
    UIButton *_killme;
    UIImageView *bg;
    BOOL editing;
}

@end

@implementation QuickNoteController

- (id)init
{   if((self = [super init])){}    return self;   }

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _killme.hidden = NO;
    _textview.frame = CGRectMake(0, 0, _view.frame.size.width-BUTTON_WIDTH, VIEW_HEIGHT);
    bg.frame = CGRectMake(0, 0, _view.frame.size.width-BUTTON_WIDTH, VIEW_HEIGHT);
    editing = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:_textview.text forKey:@"theText"];
}

-(void) buttonClicked
{
    editing = NO;
    _killme.hidden = YES;
    _textview.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-4, VIEW_HEIGHT);
    bg.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-4, VIEW_HEIGHT);   
    [_textview resignFirstResponder];
}

- (UIView *)view
{
	if (!_view)
	{
        editing = NO;
		_view = [[UIView alloc] init];
        if([(SpringBoard *)[UIApplication sharedApplication] activeInterfaceOrientation] == UIInterfaceOrientationPortrait ||
           [(SpringBoard *)[UIApplication sharedApplication] activeInterfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown)
            _view.frame = CGRectMake(2.0f, 0.0f, 316.0f, VIEW_HEIGHT);
        else
            _view.frame = CGRectMake(2.0f, 0.0f, 476.0f, VIEW_HEIGHT);            
        
        
        UIImage *bgImg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0f, 4.0f, 35.0f, 4.0f)];
        bg = [[UIImageView alloc] initWithImage:bgImg];
        
        if([(SpringBoard *)[UIApplication sharedApplication] activeInterfaceOrientation] == UIInterfaceOrientationPortrait ||
           [(SpringBoard *)[UIApplication sharedApplication] activeInterfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown)
            bg.frame = CGRectMake(0.0f, 0.0f, 316.0f, VIEW_HEIGHT);
        else
            bg.frame = CGRectMake(0.0f, 0.0f, 476.0f, VIEW_HEIGHT);
        
        [_view addSubview:bg];
        [bg release];
        
        _textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VIEW_HEIGHT)];
        _textview.delegate = self;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if([prefs objectForKey: @"theText"] == nil)
            [_textview setText:@"Welcome to quicknote."];
        else
            [_textview setText:[prefs objectForKey:@"theText"]];
        
        [_view addSubview:_textview];
        _textview.textColor = [UIColor whiteColor];
        _textview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"/System/Library/WeeAppPlugins/WeatherNotifications.bundle/weeapp_bg@2x.png"]];
        _textview.layer.cornerRadius = 8.0f;
    
        _killme = [UIButton buttonWithType:UIButtonTypeCustom];
        _killme.frame = CGRectMake(_view.frame.size.width-66, 2, 64, 64);
      
        [_killme addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchDown];
        _killme.userInteractionEnabled = YES;
        _killme.hidden = YES;
        
        _killme.backgroundColor = [UIColor blackColor];
        [_killme setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [_killme setTitle:@"Done" forState:UIControlStateNormal];         
        _killme.layer.cornerRadius = 10.0f;
        [_view addSubview:_killme];
	}

	return _view;
}

-(void) viewDidDisappear
{
    editing = NO;
    _killme.hidden = YES;
    _textview.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-4, VIEW_HEIGHT);
    bg.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-4, VIEW_HEIGHT);   
    [_textview resignFirstResponder];   
}

-(void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orientation
{
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        _view.frame = CGRectMake(2.0f, 0.0f, 316.0f, VIEW_HEIGHT);
    else
        _view.frame = CGRectMake(2.0f, 0.0f, 476.0f, VIEW_HEIGHT);

    _killme.frame = CGRectMake(_view.frame.size.width-66, 2, 64, 64);

    if(editing)
    {
        bg.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-BUTTON_WIDTH, VIEW_HEIGHT);   
        _textview.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-BUTTON_WIDTH, VIEW_HEIGHT);
    }
    else
    {
        _textview.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width, VIEW_HEIGHT);
        bg.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width, VIEW_HEIGHT);   
    }
    [_textview resignFirstResponder];
}

- (float)viewHeight
{
	return VIEW_HEIGHT;
}

@end
