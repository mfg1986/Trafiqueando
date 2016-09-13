//
//  TRTarjetaMapaView.m
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRTarjetaMapaView.h"
#import "TRContentView.h"
#import "TRTarjetaMapa.h"

@implementation TRTarjetaMapaView

//Método de creación de la vistas de la tarjeta de detalle y del pin del mapa
- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
                
        if([reuseIdentifier isEqualToString:@"TarjetaMapa"]){//Si la vista que se va a crear es la de la tarjeta de detalle
            TRTarjetaMapa * anotacion=(TRTarjetaMapa *)annotation;
            
            //Le asociamos a la tarjeta el mapa y el pin que se pulso para ver la tarjeta
            self.pinPulsado=anotacion.pinpulsado;
            self.mapView=anotacion.mapView;
            
            //Creamos una vista de detalle
            self.contentAnotacionView=[[TRContentView alloc] init];
            //Asignamos todos los datos de la tarjeta
            [self.contentAnotacionView ColocarTitulo:anotacion.title SubTitulo:anotacion.subtitle yFecha:anotacion.fecha];
            //Colocamos la tarjeta sobre el pin
            [self colocarTarjeta];
            
        }else if([reuseIdentifier isEqualToString:@"PinMapa"]){//Si la vista que se va a crear es la del pin en el mapa
            self.backgroundColor = [UIColor clearColor];
            //Activamos el pin
            self.enabled = YES;
            //Deshabilitamos la tarjeta por defecto que se muestra al pulsar el pin
            self.canShowCallout=NO;
        }
    }
    return self;
}
//Método para colocar la tarjeta sobre el pin
-(void)colocarTarjeta{
    //Obtenemos la posicion del pin asociado a la tarjeta
    CGRect posicionPin=self.pinPulsado.frame;
    
    //Obtenemos la posicion en la que colocar la tarjeta de detalle respecto del pin
    CGFloat posicionX=posicionPin.origin.x-self.contentAnotacionView.frame.size.width/2+20;//situamos la tarjeta centrada respecto al pin
    CGFloat posicionY=posicionPin.origin.y-self.contentAnotacionView.frame.size.height-5;//encima del pin
    
    //Colocamos la tarjeta de detalle centrada sobre el pin
    self.contentAnotacionView.frame=CGRectMake(posicionX, posicionY, self.contentAnotacionView.frame.size.width, self.contentAnotacionView.frame.size.height);
    
    //Añdimos la vista de la tarjeta a la vista del mapa
    [self.mapView addSubview:self.contentAnotacionView];
    
   
}
//Método para eliminar la tarjeta de detalle del mapa
-(void)eliminarVista{
    for (UIView *subview in [self.mapView subviews]) {//Recorremos todas las subvistas
        if (subview == self.contentAnotacionView) {//Si es la correspondiente a la tarjeta de detalle
            [subview removeFromSuperview];//Eliminamos la vista
        }
    }
}

@end
