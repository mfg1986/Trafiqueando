//
//  TRTarjetaMapa.m
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRTarjetaMapa.h"

@implementation TRTarjetaMapa
@synthesize coordinate;

//Inicializador con coordenadas
-(id)initConCoordenada:(CLLocationCoordinate2D)coordenada{
    if(self=[super init]){
        self.coordinate=coordenada;
        
    }
    return self;
}

@end
