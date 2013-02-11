//
//  ViewController.m
//  AttributedTextTests
//
//  Created by Rob Rogers on 2/9/13.
//  Copyright (c) 2013 Rob Rogers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *wordStepper;
@property (weak, nonatomic) IBOutlet UILabel *selectedWordlabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedFontsizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attrTextLabel;
@property (strong,nonatomic) NSArray *wordList;
@end
@implementation ViewController
-(void) setLabelAttributes:(NSDictionary *) attributes range:(NSRange) range
{
    if (range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attrTextLabel.attributedText mutableCopy];
        [mat addAttributes:attributes range: range];
        self.attrTextLabel.attributedText = mat;
    }
}
-(void) setSelectedWordAttributes:(NSDictionary *) attribute
{
    NSRange range = [[self.attrTextLabel.attributedText string] rangeOfString:[self selectedWord]];
    [self setLabelAttributes:attribute range:range];
}
-(NSArray *)wordList {
    if (!_wordList) {
        _wordList = [[self.attrTextLabel.attributedText string] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return [_wordList count] ? _wordList: @[@""];
}
-(NSString *) selectedWord
{
    return self.wordList[(int)self.wordStepper.value];
}
-(UIFont *) getWordFontAttr
{
    NSRange range = [[self.attrTextLabel.attributedText string] rangeOfString:[self selectedWord]];
    if (range.location == NSNotFound) {
        NSLog(@"getWordFontAttr: Can't find range of word. WHY?!?!?");
        return nil;
    }
    NSDictionary *attributes = [self.attrTextLabel.attributedText attributesAtIndex:range.location effectiveRange:NULL];
    UIFont *font = attributes[NSFontAttributeName];
    if (font)
        return font;
    return nil;
}
- (IBAction)updatedSelectedWordColor:(UIButton *)sender {
    [self setSelectedWordAttributes: @{NSForegroundColorAttributeName: sender.backgroundColor}];
}
- (IBAction)ununderlineSelectedWord {
    [self setSelectedWordAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
}
- (IBAction)underlineSelectedWord {
    [self setSelectedWordAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
}
- (IBAction)changeFontStyle:(UIButton *)sender {
    CGFloat afontsize = [UIFont systemFontSize];
    
    UIFont *f = [self getWordFontAttr];
    if (f)
        afontsize = f.pointSize;
    UIFont *nf = [sender.titleLabel.font fontWithSize:afontsize];
    [self setSelectedWordAttributes:@{NSFontAttributeName: nf}];
}
- (IBAction)changeFontSizeOfWord:(UIStepper *)sender {
    UIFont *f = [self getWordFontAttr];
    double nfs = f.pointSize + sender.value;
    NSLog(@"CHange fontsize %g", nfs);
    NSLog(@"stepper value %g",sender.value);
    NSDictionary *fa = @{NSFontAttributeName: [UIFont systemFontOfSize:nfs]};
    [self setSelectedWordAttributes:fa];
    self.selectedFontsizeLabel.text = [NSString stringWithFormat:@"Font size %d", (int) nfs];
    sender.value = 0;
}
- (IBAction)changeFontSize:(UIStepper *)sender {
    NSLog(@"stepper Changed %g", sender.value);
}
- (IBAction)updateSelectedWord {
    UIFont *f = [self getWordFontAttr];
    self.wordStepper.maximumValue = [self.wordList count] -1;
    self.selectedWordlabel.text = [self selectedWord];
    self.selectedFontsizeLabel.text = [NSString stringWithFormat:@"Font size %d", (int) f.pointSize];
}
- (IBAction)outline
{
    [self setSelectedWordAttributes:@{NSStrokeWidthAttributeName : @(3.0)}];
}
- (IBAction)unoutline
{
    [self setSelectedWordAttributes:@{NSStrokeWidthAttributeName : @(0)}];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *s = @"Learn about the amazing things you can do with attritubted text. We will study: changing font sizes, font colors,and decoration including bold and italics. We can change these for each substring of this attributed text string.";
        
    self.attrTextLabel.text = s;
    self.wordStepper.minimumValue = 0;
    NSString *t = [NSString stringWithString:[self.wordList objectAtIndex:0]];
    self.selectedWordlabel.text = t;
    UIFont *f = [self getWordFontAttr];
    CGFloat fs = f.pointSize;
    self.selectedFontsizeLabel.text = [NSString stringWithFormat:@"Font size %d", (int)fs];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
