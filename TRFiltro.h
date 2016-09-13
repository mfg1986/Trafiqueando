//
//  TRFiltro.h
//  Trafiqueando
//
//  Created by maria on 3/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRFiltro : UIView

/*************VARIABLES************/
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *etiquetaFiltro;
@property (weak, nonatomic) IBOutlet UIView *menuDesplegable;
@property (weak, nonatomic) IBOutlet UIButton *btnMostrarMenu;

/*************MÉTODOS****************/
//Inicializador
-(id)init;
//Método par desplegar el menú del filtro
- (IBAction)desplegarMenu:(id)sender;
//Método para seleccionar el valor del filtro
- (IBAction)seleccionFiltro:(id)sender;
@end
