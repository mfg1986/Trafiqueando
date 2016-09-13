//
//  TRPinMapa.h
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TRPinMapa : NSObject<MKAnnotation>

/********VARIABLES O PROPIEDADES***********/
@property (nonatomic, copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *type;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) MKAnnotationView* vistaAnotacion;
@property (nonatomic)BOOL pinPulsado;


/****************METODOS********************/
//Inicializador solo con coordenadas
-(id)initConCoordenada:(CLLocationCoordinate2D)coordenada;
//Inicializador con datos
-(id)initWithTitle:(NSString *)aTitle subtitle:(NSString *)aSubtitle Type:(NSString *)aType andCoordinate:(CLLocationCoordinate2D) coord;
@end



