//
//  TRParserXML.h
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <Foundation/Foundation.h>
//Le pedimos al compilador que confie en que la clase TRFeed existe sin tener que importarla
@class TRFeed;



//Hacemos que nuestro Parseador cumpla el protocolo NSXMLParserDelegate
@interface TRParserXML : NSOperation <NSXMLParserDelegate>

/**********VARIABLES O PROPIEDADES************/
//Referencia a los datos descargados
@property (strong) NSData *datos;
//Array donde guardaremos los feeds obtenidos del XML
@property (strong) NSMutableArray *listaFeedsXML;
//Variable para transformar el XML descargado en informacion util.
@property (strong) NSXMLParser *parser;
//Feed actual que estemos tratando
@property (strong) TRFeed *feedActual;
//Buffer para ir almacenando temporalmente las cadenas de caracteres que nos van llegando
@property (strong) NSMutableString *stringBuffer;
@property BOOL bandera;

/************MÉTODOS*********************/
//Metodo inicializador del Parseador
-(id)initConDatos:(NSData *)datos;
//Método para parsear la descripción
-(void)parseoDescripcion:(NSString *)string;
//Método para dar formato a la fecha
-(NSString *)DarFormatoFecha:(NSDate *)fecha;
//Método para obtener el tipo de incidencia
-(NSString *)ObtenerTipoIncidencia:(NSString *) urlString;

@end
