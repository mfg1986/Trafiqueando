//
//  TRListadoViewController.h
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRDescargaXML.h"
#import "TRFiltro.h"
#import "TRCustomAlert.h"

@interface TRListadoViewController : UITableViewController <CustomAlertDelegate>


/****************VARIABLES O PROPIEDADES******************/
//Vista de la tabla
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//Vista del filtro
@property (strong, nonatomic) TRFiltro *vistaFiltro;
//Array con la lista de feeds
@property (strong) NSMutableArray *listaFeeds;
//Array con la lista de feeds filtrada
@property (strong) NSMutableArray *listaFeedsFiltrada;
//Referencia a la clase que descarga el XML
@property (strong)TRDescargaXML *descargaXML;
//botón encargado de mostrar y aplicar el filtro
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnMostrarFiltro;
//Indicador de carga
@property (retain, nonatomic) UIActivityIndicatorView *loadingIndicator;


/***********************MÉTODOS***************************/
//Método para configurar la navigation bar
-(void)configNavBar;
//Métodos para configurar el indicador de carga
-(void)configurarIndicadorLoading;
//Metodo para mostrar el filtro
- (IBAction)mostrarFiltro:(id)sender;
//Metodo para aplicar el filtro
- (IBAction)aplicarFiltro:(id)sender;
//Método para establecer la imagen en la celda
-(NSString *)seleccionImagen:(NSString *)tipo;
//Método para cambiar el fondo de la tabla
-(void)cambiarFondoTabla:(NSString *)imagen;
//Método para recargar el listado de feeds
- (IBAction)recargaFeed:(id)sender;
//Método que se invoca al recibir la notificicacion del parseador de que la lista de feeds esta descarga
-(void)descargadaListaFeeds:(NSNotification *)notificacion;
//Método para mostrar alertas
- (void)errorParseo:(NSNotification *)notificacion;
- (void)errorDescarga:(NSNotification *)notificacion;

@end
