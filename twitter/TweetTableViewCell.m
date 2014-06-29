//
//  TweetTableViewCell.m
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "TweetTableViewCell.h"

@interface TweetTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.userName.text = tweet.userName;
    self.userScreenName.text = tweet.userScreenName;
    self.text.text = tweet.text;
    self.time.text = [tweet createdAtAsElapsed];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.userProfileImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        [self setImageOnMainThread:self.userProfileImage image:image];
    }];
}

- (void)setImageOnMainThread: (UIImageView *)imageView image:(UIImage *)image {
    if (!image)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [imageView.layer addAnimation:transition forKey:nil];
        
        imageView.image = image;
    });
}

- (void)layoutSubviews {
    // Fix the issue where text height is wrong for multi-line text
    // (Especially when 3 lines of text, it introduces padding at upper and lower edges).
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.text.preferredMaxLayoutWidth = CGRectGetWidth(self.text.frame);
}

@end
