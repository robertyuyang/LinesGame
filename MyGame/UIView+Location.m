//
//  UIView+Location.m
//  MyGame
//
//  Created by mac on 9/11/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "UIView+Location.h"

@implementation UIView (Locatoin)

-(CGFloat) left {
    return self.frame.origin.x;
}


-(CGFloat) right {
    return self.frame.origin.x + self.frame.size.width;
}


-(CGFloat) top {
    return self.frame.origin.y;
}


-(CGFloat) bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat) width {
    return self.right - self.left;
}

-(CGFloat) height {
    return self.bottom - self.top;
}

@end
