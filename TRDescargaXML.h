//
//  TRDescargaXML.h
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRParserXML.h"


@interface TRDescargaXML : NSObject <NSURLConnectionDataDelegate>//Hacemos que nuestra clase implemente el protocolo del delegado de conexion
/**********VARIABLES O PROPIEDADES******************/
//Propiedad en la que se iran guardando los datos descargados de la URL
@property (strong) NSMutableData *datosDescargados;
//Parseador que nos permitira procesar los datos descargador de la URL
@property (strong) TRParserXML *parseadorXML;

/****************MÉTODOS****************/
//Metodo para lanzar la descarga del XML con los feeds
-(void)descargaXMLFeeds;


@end
