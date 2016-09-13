//
//  TRFeed.h
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TRFeed : NSObject

/***************VARIABLES O PROPIEDADES****************/
@property (strong) NSString *titulo;
@property (strong) NSURL *link;
@property (strong) NSMutableString *desc;
@property (strong) NSString *fecha;
@property CGFloat latitud;
@property CGFloat longitud;
@property (strong) NSString *tipo;

@end
