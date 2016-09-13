//
//  TRFiltro.m
//  Trafiqueando
//
//  Created by maria on 3/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRFiltro.h"

@implementation TRFiltro
@synthesize menuDesplegable, etiquetaFiltro;
@synthesize btnMostrarMenu;

//Inicializador de la clase
-(id)init{
    if(self=[super init]){
        
        //Asociamos la vista del filtro vistaFiltro.xib a la clase
        self = [[[NSBundle mainBundle] loadNibNamed:@"vistaFiltro" owner:self options:nil] firstObject];
        //Inicializamos el boton de mostrar el menu del filtro con el icono para desplegarlo
        [self.btnMostrarMenu setTitle:@"▼" forState:UIControlStateNormal];
        //Definimos la etiqueta en la que se muestra la selección para que ajuste el tamaño de letra al ancho de la etiqueta
        self.etiquetaFiltro.adjustsFontSizeToFitWidth = YES;
        
    }
    return self;

}
//Método para desplegar las opciones el filtro
- (IBAction)desplegarMenu:(id)sender {
    //Obtenemos el botón que despliega el menu filtro
    UIButton *btn=sender;
    //Si el tag del botón es 0 significa que el filtro esta recogido y queremos mostrarlo
    if ([sender tag]==0) {//Desplegamos el menu
        //Cambiamos el valor del tag a 1
        btn.tag = 1;
        //Obtenemos el frame actual de la vista del filtro
        CGRect frame = self.frame;
        //Cambiamos el valor de la altura para desplegarlo
        frame.size.height = 230;
        //Asignamos el nuevo frame a la vista del filtro
        self.frame=frame;
        
        //Hacemos visibles todas las opciones del filtro
        self.menuDesplegable.hidden = NO;
       //Cambiamos el icono del botón que despliega el filtro
        [btn setTitle:@"▲" forState:UIControlStateNormal];
        
    } else {//Escondemos el menu
        //Cambiamos el valor del tag a 0
        btn.tag = 0;
        //Obtenemos el frame actual de la vista del filtro
        CGRect frame = self.frame;
        //Cambiamos su altura
        frame.size.height = 42;
        //Asignamos el nuevo frame a la vista del filtro
        self.frame=frame;
       
        //Hacemos invisibles todas las opciones del filtro
        self.menuDesplegable.hidden = YES;
        //Cambiamos el icono del botón que despliega el filtro
        [btn setTitle:@"▼" forState:UIControlStateNormal];
    }
    //Volvemos a asignar el boton con todos sus cambios
    self.btnMostrarMenu=btn;
}
//Método que se llama al seleccionar una de las opciones del menú del filtro
- (IBAction)seleccionFiltro:(id)sender {
    
    //Ponemos en la etiqueta la opción seleccionada
    self.etiquetaFiltro.text = [sender titleLabel].text;
    //Cambiamos el icono del botón encargado del menú
    [self.btnMostrarMenu setTitle:@"▼" forState:UIControlStateNormal];
    //Cambiamos el tag del botón del menu
    self.btnMostrarMenu.tag = 0;
    //Ocultamos todas las opciones del menu del filtro
    self.menuDesplegable.hidden = YES;
    //Encogemos el menu
    CGRect frame = self.frame;
    frame.size.height = 42;
    self.frame=frame;

    
}

@end
