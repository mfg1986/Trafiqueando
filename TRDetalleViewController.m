//
//  TRDetalleViewController.m
//  Trafiqueando
//
//  Created by maria on 11/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRDetalleViewController.h"

#import "TRFeed.h"
#import "TRTarjetaMapa.h"
#import "TRPinMapa.h"
#import "TRTarjetaMapaView.h"
#import "TRWebViewController.h"


@implementation TRDetalleViewController 
@synthesize pinMapa;
@synthesize mapaDetalle;
@synthesize selectedPin;
@synthesize tarjetaMapa;


- (void)viewDidLoad{
    [super viewDidLoad];
  
    //Establecemos el estilo del boton de volver para cuando mostramos para cuando pulsamos el boton del link
   UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnVolver"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem=backBtn;

   /*****************Colocamos el TIPO**************/
    //Ponemos la imagen correspondiente
    self.tipo.image=[UIImage imageNamed:[self seleccionImagen:self.feed.tipo seccion:@"tipo"]];
    //Guardamos el frame del tipo
    self.frameTipo=self.tipo.frame;
    
    /***************Colocamos el ICONO************/
    //Colocamos la imagen correspondiente
    self.iconoTipo.image=[UIImage imageNamed:[self seleccionImagen:self.feed.tipo seccion:@"icono"]];
    //Guardamos el frame del icono
    self.frameIconoTipo=self.iconoTipo.frame;
    
    /*********Colocamos el TITULO***************/
    
    
    //Obtenemos el titulo y ponemos las primeras letras en mayúsculas
    self.feed.titulo= [self.feed.titulo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *tituloStr = [self.feed.titulo capitalizedString];
    NSAttributedString *titulo=[[NSAttributedString alloc] initWithString:tituloStr];
    
    //Obtenemos rectangulo que ocupara nuestro texto
    CGRect rectTitulo = [titulo boundingRectWithSize:(CGSize){self.tituloDetalle.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //Obtenemos las dimensiones
    CGSize size = rectTitulo.size;
    //Redimensionamos la etiqueta
    self.tituloDetalle.frame=CGRectMake(self.tituloDetalle.frame.origin.x, self.tituloDetalle.frame.origin.y, self.tituloDetalle.frame.size.width, size.height);
    //Para soportar multilineas
    self.tituloDetalle.numberOfLines=0;
 
    //Colocamos el texto
    self.tituloDetalle.text=tituloStr;
    //Guardamos los frames del titulo y su etiqueta
    self.frameTituloDetalle=self.tituloDetalle.frame;
    self.frameLugarLabel=self.lugarLabel.frame;
    
   
    CGFloat posYdescripcion;
    //En el caso de que el titulo de la incidencia ocupe en vertical mas que el tamaño del icono recolocamos los frames de la fecha y la descripcion
    CGFloat espacioTitulo=self.iconoTipo.frame.size.height-self.fechaDetalle.frame.size.height;
    if(self.tituloDetalle.frame.size.height>espacioTitulo){
        
     /*************Recolocamos la FECHA******************************/
        //Obtenemos la posicion relativa al titulo
        CGFloat posYfechaLabel=self.tituloDetalle.frame.origin.y+self.tituloDetalle.frame.size.height+5;
        CGFloat posXfechaLabel=self.fechaLabel.frame.origin.x;

        //Recolocamos la fecha y su etiqueta
        self.fechaLabel.frame=CGRectMake(posXfechaLabel, posYfechaLabel, self.fechaLabel.frame.size.width, self.fechaLabel.frame.size.height);
        self.fechaDetalle.frame=CGRectMake(self.fechaDetalle.frame.origin.x, posYfechaLabel-5, self.fechaDetalle.frame.size.width, self.fechaDetalle.frame.size.height);
    
     
    /************ Recolocamos la DESCRIPCIÓN  **********************************/
       //Obtenemos la posicion relativa a la fecha del la etiqueta del campo descripción
        CGFloat posYdescripcionLabel=posYfechaLabel+self.fechaLabel.frame.size.height+5;
        CGFloat posXdescripcionLabel=self.descripcionLabel.frame.origin.x;
        //Recolocamos la etiqueta
        self.descripcionLabel.frame=CGRectMake(posXdescripcionLabel, posYdescripcionLabel, self.descripcionLabel.frame.size.width, self.descripcionLabel.frame.size.height);
        //Creamos la posicion vertical en la que deberia ir el campo descripcion
        posYdescripcion=posYdescripcionLabel+self.descripcionLabel.frame.size.height+5;
 
    }else{//En caso de que el titulo la incidencia no ocupe más que el tamaño del icono
        //La posicion vertical del campo descripcion sera la inicial
        posYdescripcion=94;
    }
    
    /************Ponemos la FECHA***************/
    self.fechaDetalle.text=self.feed.fecha;
    //Guardamos los frames de la fecha y su titulo
    self.frameFechaLabel=self.fechaLabel.frame;
    self.frameFechaDetalle=self.fechaDetalle.frame;
    
    /*********Ponemos la DESCRIPCION**************/
    //Obtenemos el texto a colocar en la label
    NSString *descripcion =[NSString stringWithFormat:@"%@",self.feed.desc];
    //Llamamos al metodo que calcula el espacio que necesario para el texto, redimensiona la etiqueta y coloca el texto en ella
    [self ponerTextoLabel:self.descripcionDetalle conTexto:descripcion anchoLabel:300 fuente:[UIFont fontWithName:@"Forte" size:12] posX:10 posY:posYdescripcion];
     //Guardamos el frame de la label descripcion
     self.frameDescripcionLabel=self.descripcionLabel.frame;
     self.frameDescripcionDetalle=self.descripcionDetalle.frame;
    
     //Posicion final del campo descripcion en el eje Y
    CGFloat posFinalDescripcion=self.descripcionDetalle.frame.origin.y+self.descripcionDetalle.frame.size.height;
    
  
    /***************  Colocamos ICONO DE LATITUD Y LONGITUD ***************************/
    //Obtenenos la posicion vertical del icono relativa a la descripción
    CGFloat posYiconoCoord=posFinalDescripcion+10;
    //Creamos el nuevo frame con dicha posición
    self.iconoCoordenadas.frame=CGRectMake(self.iconoCoordenadas.frame.origin.x, posYiconoCoord, self.iconoCoordenadas.frame.size.width, self.iconoCoordenadas.frame.size.height);
    //Guardamos el frame del icono de latitud y longitud
    self.frameIconoCoordenadas=self.iconoCoordenadas.frame;
  
    
    /**************Colocamos los VALORES DE LATITUD Y LONGITUD********************/
    //Obtenemos la posición de la latitud  relativa a la descripción
    CGFloat posYlatitud=posFinalDescripcion+6;
    //Creamos el nuevo frame con dicha posición
    self.latitud.frame=CGRectMake(self.latitud.frame.origin.x,posYlatitud,self.latitud.frame.size.width,self.latitud.frame.size.height);
    //Ponemos el valor de la latitud
    self.latitud.text=[NSString stringWithFormat:@"%f",self.feed.latitud];
    //Guardamos el frame de la latitud
    self.frameLatitud=self.latitud.frame;

    
   //Obtenemos la posición de la longitud relativa a la latitud
    CGFloat posYlongitud=posYlatitud+18;
    //Creamos el nuevo frame con dicha posicion
    self.longitud.frame=CGRectMake(self.longitud.frame.origin.x, posYlongitud, self.longitud.frame.size.width, self.longitud.frame.size.height);
    //Ponemos el valor de la longitud
    self.longitud.text=[NSString stringWithFormat:@"%f",self.feed.longitud];
    //Guardamos el frame de la longitud
    self.frameLongitud=self.longitud.frame;
  
 /***************  Colocamos el BOTÓN DEL LINK ***************************/
    //Obtenemos la posicion del botón de link relativa al final de la descripcion
    CGFloat posYbtnLink=posFinalDescripcion+10;
    CGFloat posXbtnLink=self.descripcionDetalle.frame.size.width-self.btnLink.frame.size.width+10;
    //Creamos el nuevo frame con dicha posición
    self.btnLink.frame=CGRectMake(posXbtnLink, posYbtnLink, self.btnLink.frame.size.width, self.btnLink.frame.size.height);
    //Guardamos el frame del botón de link
    self.frameBtnLink=self.btnLink.frame;
    
    
    /*****Colocamos el TITULO DE LOCALIZACIÓN*******************/
    //Obtenemos la posición del titulo de localización relativa a la latitud
    CGFloat posYtituloLocalizacion=posYlatitud+40;
    //Creamos el nuevo frame con dicha posición
    self.tituloLocalizacion.frame=CGRectMake(0, posYtituloLocalizacion,self.tituloLocalizacion.frame
                                             .size.width, self.tituloLocalizacion.frame.size.height);
    //Guardamos el frame del titulo de localización
    self.frameLocalizacion=self.tituloLocalizacion.frame;
    
    /**************Colocamos el BOTÓN DE CENTRAR**************/
    //Ponemos la imagen del botón de centrar
    self.btnCentrar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnCentrar"]];
    //Obtenemos la posición del botón de centrar para que quede al pie del mapa
    CGFloat posYbtnCentrar=posYlatitud+self.tituloLocalizacion.frame.size.height+40+self.mapaDetalle.frame.size.height-self.btnCentrar.frame.size.height-4;
    //Creamos el nuevo frame con dicha posición
    self.btnCentrar.frame=CGRectMake(self.btnCentrar.frame.origin.x, posYbtnCentrar, self.btnCentrar.frame.size.width, self.btnCentrar.frame.size.height);
    //Guardamos el frame del boton de centrar
    self.frameBtnCentrarMapa=self.btnCentrar.frame;


    /**************Colocamos el BOTÓN DE PANTALLA COMPLETA**************/
    //Ponemos la imagen del botón de pantalla completa
    self.btnPantallaCompleta.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnPantallaCompleta"]];
    //Obtenemos la posición del botón de pantalla completa para que quede al pie del mapa
    CGFloat posYbtnPantallaCompleta=posYlatitud+self.tituloLocalizacion.frame.size.height+40+self.mapaDetalle.frame.size.height-self.btnPantallaCompleta.frame.size.height-4;
    //Creamos el nuevo frame con dicha posición
    self.btnPantallaCompleta.frame=CGRectMake(self.btnPantallaCompleta.frame.origin.x, posYbtnPantallaCompleta, self.btnPantallaCompleta.frame.size.width, self.btnPantallaCompleta.frame.size.height);
    //Guardamos el frame del botón de pantalla completa
    self.frameBtnPantallaCompleta=self.btnPantallaCompleta.frame;
    
     /***************  Colocamos el MAPA  ***************************/
    //Hacemos al controlador delegado del Mapa
    [self.mapaDetalle setDelegate:self];
     //Obtenemos la posición del mapa relativa al titulo de localización
    CGFloat posYmapa=posYtituloLocalizacion+self.tituloLocalizacion.frame.size.height;
    //Creamos el nuevo frame a partir de dicha posición
    self.mapaDetalle.frame=CGRectMake(0, posYmapa, self.mapaDetalle.frame.size.width, self.mapaDetalle.frame.size.height);
   //Guardamos el frame del mapa para poder volver a ponerlo en su sitio si lo movemos
    self.frameMapa=self.mapaDetalle.frame;
    //Centramos el mapa en la coordenada de la incidencia
    CLLocationCoordinate2D coordenada;
    coordenada.latitude=self.feed.latitud;
    coordenada.longitude=self.feed.longitud;
    
    //LLamamos al método que centra el mapa en la coordenada de indicencia
    [self centrarMapaEnPosicion];
    

    //Creamos un pin personalizado
    self.pinMapa=[[TRPinMapa alloc] initWithTitle:self.feed.titulo subtitle:self.feed.tipo Type:self.feed.tipo andCoordinate:coordenada];
  
    //Colocamos el pin en el mapa
    [self.mapaDetalle addAnnotation:self.pinMapa];
    

    /************Colocamos la IMAGEN DE PIE***********************/
    //Obtenemos la posición de la imagen relativa al mapa
    CGFloat posYpie=posYmapa+self.mapaDetalle.frame.size.height;
    //Creamos el nuevo frame con dicha posición
    self.imagenPie.frame=CGRectMake(0, posYpie, self.imagenPie.frame.size.width, self.imagenPie.frame.size.height);
    //Ponemos la imagen correspondiente
    self.frameImagenPie=self.imagenPie.frame;
    
    //Reajustamos el frame de la vista contenedora
    //Calculamos el tamaño total que ocuparán todos los elementos
    CGFloat alturaTotal=posYpie+self.imagenPie.frame.size.height;
    //Creamos el nuevo frame con dicho tamaño
    CGRect frameTotal=self.contentView.frame;
    frameTotal.size.height=alturaTotal;
    //Asignamos edicho frame a la vista contenedora
    self.contentView.frame=frameTotal;
    
  }
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Método necesario para que funcione el ScrollView
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize=self.contentView.bounds.size;
}

#pragma mark - Método de selección de imagen
//Método para seleccionar imagen en función del tipo y la sección
-(NSString *)seleccionImagen:(NSString *)tipo seccion:(NSString *)seccion{
    NSString *imagen;
    if ([seccion isEqualToString:@"tipo"]) {
        
        if ([tipo isEqualToString:@"Corte de tráfico"]) {
            imagen=@"CTtipo";
        }else if([tipo isEqualToString:@"Corte de agua"]){
            imagen=@"CAtipo";
        }else if([tipo isEqualToString:@"Afección al transporte público"]){
            imagen=@"ATPtipo";
        }else if ([tipo isEqualToString:@"Afección importante"]){
            imagen=@"AItipo";
        }else if ([tipo isEqualToString:@"Afección importante de tranvía"]){
            imagen=@"AITtipo";
        }
    }else if ([seccion isEqualToString:@"icono"]){
       
        if ([tipo isEqualToString:@"Corte de tráfico"]) {
               imagen=@"CT";
        }else if([tipo isEqualToString:@"Corte de agua"]){
            imagen=@"CA";
        }else if([tipo isEqualToString:@"Afección al transporte público"]){
            imagen=@"ATP";
        }else if ([tipo isEqualToString:@"Afección importante"]){
            imagen=@"AI";
        }else if ([tipo isEqualToString:@"Afección importante de tranvía"]){
            imagen=@"AIT";
        }

    }else if ([seccion isEqualToString:@"pin"]){
        
        if ([tipo isEqualToString:@"Corte de tráfico"]) {
            imagen=@"CTpin";
        }else if([tipo isEqualToString:@"Corte de agua"]){
            imagen=@"CApin";
        }else if([tipo isEqualToString:@"Afección al transporte público"]){
            imagen=@"ATPpin";
        }else if ([tipo isEqualToString:@"Afección importante"]){
            imagen=@"AIpin";
        }else if ([tipo isEqualToString:@"Afección importante de tranvía"]){
            imagen=@"AITpin";
        }
        
    }

    
    return imagen;
}

#pragma mark - Método asociado a la etiqueta de descripción
//Metodo que ajusta de forma dinámica el texto de la descripcion a la etiqueta dandole estilo
-(void)ponerTextoLabel:(UILabel *)label conTexto:(NSString *)text anchoLabel:(CGFloat) width fuente:(UIFont *) font posX:(CGFloat) posicionx posY:(CGFloat)posiciony{
    
    //Definimos el estilo de parrafo
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    //Indicamos la justificacion de inicion de parrafo
    style.firstLineHeadIndent = 10.0f;
    //Padding izquierdo del resto del parrafo
    style.headIndent = 10.0f;
    //Padding derecho del parrafo
    style.tailIndent = -10.0f;
    
    //Dicionario con los atributos del texto
    NSDictionary *atributos=@{NSFontAttributeName: font,NSParagraphStyleAttributeName : style};
    
    //Creamos un texto con atributos
    NSMutableAttributedString *attributedText =[[NSMutableAttributedString alloc] initWithString:text attributes:atributos];
    
    //Localizamos los titulos en el texto de la descripcion
    NSRange tramo=[text rangeOfString:@"Tramo comprendido:"];
    NSRange desvio=[text rangeOfString:@"Desvío:"];
    NSRange finalizacion=[text rangeOfString:@"Finalización:"];
    NSRange observaciones=[text rangeOfString:@"Observaciones:"];
    
    //Ponemos color a los titulos
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(tramo.location, tramo.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(desvio.location, desvio.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(finalizacion.location, finalizacion.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(observaciones.location, observaciones.length)];
    
    
    //Obtenemos rectangulo que ocupara nuestro texto
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //Obtenemos las dimensiones
    CGSize size = rect.size;
    //Redimensionamos la etiqueta
    label.frame=CGRectMake(posicionx, posiciony, width, size.height);
    //Para soportar multilineas
    label.numberOfLines=0;
    
    //Colocamos el texto
    label.attributedText=attributedText;
    
}

#pragma mark - Metodos para gestionar el mapa
//Metodo llamado cuando seleccionamos el pin
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (view.annotation == self.pinMapa) {//Si hemos seleccionado un pin del mapa
        //Obtenemos la coordenada del pin
        CLLocationCoordinate2D coord;
        coord.latitude=view.annotation.coordinate.latitude;
        coord.longitude=view.annotation.coordinate.longitude;
        
        if (self.tarjetaMapa == nil) {//Si no hay creada una tarjeta de detalle
            //Creamos la tarjeta con la latitud y la longitud
            
            self.tarjetaMapa = [[TRTarjetaMapa alloc] initConCoordenada:coord];
            
        } else {//Si la tarjeta ya estaba creada
            
            self.tarjetaMapa.coordinate=coord;
        }
        //Asociamos el pin a la tarjeta de detalle
        self.tarjetaMapa.pinpulsado=view;
        //Añadimos la tarjeta al mapa
        [self.mapaDetalle addAnnotation:self.tarjetaMapa];
        //Guardamos el pin seleccionado
        self.selectedPin = view;
        //Activamos el estado de pulsado del pin
        self.pinMapa.pinPulsado=YES;
        
    }
}
//Método que escondera la tarjeta
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //Si existe una tarjeta de detalle y el pin pulsado coincide con el pin activado
    if (self.tarjetaMapa && view ==self.selectedPin ) {
        //Eliminamos la anotacion del mapa
        [self.mapaDetalle removeAnnotation: self.tarjetaMapa];
        //Eliminamos la vista de la anotacion del mapa
        [self.tarjetaMapa.tarjetaView eliminarVista];
        //Desactivamos el pin
        self.pinMapa.pinPulsado=NO;
    }
    
}
//Método para añadir los pines al mapa y las tarjetas de detalle
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == self.tarjetaMapa) {//Si la vista que se esta creando es de tipo tarjeta
        //Rellenamos los datos que mostrara la tarjeta
        TRTarjetaMapa *tarjeta=(TRTarjetaMapa *)annotation;
        //En el titulo pondremos el tipo de incidencia
        tarjeta.title=self.feed.tipo;
        //En el subtitulo ponemos el lugar de la incidencia
        tarjetaMapa.subtitle=self.feed.titulo;
        //Tambien indicamos la fecha
        tarjetaMapa.fecha=self.feed.fecha;
        //Guardamos una referencia al mapa
        tarjeta.mapView=self.mapaDetalle;
        //Indicamos el pin al que vinculamos la tarjeta de detalle
        tarjeta.pinpulsado=self.selectedPin;
        
        //Desencolamos una vista de tarjeta
        TRTarjetaMapaView *tarjetaMapaView = (TRTarjetaMapaView *)[self.mapaDetalle dequeueReusableAnnotationViewWithIdentifier:@"TarjetaMapa"];
        
        //Inicializamos la vista de tarjeta con los datos
        tarjetaMapaView = [[TRTarjetaMapaView alloc] initWithAnnotation:tarjeta reuseIdentifier:@"TarjetaMapa"];
        
        //Asignamos a la anotacion la vista que acabamos de inicializar
        tarjeta.tarjetaView=tarjetaMapaView;
        //Guardamos la anotación correspondiente a la tarjeta
        self.tarjetaMapa=tarjeta;
        
        //Devolvemos la tarjeta de detalle creada asociada al pin pulsado
        return tarjetaMapaView;
        
    } else if (annotation == self.pinMapa) {//Cuando añadimos un pin al mapa
        
        
        //Convertimos nuestra anotacion en una personalizada
        TRPinMapa *pin=(TRPinMapa *)annotation;
        
        //Creamos una vista de esta anotacion
        MKAnnotationView *pinMapaView=[[MKAnnotationView alloc] initWithAnnotation:pin reuseIdentifier:@"PinMapa"];
        
        
        
        //Configuramos la vista del pin en el mapa
        pinMapaView.canShowCallout=NO;//Desactivamos la tarjeta de detalle que lleva asociada por defecto
        pinMapaView.enabled=YES;//Permitimos la interaccion con el usuario para que se puedad pulsar el pin
        pinMapaView.centerOffset=CGPointMake(0, 0);//Lo centramos
        pinMapaView.draggable=NO;//No permitimos que pueda ser arrastrado
        
        
        //Creamos el pin que se visualizará en el mapa con nuestra imagen
        UIImage *imagen=[UIImage imageNamed:[self seleccionImagen:pin.type seccion:@"pin"]];
        pinMapaView.image=imagen;
        
        //Devolvemos el pin creado
        return pinMapaView;
        
    }
    return nil;
}
//Método que se llama antes de cambiar la region visualizada en el mapa
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //Llamamos al método encargado de deseleccionar el pin y ocultar la tarjeta de detalle
    [self deseleccionarPin];
    
}

//Método que se llama para deseleccionar el pin y ocultar la tarjeta de detalle
-(void)deseleccionarPin{
    //Si hay pin en el mapa
    if (self.pinMapa!=nil) {
        //Si el pin que hay fue pulsado y por lo tanto muestra la tarjeta de detalle
        if(self.pinMapa.pinPulsado==YES ){
            //Deseleccionamos el pin
            [self.mapaDetalle deselectAnnotation:self.pinMapa animated:YES];
            self.pinMapa.pinPulsado=NO;
            //Eliminamos la vista de la anotacion del mapa
            [self.tarjetaMapa.tarjetaView eliminarVista];
        }
    }
    
}

#pragma mark - Métodos para entrar/salir del modo pantalla completa
- (IBAction)mapaPantallaCompleta:(id)sender {
    
    //Obtenemos el frame de la pantalla
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGPoint screenOrigin=screenBound.origin;
    
    //Desplazamos a la izquierda los campos que no deseamos visualizar en pantalla completa mediante una animacion
    [UIView animateWithDuration:0.5 animations:^{
        self.lugarLabel.frame=CGRectMake(self.lugarLabel.frame.origin.x+screenSize.width, self.lugarLabel.frame.origin.y,self.lugarLabel.frame.size.width, self.lugarLabel.frame.size.height);
        self.tituloDetalle.frame=CGRectMake(self.tituloDetalle.frame.origin.x+screenSize.width, self.tituloDetalle.frame.origin.y,self.tituloDetalle.frame.size.width, self.tituloDetalle.frame.size.height);
        self.descripcionLabel.frame=CGRectMake(self.descripcionLabel.frame.origin.x+screenSize.width, self.descripcionLabel.frame.origin.y,self.descripcionLabel.frame.size.width, self.descripcionLabel.frame.size.height);
        self.descripcionDetalle.frame=CGRectMake(self.descripcionDetalle.frame.origin.x+screenSize.width, self.descripcionDetalle.frame.origin.y,self.descripcionDetalle.frame.size.width, self.descripcionDetalle.frame.size.height);
         self.fechaLabel.frame=CGRectMake(self.fechaLabel.frame.origin.x+screenSize.width, self.fechaLabel.frame.origin.y,self.fechaLabel.frame.size.width, self.fechaLabel.frame.size.height);
         self.fechaDetalle.frame=CGRectMake(self.fechaDetalle.frame.origin.x+screenSize.width, self.fechaDetalle.frame.origin.y,self.fechaDetalle.frame.size.width, self.fechaDetalle.frame.size.height);
         self.iconoCoordenadas.frame=CGRectMake(self.iconoCoordenadas.frame.origin.x+screenSize.width, self.iconoCoordenadas.frame.origin.y,self.iconoCoordenadas.frame.size.width, self.iconoCoordenadas.frame.size.height);
         self.latitud.frame=CGRectMake(self.latitud.frame.origin.x+screenSize.width, self.latitud.frame.origin.y,self.latitud.frame.size.width, self.latitud.frame.size.height);
         self.longitud.frame=CGRectMake(self.longitud.frame.origin.x+screenSize.width, self.longitud.frame.origin.y,self.longitud.frame.size.width, self.longitud.frame.size.height);
         self.tipo.frame=CGRectMake(self.tipo.frame.origin.x+screenSize.width, self.tipo.frame.origin.y,self.tipo.frame.size.width, self.tipo.frame.size.height);
        self.btnLink.frame=CGRectMake(self.btnLink.frame.origin.x+screenSize.width, self.btnLink.frame.origin.y,self.btnLink.frame.size.width, self.btnLink.frame.size.height);
         self.iconoTipo.frame=CGRectMake(self.iconoTipo.frame.origin.x+screenSize.width, self.iconoTipo.frame.origin.y,self.iconoTipo.frame.size.width, self.iconoTipo.frame.size.height);
         self.imagenPie.frame=CGRectMake(self.imagenPie.frame.origin.x+screenSize.width, self.imagenPie.frame.origin.y,self.imagenPie.frame.size.width, self.imagenPie.frame.size.height);
        
    }];

    //Ajustamos el contenido del Scroll para que el titulo de Localizacion no nos quede fuera de visión si realizamos un scroll antes de pasar a pantalla completa
    self.scrollView.contentOffset = CGPointMake(0,0);
    
    //Ajustamos los frames del mapa, el titulo y los botones para mostrarlos en pantalla completa
    [UIView animateWithDuration:0.5 animations:^{
        self.tituloLocalizacion.frame=CGRectMake(screenOrigin.x,screenOrigin.y+7, self.tituloLocalizacion.frame.size.width, self.tituloLocalizacion.frame.size.height);
        self.btnPantallaCompleta.frame=CGRectMake(self.btnPantallaCompleta.frame.origin.x,screenSize.height-4-self.btnPantallaCompleta.frame.size.height-64, self.btnPantallaCompleta.frame.size.width, self.btnPantallaCompleta.frame.size.height);
         self.btnCentrar.frame=CGRectMake(self.btnCentrar.frame.origin.x,screenSize.height-4-self.btnCentrar.frame.size.height-64, self.btnCentrar.frame.size.width, self.btnCentrar.frame.size.height);
        self.mapaDetalle.frame = CGRectMake(screenOrigin.x,self.tituloLocalizacion.frame.size.height, screenSize.width, screenSize.height-self.tituloLocalizacion.frame.size.height); }];
    
    //Cambiamos el boton para poder salir de la pantalla completa
    [self botonVistasOcultas:YES];
    
    //Si la tarjeta de detalle se esta mostrando porque pulsamos el pin
    if(self.pinMapa.pinPulsado==YES){
        //Deseleccionamos el pin y cambiamos su estado a inactivo
        [self.mapaDetalle deselectAnnotation:self.pinMapa animated:YES];
        self.pinMapa.pinPulsado=NO;

        //Eliminamos la vista de la anotacion del mapa
        [self.tarjetaMapa.tarjetaView eliminarVista];
    }
    //Centramos el mapa en el pin
    [self centrarMapaEnPosicion];
    //Desactivamos el scroll
    self.scrollView.scrollEnabled=NO;
    
    
}
- (IBAction)quitarMapaPantallaCompleta:(id)sender {
    
        //Retornamos todo a su lugar inicial
       [UIView animateWithDuration:0.5 animations:^{
           self.lugarLabel.frame=self.frameLugarLabel;
           self.tituloDetalle.frame=self.frameTituloDetalle;
           self.tipo.frame=self.frameTipo;
           self.iconoTipo.frame=self.frameIconoTipo;
           self.fechaLabel.frame=self.frameFechaLabel;
           self.fechaDetalle.frame=self.frameFechaDetalle;
           self.descripcionLabel.frame=self.frameDescripcionLabel;
           self.descripcionDetalle.frame=self.frameDescripcionDetalle;
           self.iconoCoordenadas.frame=self.frameIconoCoordenadas;
           self.latitud.frame=self.frameLatitud;
           self.longitud.frame=self.frameLongitud;
           self.btnLink.frame=self.frameBtnLink;
           self.imagenPie.frame=self.frameImagenPie;
           self.tituloLocalizacion.frame=self.frameLocalizacion;
           self.btnPantallaCompleta.frame=self.frameBtnPantallaCompleta;
           self.btnCentrar.frame=self.frameBtnCentrarMapa;
           self.mapaDetalle.frame = self.frameMapa;
           
          
       }];
    //Cambiamos el boton para poder volver a pasar a pantalla completa
     [self botonVistasOcultas:NO];
    //Si la tarjeta de detalle del pin se esta mostrando porque pulsamos el pin
    if(self.pinMapa.pinPulsado==YES){
        //Deseleccionamos el pin y cambiamos su estado a inactivo
        [self.mapaDetalle deselectAnnotation:self.pinMapa animated:YES];
        self.pinMapa.pinPulsado=NO;
        
        //Eliminamos la vista de la anotacion del mapa
        [self.tarjetaMapa.tarjetaView eliminarVista];
    }
    //Centramos el mapa en el pin
    [self centrarMapaEnPosicion];
    //Volvemos a activar el scroll
    self.scrollView.scrollEnabled=YES;
   
}
//Método encargado de cambiar el aspecto y el método del botón para entrar/salir de la pantalla completa del mapa
-(void)botonVistasOcultas:(BOOL)estado{
    
    if (estado==YES) {//Si las vistas estan oculta indica que hemos pasado a pantalla completa
        //Cambiamos el boton para poder volver a salir del modo de pantalla completa
         self.btnPantallaCompleta.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnQuitarPantallaCompleta.png"]];
        [self.btnPantallaCompleta addTarget:self  action:@selector(quitarMapaPantallaCompleta:) forControlEvents:UIControlEventTouchUpInside];
    }else{//Si las vistas no estan ocultas significa que hemos salido del modo de pantalla completa
        //Cambiamos el boton para poder volver a lanzar el modo de pantalla completa
         self.btnPantallaCompleta.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnPantallaCompleta.png"]];
       [self.btnPantallaCompleta addTarget:self  action:@selector(mapaPantallaCompleta:) forControlEvents:UIControlEventTouchUpInside];
    }
   
}

#pragma mark - Métodos para centrar la región del mapa en la incidencia
//Método que ejecuta la acción de centrar el mapa en la incidencia
-(void)centrarMapaEnPosicion{
    //Obtenemos la coordenada de la incidencia
    CLLocationCoordinate2D coordenada;
    coordenada.latitude=self.feed.latitud;
    coordenada.longitude=self.feed.longitud;
    
    //Esto situara el centro del mapa en la coordenada indicada con la distancia de region que establezcamos
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coordenada,100, 100);
    [self.mapaDetalle setRegion:region animated:YES];
}

//Método asociado al botón de centrar del mapa
- (IBAction)centrarMapa:(id)sender {
    [self centrarMapaEnPosicion];
}

#pragma mark - Método asociado al botón de Link
//Este método nos llevará a
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Si el botón que se pulsó fue el de Link
    if([segue.identifier isEqualToString:@"MostrarWeb"]){
        //Si el pin esta activo
        if(self.pinMapa.pinPulsado==TRUE){
            //Desactivamos el pin y quitamos la tarjeta de detalle asociada al mismo
            [self deseleccionarPin];
        }
        //Obtenemos el controlador de destino
        TRWebViewController *destination = segue.destinationViewController;
        //Guardamos en el controlador el valor de la URL del feed para que este pueda despues redireccionarnos alli
        destination.link=self.feed.link;
       

    }
}
@end
