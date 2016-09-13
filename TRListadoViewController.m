//
//  TRListadoViewController.m
//  Trafiqueando
//
//  Created by maria on 10/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRListadoViewController.h"
#import "TRFeed.h"
#import "TRDetalleViewController.h"
#import "TRCeldaPersonalizada.h"
#import "TRFiltro.h"
#import "TRCustomAlert.h"


@implementation TRListadoViewController
@dynamic tableView;
@synthesize btnMostrarFiltro;



-(void)awakeFromNib{
    //Inicializamos la lista de feeds
    self.listaFeeds=[[NSMutableArray alloc]init];
   
    //Inicializamos la clase encarga de la descarga y nos hacemos al controlador delegador de la clase
    self.descargaXML=[[TRDescargaXML alloc] init];
    
    //Configuramos la barra de navegacion
    [self configNavBar];
    
    //Quitamos los separadores de las celdas de la tabla
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //Le asignamos un fondo a la tabla
    UIImageView *vistaFondoTabla = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Trafiqueando"]];
    [vistaFondoTabla setFrame:self.tableView.frame];
    self.tableView.backgroundView = vistaFondoTabla;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Configuramos el indicador de carga
    [self configurarIndicadorLoading];
    //Arrancamos el indicador de carga
    [self.loadingIndicator startAnimating];
    
    //Cuando la vista del controlador haya sido cargada lanzamos la descarga de feeds
    [self.descargaXML descargaXMLFeeds];
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Métodos para configurar la navigation bar y el indicador de carga
//Método para configurar la navigation bar
-(void)configNavBar{
    
    //Establecemos el estilo del boton de volver al listado
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnVolver"] style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=backBtn;
    
    //Ponemos todo los botones con el interior en blanco
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Establecemos el estilo del boton de menu
    self.btnMostrarFiltro=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu"] style:UIBarButtonItemStyleDone target:self action:@selector(mostrarFiltro:)];
    self.navigationItem.leftBarButtonItem=btnMostrarFiltro;
    
    //Establecemos el estilo de la navigation bar
    UIColor *rojoTrazo=[UIColor colorWithRed:(50.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1];
    NSDictionary *atributosNavBar=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeColorAttributeName:rojoTrazo, NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-5.0],NSFontAttributeName:[UIFont fontWithName:@"Forte" size:30.0]};
    [[UINavigationBar appearance] setTitleTextAttributes: atributosNavBar];
    self.navigationItem.title=@"Trafiqueando";
    
}
//Método para configurar el indicador de carga
-(void)configurarIndicadorLoading{
    //Creamos el indicador de carga
    self.loadingIndicator= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //Creamos
    self.loadingIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.loadingIndicator.center = self.navigationController.view.center;
    CGRect frame=self.loadingIndicator.frame;
    frame.size.height=frame.size.height+95;
    self.loadingIndicator.frame=frame;
    [self.navigationController.view addSubview:self.loadingIndicator];
    
}

#pragma mark - Tratamiento de las Notificaciones
//El controlador comenzara a tratar las notificaciones del parseador cuando su vista aparezca por pantalla
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Obtenemos la referencia al centro de notificaciones
    NSNotificationCenter *centro=[NSNotificationCenter defaultCenter];
    //Nos subscribimos
    [centro addObserver:self selector:@selector(descargadaListaFeeds:) name:@"ListaFeedDescargada" object:nil];
    [centro addObserver:self selector:@selector(errorDescarga:) name:@"ErrorDescarga" object:nil];
    [centro addObserver:self selector:@selector(errorParseo:) name:@"ErrorParseo" object:nil];
}
//El controlador debera dejar de escuchar las notificaciones cuando su vista desaparezca de pantalla
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //Obtenemos la referencia al centro de notificaciones
    NSNotificationCenter *centro=[NSNotificationCenter defaultCenter];
    //Nos damos de baja en el centro de notificaciones
    [centro removeObserver:self];
}
//Método llamado al recibir la notificación de
-(void)descargadaListaFeeds:(NSNotification *)notificacion{
    
    //Paramos el indicador de carga
    [self.loadingIndicator stopAnimating];
    
    //Limpiamos la lista de feeds del controlador con el array que nos proporciona la notificacion
    [self.listaFeeds addObjectsFromArray:notificacion.object];
    
    //Hacemos una copia de la lista de todos los feeds para poder realizar el filtro
    self.listaFeedsFiltrada=[[NSMutableArray alloc] initWithArray:self.listaFeeds];   
  
    //Actualizamos la tabla
    [self.tableView reloadData];
    
    //Si no hay incidencias
    if([self.listaFeeds count]==0){
    
        //Desactivamos el boton que despliega el filtro para no poder utilizarlo cuando no hay incidencias
        self.navigationItem.leftBarButtonItem=nil;
        
        //Cambiamos el fondo de la tabla para indicar que no hay incidencias
        [self cambiarFondoTabla:@"fondoSinIncidencias"];
        
    }else{//Si tenemos incidencias
       
        //Activamos el boton que despliega el filtro
        self.navigationItem.leftBarButtonItem=self.btnMostrarFiltro;
        //Cambiamos el fondo de la tabla
        [self cambiarFondoTabla:@"Trafiqueando"];

    }
}

#pragma mark - Tratamiento de las Alertas
- (void)customAlertView:(TRCustomAlert*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Si tenemos incidencias tras una alerta
    if([self.listaFeeds count]>0){
        //Eliminamos las incidencias descargadas que pueden estar corruptas
        [self.listaFeedsFiltrada removeAllObjects];
        [self.tableView reloadData];
       //Desactivamos el botón de mostrar el filtro
       self.navigationItem.leftBarButtonItem=nil;
    }
    //Activamos el botón de refresco
    self.navigationItem.rightBarButtonItem.enabled=YES;
    //Si el error se produjo era en la descarga
    if([alertView.type isEqualToString:@"Descarga"]){
        if (buttonIndex == 1){//Si el boton presionado en la alerta es el de Aceptar
   
            //Limpiamos la lista de feeds
            [self.listaFeeds removeAllObjects];
            //Volvemos a lanzar la descarga
            [self.descargaXML descargaXMLFeeds];
       
        }else{//Si el boton presionado en la alerta es el de Cancelar
            
            //Cambiamos el fondo de la tabla para indicar que hubo un error en la descarga
            [self cambiarFondoTabla:@"errorDescarga"];
        
        }
    }else if ([alertView.type isEqualToString:@"Parseo"]){
        if (buttonIndex == 0){//Esta alerta solo posee este boton que se corresponde con el de Aceptar
            
            //Cambiamos el fondo de la tabla para indicar que hubo un error en la descarga
            [self cambiarFondoTabla:@"errorParseo"];
        }
    }
}
//Método al que se llama cuando se produce un error en la descarga de feeds
- (void)errorDescarga:(NSNotification *)notificacion{
    //Paramos el indicador de carga
    [self.loadingIndicator stopAnimating];
    
    //Desactivamos el botón del filtro
    self.navigationItem.leftBarButtonItem=nil;
    //Desactivamos el botón del filtro
    self.navigationItem.rightBarButtonItem.enabled=NO;
    //Creamos el mensaje de la alerta
    NSString *mensaje=[NSString stringWithFormat:@"%@\n¿Desea volver a intentarlo?",notificacion.object];
    //Creamos la alerta personalizada
    TRCustomAlert *alert = [[TRCustomAlert alloc] initWithTitle:@"ERROR DE CONEXIÓN" message:mensaje type:@"Descarga"delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitle:@"Aceptar"];
    //Mostramos la alerta
    [alert showInView:self.view];
}
//Método al que se llama cuando se produce un error en el parseo del feed
- (void)errorParseo:(NSNotification *)notificacion{
    
    //Paramos el indicador de carga
    [self.loadingIndicator stopAnimating];
    
    //Desactivamos el botón del filtro
    self.navigationItem.leftBarButtonItem=nil;
    //Desactivamos el botón de refresco
    self.navigationItem.rightBarButtonItem.enabled=NO;
    //Creamos el mensaje de la alerta
    NSString *mensaje=[NSString stringWithFormat:@"%@",notificacion.object];
    //Creamos la alerta personalizada
    TRCustomAlert *alert = [[TRCustomAlert alloc] initWithTitle:@"ERROR DE PARSEO" message:mensaje type:@"Parseo" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitle:nil];
    //Mostramos la alerta
    [alert showInView:self.view];
}

#pragma mark - Metodos de la tabla
//Numero de secciones que tendra la tabla
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//Numero de celdas por seccion-->sera el numero de feeds
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listaFeedsFiltrada count];
}
//Indicamos la altura de las celdas
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}
//Construccion de la celda
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Obtenemos el feed del listado con el que vamos a rellenar la celda
    TRFeed *feed=self.listaFeedsFiltrada[indexPath.row];
    
    TRCeldaPersonalizada *cell;
    if([feed.tipo isEqualToString:@""]){//Si el tipo esta vacío
        
        //Desencolamos una celda vacia
        cell=(TRCeldaPersonalizada *)[tableView dequeueReusableCellWithIdentifier:@"CeldaVacia"];
        //Desactivamos el indicador en forma de flecha que aparece a la derecha en la celda
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{//Si el tipo no esta vacio
        //Desencolamos una celda normal
        cell=(TRCeldaPersonalizada *)[tableView dequeueReusableCellWithIdentifier:@"CeldaPersonalizada"];
    
    }

    //Rellenamos la celda con los datos del feed
    //Ponemos el titulo
    cell.tituloCelda.text=feed.titulo;
    //Ponemos el tipo
    //Definimos el estilo del titulo
    UIColor *grisOscuro=[UIColor colorWithRed:(136.0/255.0) green:(136.0/255.0) blue:(136.0/255.0) alpha:1];
    NSDictionary *atributos=@{NSStrokeColorAttributeName:grisOscuro,NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-5.0]};
    cell.tipoCelda.adjustsFontSizeToFitWidth = YES;
    NSAttributedString *tipo=[[NSAttributedString alloc] initWithString:feed.tipo attributes:atributos];
    //Ponemos el texto del tipo en la etiqueta
    cell.tipoCelda.attributedText=tipo;
    //Ponemos la fecha
    cell.fechaCelda.text=feed.fecha;
    
    
    //Colocamos la imagen en la celda
    NSString *nombreImagen;
    if([feed.tipo isEqualToString:@""]){//Si la celda que vamos a rellenar se corresponde con una celda vacia debido al filtro aplicado
        //Colocamos el icono de la app
        nombreImagen=@"icono57pt";
        
    }else{//Si la celda se corresponde con un feed
        nombreImagen=[self seleccionImagen:feed.tipo];
    }
    UIImage *imagen=[UIImage imageNamed:nombreImagen];
    cell.imagenCelda.image=imagen;
  
    
    //Definimos el fondo de la celda sin seleccionar
    cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celda"]];
    //Definimos el fondo de la celda seleccionada
    cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celdaSeleccionada"]];

    //Devolvemos la celda creada
    return cell;
}
//Método para seleccionar la imagen en función del tipo
-(NSString *)seleccionImagen:(NSString *)tipo{
    NSString *imagen;
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
    }else{
        imagen=@"icono57pt";
    }
  
    return imagen;
}
//Método para cambiar el fondo de la tabla
-(void)cambiarFondoTabla:(NSString *)imagen{
    UIImageView *vistaFondoTabla = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagen]];
    [vistaFondoTabla setFrame:self.tableView.frame];
    self.tableView.backgroundView = vistaFondoTabla;
}

#pragma mark - Metodo para mostrar la vista detallada
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Si el identificador del segue es el de Mostrar detalle
    if([segue.identifier isEqualToString:@"MostrarDetalle"]){

        //Obtenemos la posición en la lista del objeto seleccionado
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //Obtenemos el feed correspondiente a la posicion seleccionada de la lista
        TRFeed *feed = [self.listaFeedsFiltrada objectAtIndex:indexPath.row];
        //Obtenemos el controlador de destino al que nos conduce el segue
        TRDetalleViewController *destination = segue.destinationViewController;
        //Guardamos en el controlador de destino el feed que deseamos mostrar
        destination.feed = feed;
        
        //Si el filtro estaba desplegado lo escondemos
        if (self.btnMostrarFiltro.tag==1) {
            //Ponemos el boton de que muestra el filtro en el estado inicial
            self.btnMostrarFiltro.tag=0;
            //Cambiamos el icono de aplicar por el de icono de las barras y el metodo que ejecuta para que muestre el filtro
            UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu"] style:UIBarButtonItemStyleDone target:self action:@selector(mostrarFiltro:)];
            self.navigationItem.leftBarButtonItem=menuBtn;
            //Redimensionamos la cabecera de la tabla para que no muestre el filtro
            CGRect frame = self.tableView.tableHeaderView.frame;
            frame.size.height = 0;
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
        }
      
    }
   
}

#pragma mark - Metodo asociado al botón de refresco
- (IBAction)recargaFeed:(id)sender {
    
    //Cambiamos el fondo de la tabla
    [self cambiarFondoTabla:@"Trafiqueando"];
    
    //Arrancamos el indicador de carga
    [self.loadingIndicator startAnimating];
    
    //Limpiamos la lista de feeds
    [self.listaFeeds removeAllObjects];
    //Volvemos a lanzar la descarga
    [self.descargaXML descargaXMLFeeds];
}

#pragma mark - Metodos del filtro
- (IBAction)mostrarFiltro:(id)sender {
     UIBarButtonItem *btn=sender;
    
    self.vistaFiltro=[[TRFiltro alloc] init];
    //Hacemos visible la vista con el filtro
         
         //Redimensionamos la cabecera de la tabla para mostrar el filtro
         self.tableView.tableHeaderView.hidden=NO;
         CGRect frame = self.tableView.tableHeaderView.frame;
         frame.size.height = 42;
         self.vistaFiltro.frame=frame;
         self.tableView.tableHeaderView = self.vistaFiltro;
         //Cambiamos el estado del boton para indicar que estamos mostrando el filtro
         btn.tag=1;
         //Creamos un botón para poder aplicar el filtro
         UIBarButtonItem *aplicarBtn=[[UIBarButtonItem alloc] initWithTitle:@"Aplicar" style:UIBarButtonItemStyleDone target:self action:@selector(aplicarFiltro:)];
        //Definimos el estilo del texto del botón
        NSDictionary *atributos=@{NSFontAttributeName: [UIFont fontWithName:@"Forte" size:16],NSForegroundColorAttributeName: [UIColor whiteColor]};
        [aplicarBtn setTitleTextAttributes:atributos forState:UIControlStateNormal];
        //Cambiamos el botón
        self.navigationItem.leftBarButtonItem=aplicarBtn;
    
        
        
    
    
    
}
- (IBAction)aplicarFiltro:(id)sender {
    
    //Redimensionamos la cabecera de la tabla para esconder el filtro
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    //Volvemos a poner el boton de la navigaton bar para mostrar el filtro
    UIBarButtonItem *filtroBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(mostrarFiltro:)];
    self.navigationItem.leftBarButtonItem=filtroBtn;
    
    //Si la opción del filtro ha sido "Todas las categorías" se muestran todos los feed por ello la lista filtrada y la descargada seran iguales
    if ([self.vistaFiltro.etiquetaFiltro.text isEqualToString:@"Todas las categorías"]){
        self.listaFeedsFiltrada=[[NSMutableArray alloc] initWithArray:self.listaFeeds];
        
    }else{//Si se ha elegido filtrar la lista
         //Eliminamos todos los objetos de la listafiltrada
         [self.listaFeedsFiltrada removeAllObjects];
        for (int i=0; i<[self.listaFeeds count]; i++) {//Recorremos la lista descargada
            TRFeed *feed=self.listaFeeds[i];
            if([feed.tipo isEqualToString:self.vistaFiltro.etiquetaFiltro.text]){//Si el tipo del feed coincide con la opción de filtrado seleccionado
                //Añadimos dicho feed a la listra filtrada que se mostrara
                [self.listaFeedsFiltrada addObject:feed];
            }
       
        }
        //Si la lista filtrada esta vacía es que no ha habido coincidencias
        if (self.listaFeedsFiltrada.count==0) {
            //Creamos un feed de tipo vacío que inique que no ha habido resultados y que apliquemos de nuevo el filtro
            TRFeed *feedVacio=[[TRFeed alloc] init];
            feedVacio.titulo=@"Sin Resultados";
            feedVacio.tipo=@"";
            feedVacio.fecha=@"Aplique de nuevo el filtro";
            //Lo añadimos a la lista filtrada
            [self.listaFeedsFiltrada addObject:feedVacio];
        }
    }
  
    //Refrescamos la tabla
    [self.tableView reloadData];
   
}

@end



