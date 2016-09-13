//
//  TRTarjetaMapa.h
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TRTarjetaMapaView.h"


@interface TRTarjetaMapa : NSObject<MKAnnotation>

/*********VARIABLES O PROPIEDADES***********/
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *fecha;
@property (nonatomic) MKMapView *mapView;
@property (nonatomic) MKAnnotationView *pinpulsado;
@property(nonatomic,strong) TRTarjetaMapaView *tarjetaView;

/************MÉTODOS***************/
-(id)initConCoordenada:(CLLocationCoordinate2D) coordinate;



@end
