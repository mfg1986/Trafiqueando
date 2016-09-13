//
//  TRParserXML.m
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRParserXML.h"
#import "TRFeed.h"

@implementation TRParserXML


//Inicializador del parseador
-(id)initConDatos:(NSData *)datos{
    if(self=[super init]){
        //Inicializamos los datos
        self.datos=datos;
        self.bandera=NO;
        
        //Creamos un parseador
        self.parser=[[NSXMLParser alloc]initWithData:datos];
        
        //Asignamos al parseador delegado del protocolo de parseo
        self.parser.delegate=self;
        
        //Configuramos el parseador
        self.parser.shouldProcessNamespaces=NO;
        self.parser.shouldReportNamespacePrefixes=NO;
        self.parser.shouldResolveExternalEntities=NO;
    }
    return self;
}

#pragma mark - Metodos del delegado de Parseo
//Método llamado cuando comienza el parseo
-(void)parserDidStartDocument:(NSXMLParser *) parser{
    
    if(self.listaFeedsXML!=nil){//Si la lista de Feeds ya estaba creada-->esto es debido a que estamos refrescando el contenido
        //Eliminamos todos los feeds que habia en la lista
        [self.listaFeedsXML removeAllObjects];
    }else{//Si es la primera vez que lanzamos el parseador creamos el array de feeds
        self.listaFeedsXML=[[NSMutableArray alloc] init];
    }
}

//Método llamado cuando se abre una etiqueta
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //Si el elemento encontrado es el comienzo de un feed de trafico 
    if (([elementName isEqualToString:@"item"])) {
        
        //Inicializamos el objeto feedActual
        self.feedActual=[[TRFeed alloc] init];
        //Activamos la bandera para indicar que estamos dentro de una etiqueta de  feed
        self.bandera=YES;
        
     //Si es el comienzo de un campo del feed como titulo,link,descripcion, fecha o coordenada
    }else if (([elementName isEqualToString:@"title"]|| [elementName isEqualToString:@"description"]||[elementName isEqualToString:@"link" ]||[elementName isEqualToString:@"georss:point"]||[elementName isEqualToString:@"dc:date"]) && (self.bandera==YES)){
                    
        //Inicializamos el buffer para empezar a grabar contenido en el
        self.stringBuffer=[[NSMutableString alloc]init];
        
    }else{//Si no es ningun campo que nos interese
        
        //Ponemos el buffer a nil
        self.stringBuffer=nil;
    }
    
}

//Método llamado cuando se encuentra una etiqueta de cierre
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
    if(([elementName isEqualToString:@"item"]) && (self.bandera==YES)){//Si el elemento que se cierra es un feed
        
        //Añadimos el feedActual al array de feeds
        [self.listaFeedsXML addObject:self.feedActual];
        //Desactivamos la bandera para indicar que estamos fuera de la etiqueta dela etiqueta del feed
        self.bandera=NO;
    
    }else if(([elementName isEqualToString:@"title"]) && (self.bandera==YES)){//Si el elemento que se cierra es el titulo del feed Actual
        
        //Obtenemos el titulo del buffer y lo guardamos
        self.feedActual.titulo=[self.stringBuffer description];
    
    }else if(([elementName isEqualToString:@"link"])&& (self.bandera==YES)){//Si el elemento que se cierra es el link del feed actual
       
        //Vamos a obtener el tipo de incidencia
        NSString *urlString=[self.stringBuffer description];
       //Guardamos el tipo de incidencia en el feed actual
        self.feedActual.tipo=[self ObtenerTipoIncidencia:urlString];
    
        //Creamos la URL a partir del contenido del buffer y lo añadimos al feed actual
        self.feedActual.link=[NSURL URLWithString:urlString];
    
    }else if(([elementName isEqualToString:@"description"])&& (self.bandera==YES)){//Si el elemento que se cierra es la descripcion del feed actual
        //Obtenemso la descripción del buffer
        NSString *descripcion=[self.stringBuffer description];
       
        if([descripcion length]>0){//Si hay descripción la parseamos
            [self parseoDescripcion:[self.stringBuffer description]];
        }else{//Si no hay descripción informamos de ello
            self.feedActual.desc= [[NSMutableString alloc] initWithString:@"Sin descripcion"];
        }
       
        
    }else if (([elementName isEqualToString:@"dc:date"])&& (self.bandera==YES)){
        
        
        //Obtenemos la fecha en formato string
        NSString *fechaString=[self.stringBuffer description];
       
        // Creamos un formateador
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        //En el formateador indicamos el formato que tiene la fecha recogida
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        //Obtenemos la zona horaria
        NSString *timeZoneName = [[NSTimeZone localTimeZone] name];
        
        //Añadimos la zona horaria al formateador
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
        
        //Obtenemos la fecha del NSString pasado como argumento con el formateador
        NSDate *fecha = [dateFormat dateFromString:fechaString] ;
    
        //Cambiamos el formato de la fecha obtenida  y lo guardamos
        self.feedActual.fecha=[self DarFormatoFecha:fecha];
    
    }else if (([elementName isEqualToString:@"georss:point"])&& (self.bandera==YES)){
        
        //Obtnemos el contenido del buffer
        NSString *coordenadasString =[self.stringBuffer description];
        
        //Separamos en un array la latitud y la longitud
        NSArray *componentes = [[coordenadasString componentsSeparatedByString:@" "] mutableCopy];
        
        //Convertimos la latitud y la longitud en FLoats
        NSString *latitudString=componentes[0];
        NSString *longitudString=componentes[1];

        CGFloat latitud=(CGFloat)[latitudString floatValue];
        CGFloat longitud=(CGFloat)[longitudString floatValue];
        //Guardamos los valores en el feed actual
        self.feedActual.latitud=latitud;
        self.feedActual.longitud=longitud;
        
                
    }
   
    
}

//Método que nos informa de un fallo en el parseo
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    //Creamos una notificacion con la lista de feeds descargados
    NSNotification *notificacion=[NSNotification notificationWithName:@"ErrorParseo" object:parseError.description];
    //Obtenemos una referencia al centro de notificaciones
    NSNotificationCenter *centro=[NSNotificationCenter defaultCenter];
    //Pedimos al centro de notificaciones que publique la notificacion
    [centro postNotification:notificacion];
 
    
}

//Método que se llama cuando encontramos contenido dentro de una etiqueta-->Este metodo es llamado repetidas veces
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{   
    
    //Almacenamos el contenido en el buffer
    [self.stringBuffer appendString:string];
  
}

//Metodo que se llama al terminar de parsear el documento
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
    //Creamos una notificacion con la lista de feeds descargados
    NSNotification *notificacion=[NSNotification notificationWithName:@"ListaFeedDescargada" object:self.listaFeedsXML];
    //Obtenemos una referencia al centro de notificaciones
    NSNotificationCenter *centro=[NSNotificationCenter defaultCenter];
    //Pedimos al centro de notificaciones que publique la notificacion
    [centro postNotification:notificacion];
  
}


#pragma mark - Métodos para parsear la descripción
//Método para parsear y guardar la descripción en el feed actual
-(void)parseoDescripcion:(NSString *)string{
  
    //Recorremos la descripción y eliminamos cualquier etiqueta que quede
    NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    }
    
    //Sustituimos las caracteres especiales de las vocales con acento por vocales con acento
    string  = [string stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
    string  = [string stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
    string  = [string stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
    string  = [string stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
    string  = [string stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
    
    //Eliminamos los caracteres especiales del espacio en blanco
    string  = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    //Añadimos un salto de renglón con el incio de un nuevo subtitulo
    string  = [string stringByReplacingOccurrencesOfString:@"Tramo comprendido" withString:@"\nTramo comprendido:"];
    string  = [string stringByReplacingOccurrencesOfString:@"Desvío" withString:@"\nDesvío:"];
    string  = [string stringByReplacingOccurrencesOfString:@"Finalización Sin determinar" withString:@"\nFinalización:  Ver en la web oficial."];
    string  = [string stringByReplacingOccurrencesOfString:@"Observaciones" withString:@"\nObservaciones:"];
    
    //Añadimos un salto de renglón al final de la descripción
    string=[string stringByAppendingString:@"\n"];
    NSMutableString *stringSinFormato=[[NSMutableString alloc] initWithString:string];

    
    //Guardamos la descripción en el feed actual
    self.feedActual.desc=stringSinFormato;
    
    
}


#pragma mark - Método para Obtener el tipo del feed
-(NSString *)ObtenerTipoIncidencia:(NSString *) urlString{
    //Buscamos en que posicion de la url se encuentra el identificador de incidencia
    NSRange posicion = [urlString rangeOfString: @"id="];
    
    //Obtenemos la subcadena que indica el tipo
    NSString *tipoString = [urlString substringWithRange: NSMakeRange (posicion.location+3, posicion.length-2)];
    
    //Convertimos la subcadena en entero
    int tipo=[tipoString intValue];
    NSString *tipoIncidencia=[[NSString alloc] init];
    
    //En funcion del dicho entero será un tipo u otro de incidencia
    switch (tipo) {
            
        case 0:
            return tipoIncidencia=@"Corte de agua";
        case 1:
            return tipoIncidencia=@"Corte de tráfico";
        case 2:
            return tipoIncidencia=@"Afección importante";
        case 4:
            return tipoIncidencia=@"Afección importante de tranvía";
        case 5:
            return tipoIncidencia=@"Afección al transporte público";
            
        default:
            return tipoIncidencia=@"Otros";
    }
}


#pragma mark - Método para formatear la fecha
//Método para dar formato a la fecha
-(NSString *)DarFormatoFecha:(NSDate *)fecha{
    
    // Creamos un formateador
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    //En el formateador indicamos el formato que queramos que tiene la fecha recogida
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    //Obtenemos la zona horaria
    NSString *timeZoneName = [[NSTimeZone localTimeZone] name];
    
    //Añadimos la zona horaria al formateador
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
    
    //Obtenemos la fecha del NSString pasado como argumento
    NSString *fechaString= [dateFormat stringFromDate:fecha] ;
    NSString *anyo=[fechaString substringWithRange:NSMakeRange(0, 4)];
    NSString *mes=[fechaString substringWithRange:NSMakeRange(5, 2)];
    NSString *dia=[fechaString substringWithRange:NSMakeRange(8, 2)];
    NSString *hora=[fechaString substringWithRange:NSMakeRange(11, 8)];
    
    //Creamos una cadena de texto con la fecha y hora en el formato deseado
    NSString *dte=[NSString stringWithFormat:@"%@/%@/%@  %@",dia,mes,anyo,hora];
    
    return dte;
    
}

@end
