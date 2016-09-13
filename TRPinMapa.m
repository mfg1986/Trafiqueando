//
//  TRPinMapa.m
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRPinMapa.h"

@implementation TRPinMapa
@synthesize title ;
//Método de inicialización solo con coordenada
-(id)initConCoordenada:(CLLocationCoordinate2D)coordenada{
    if(self=[super init]){
        self.coordinate=coordenada;
    }
    return self;
}

//Método de inicialización con datos
-(id)initWithTitle:(NSString *)aTitle subtitle:(NSString *)aSubtitle Type:(NSString *)aType andCoordinate:(CLLocationCoordinate2D)coord{
    if(self=[super init]){
        
        self.title=aTitle;
        self.subtitle=aSubtitle;
        self.type=aType;
        self.coordinate=coord;
        self.pinPulsado=NO;
    }
    return self;
}
@end
