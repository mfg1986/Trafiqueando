//
//  TRDetalleViewController.h
//  Trafiqueando
//
//  Created by maria on 11/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TRFeed.h"
#import "TRPinMapa.h"
#import "TRTarjetaMapa.h"


@interface TRDetalleViewController : UIViewController <MKMapViewDelegate>//Hacemos delegado del mapa al controlador de detalle

/************VARIABLES O PROPIEDADES***************/
//Variables de las vistas donde se mostrará la información
@property (weak, nonatomic) IBOutlet UIImageView *lugarLabel;
@property (weak, nonatomic) IBOutlet UILabel *tituloDetalle;
@property (weak, nonatomic) IBOutlet UIButton *btnLink;
@property (weak, nonatomic) IBOutlet UIButton *btnCentrar;
@property (weak, nonatomic) IBOutlet UIImageView *descripcionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descripcionDetalle;
@property (weak, nonatomic) IBOutlet UIImageView *fechaLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaDetalle;
@property (weak, nonatomic) IBOutlet UIImageView *iconoCoordenadas;
@property (weak, nonatomic) IBOutlet UILabel *latitud;
@property (weak, nonatomic) IBOutlet UILabel *longitud;
@property (weak, nonatomic) IBOutlet UIImageView *iconoTipo;
@property (weak, nonatomic) IBOutlet UIImageView *tipo;
@property (weak, nonatomic) IBOutlet UIImageView *tituloLocalizacion;
@property (weak, nonatomic) IBOutlet UIButton *btnPantallaCompleta;
@property (weak, nonatomic) IBOutlet UIImageView *imagenPie;

//Variables del mapa
@property (weak, nonatomic) IBOutlet MKMapView *mapaDetalle;
@property (nonatomic,strong) TRPinMapa *pinMapa;
@property(nonatomic,strong) TRTarjetaMapa *tarjetaMapa;
@property (nonatomic, retain) MKAnnotationView *selectedPin;

//Frame de todos los elementos del controlador
@property (nonatomic) CGRect frameLugarLabel;
@property (nonatomic) CGRect frameTituloDetalle;
@property (nonatomic) CGRect frameDescripcionLabel;
@property (nonatomic) CGRect frameDescripcionDetalle;
@property (nonatomic) CGRect frameFechaLabel;
@property (nonatomic) CGRect frameFechaDetalle;
@property (nonatomic) CGRect frameIconoCoordenadas;
@property (nonatomic) CGRect frameLatitud;
@property (nonatomic) CGRect frameLongitud;
@property (nonatomic) CGRect frameIconoTipo;
@property (nonatomic) CGRect frameBtnLink;
@property (nonatomic) CGRect frameTipo;
@property (nonatomic) CGRect frameImagenPie;
@property (nonatomic) CGRect frameLocalizacion;
@property (nonatomic) CGRect frameBtnPantallaCompleta;
@property (nonatomic) CGRect frameBtnCentrarMapa;
@property (nonatomic) CGRect frameMapa;



//Variables necesarias para hacer funcionar el scrollview
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//Variable de donde sacaremos la información para mostrar en las vistas
@property (strong) TRFeed *feed;

/****************MÉTODOS**********************/
//Método para obtener la imagen en función del tipo y de la sección en la que ira colocada
-(NSString *)seleccionImagen:(NSString *)tipo seccion:(NSString *)seccion;
//Método para adecuar el campo descripcion de forma dinámica
-(void)ponerTextoLabel:(UILabel *)label conTexto:(NSString *)text anchoLabel:(CGFloat) width fuente:(UIFont *) font posX:(CGFloat) posicionx posY:(CGFloat)posiciony;
//Métodos para centrar el mapa en la posición de la incidencia
-(void)centrarMapaEnPosicion;
- (IBAction)centrarMapa:(id)sender;
//Método para deseleccionar un pin y dejar de mostrar su tarjeta de detalle
-(void)deseleccionarPin;
//Métodos para mostrar/quitar mapa de pantalla completa
- (IBAction)mapaPantallaCompleta:(id)sender;
- (IBAction)quitarMapaPantallaCompleta:(id)sender;
-(void)botonVistasOcultas:(BOOL)estado;
@end
