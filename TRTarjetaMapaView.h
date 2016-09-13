//
//  TRTarjetaMapaView.h
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TRContentView.h"
@interface TRTarjetaMapaView : MKAnnotationView
/**********VARIABLES O PROPIEDADES**********/
//Vista del pin pulsado
@property (nonatomic, strong) MKAnnotationView *pinPulsado;
//Vista del mapa
@property (nonatomic, strong) MKMapView *mapView;
//Vista de la tarjeta de detalle
@property (nonatomic,strong) TRContentView *contentAnotacionView;


/**********MÉTODOS**********/
//Metodo para quitar la tarjeta de detalle
-(void)eliminarVista;
//Método para colocar la tarjeta sobre el pin
-(void)colocarTarjeta;

@end
