
//  TRDescargaXML.m
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRDescargaXML.h"

@implementation TRDescargaXML


//Método que arranca la descarga
-(void)descargaXMLFeeds{
    
    //Creamos la URL de donde se va a realizar la descarga de todas las incidencias
    NSURL* url=[NSURL URLWithString:@"http://www.zaragoza.es/georss/feed?id=3&srsname=wgs84"];
    //Construimos una peticion
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    //Creamos y lanzamos la conexion a la URL-->Nos hacemos delegados de conexion
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //Comenzamos la descarga
    [connection start];
    
}


#pragma mark - Métodos del delegado de conexión
//Se establecio la conexion y estamos a punto de recibir datos
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    //Activamos el indicador de actividad de red en la barra de estado
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Inicializamos el contenedor de los datos
    self.datosDescargados=[[NSMutableData alloc]init];
}

//Hemos recibido parte de los datos en formato binario NSData-->este metodo sera llamado varias veces
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    //Añadimos los datos a los datos recibidos
    [self.datosDescargados appendData:data];
}

//Se ha producido un error en la conexión y debemos limpiar los recursos
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    
    //Creamos una notificacion con la lista de feeds descargados
    NSNotification *notificacion=[NSNotification notificationWithName:@"ErrorDescarga" object:error.description];
    //Obtenemos una referencia al centro de notificaciones
    NSNotificationCenter *centro=[NSNotificationCenter defaultCenter];
    //Pedimos al centro de notificaciones que publique la notificacion
    [centro postNotification:notificacion];
    
    
    //Desactivamos el indicador de red
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    }

//Finaliza la descarga-->Aqui llamaremos al parseador para que procese los datos
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //Desactivamos el indicador de actividad de red
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    //Si tenemos datos descargados
    if([self.datosDescargados length]>0){
        
            //Establecemos la codificacion de los datos descargados para que al parsear se reconozcan los caracteres especiales
            NSString *datosString=[[NSString alloc] initWithData:self.datosDescargados encoding:NSUTF8StringEncoding];
            NSData *datos=[datosString dataUsingEncoding:NSUTF8StringEncoding];
            //Inicializamos el parseador
            self.parseadorXML=[[TRParserXML alloc] initConDatos:datos];
            //Ejecutamos el parseador
            [self.parseadorXML.parser parse];
        
            //cerramos la conexion
            [connection cancel];
        
           
    }    
    
}

@end
