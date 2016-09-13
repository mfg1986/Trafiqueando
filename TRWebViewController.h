//
//  TRWebViewController.h
//  Trafiqueando
//
//  Created by maria on 16/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRWebViewController : UIViewController

/*************VARIABLES O PROPIEDADES************/
//Vista donde cargar la web asociada a la url
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//url de la página oficial
@property (nonatomic,strong) NSURL *link;
@end
