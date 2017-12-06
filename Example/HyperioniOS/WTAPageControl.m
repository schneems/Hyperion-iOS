//
//  WTAPageControl.m
//  HyperioniOS_Example
//
//  Created by Ben Humphries on 12/3/17.
//  Copyright © 2017 chrsmys. All rights reserved.
//

#import "WTAPageControl.h"

@implementation WTAPageControl
{
    UIStackView *stackView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self updateIndicators];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self updateIndicators];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self updateIndicators];
}

- (void)updateIndicators
{
    [stackView removeFromSuperview];

    NSMutableArray *indicators = [[NSMutableArray alloc] initWithCapacity:_numberOfPages];
    for (int i = 0; i < _numberOfPages; i++)
    {
        UIImage *indicator = i == self.currentPage ? [UIImage imageNamed:@"currentIndicator"] : [UIImage imageNamed:@"indicator"];
        [indicators addObject:[[UIImageView alloc] initWithImage:indicator]];
    }
    stackView = [[UIStackView alloc] initWithArrangedSubviews:indicators];
    stackView.spacing = 28;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    [self addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
    [stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
}

@end
