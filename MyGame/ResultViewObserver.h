//
//  ResultViewObserver.h
//  MyGame
//
//  Created by mac on 9/19/16.
//  Copyright © 2016 robert. All rights reserved.
//

#ifndef ResultViewObserver_h
#define ResultViewObserver_h

@protocol ResultViewObserver

-(void) onRestart;
-(void) onNewScoreUserNameInputed: (NSString*) name;
@end

#endif /* ResultViewObserver_h */
