#import "BBWeeAppController-Protocol.h"
#import <QuartzCore/QuartzCore.h>

//@author: Joseph Fabisevich
//@version: 1.3.5

static NSBundle *_QuickNoteWeeAppBundle = nil;

float BUTTON_WIDTH = 76.0f;

@interface QuickNoteController: NSObject <BBWeeAppController, UITextViewDelegate> 
{
	UIView *_view;
	UIImageView *_backgroundView;
	UITextView *_textview;
}

@property (nonatomic, retain) UIView *view;

@end

@implementation QuickNoteController

@synthesize view = _view;

+ (void)initialize {
	_QuickNoteWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init {
	if((self = [super init]) != nil) {
	} return self;
}

- (void)dealloc {
	[_view release];
	[_backgroundView release];
	[_textview release];
	[super dealloc];
}

-(void) viewDidDisappear
{
    _textview.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-4, [self viewHeight]);
    [_textview resignFirstResponder];   
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textview.frame = CGRectMake(0, 0, _view.frame.size.width-BUTTON_WIDTH, [self viewHeight]);

	UIButton *_killme = [UIButton buttonWithType:UIButtonTypeCustom];
	_killme.frame = CGRectMake(_view.frame.size.width-68, 3, 64, [self viewHeight]-6);
	
	_killme.backgroundColor = [UIColor blackColor];
	[_killme setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
	
	[_killme setTitle:@"Done" forState:UIControlStateNormal];         
	_killme.layer.cornerRadius = 8.0f;
	[_view addSubview:_killme];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDoneButton)];
	tap.numberOfTapsRequired = 1;
	
	[_killme addGestureRecognizer: tap];
	
	[[_textview window] makeKeyAndVisible];
}

-(void) removeDoneButton
{
    _textview.frame = CGRectMake(0.0f, 0.0f, _view.frame.size.width-4, [self viewHeight]);

    [_textview resignFirstResponder];

	for(UIButton *b in _view.subviews)
		if([b isKindOfClass: [UIButton class]])
			[b removeFromSuperview];
	
	[[[UIApplication sharedApplication] keyWindow] makeKeyAndVisible];
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:_textview.text forKey:@"theText"];
}


- (void)loadFullView {
	
	_textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self viewHeight])];
	_textview.delegate = self;
	_textview.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	_textview.text = [prefs objectForKey: @"theText"] == nil ? @"Welcome to quicknote." : [prefs objectForKey:@"theText"];
	
	_textview.textColor = [UIColor whiteColor];
	_textview.layer.cornerRadius = 8.0f;

	_textview.backgroundColor = [UIColor clearColor];

	NSDictionary *prefsDict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mergesort.QuickNote.plist"];
	
	int fontSize = (prefsDict != nil) ? [[prefsDict objectForKey:@"fontSize"] intValue] : 12;
	
	[_textview setFont:[UIFont systemFontOfSize:fontSize]];
	
	[prefsDict release];
	
	[_view addSubview:_textview];
	// Add subviews to _backgroundView (or _view) here.
}

- (void)loadPlaceholderView {
	// This should only be a placeholder - it should not connect to any servers or perform any intense data loading operations.
	
	// All widgets are 316 points wide. Image size calculations match those of the Stocks widget.
	
	_view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {316.f, [self viewHeight]}}];
	_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UIImage *bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
	UIImage *stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
	_backgroundView = [[UIImageView alloc] initWithImage:stretchableBgImg];
	_backgroundView.frame = CGRectInset(_view.bounds, 2.f, 0.f);
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_view addSubview:_backgroundView];
}

- (void)unloadView {
	[_view release];
	_view = nil;
	[_backgroundView release];
	_backgroundView = nil;
	// Destroy any additional subviews you added here. Don't waste memory :(.
}

- (float)viewHeight {

	NSDictionary *prefsDict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mergesort.QuickNote.plist"];
		
	int numberOfLines = (prefsDict != nil) ? [[prefsDict objectForKey:@"numberOfLines"] intValue] : 3;
	
	[prefsDict release];
	
	return (float)(numberOfLines * 23.0f);
}

@end
