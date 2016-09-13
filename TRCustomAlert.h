//
//  TRCustomAlert.h
//  Trafiqueando
//
//  Created by maria on 8/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface TRCustomAlert : UIView

/********VARIABLES O PROPIEDADES******************/
@property (nonatomic,strong) UIView *AlertView;
@property (nonatomic,strong) NSString *type;
@property id delegate;

/*********************MÉTODOS********************/
//Método para crear la alerta
- (id)initWithTitle:(NSString *)title message:(NSString *)message type:(NSString *) type delegate:(id)AlertDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;
//Método para dar estilo a los texto de la alerta
-(UILabel *)estiloEtiquetaTexto:(NSString *)texto Frame:(CGRect)frame Fuente:(NSString *)fuente tamanyo:(CGFloat)size color:(NSString *)color;
//Método para dar estilo a los botones de la alerta
-(UIButton *)estiloBotonTexto:(NSString *)texto Frame:(CGRect)frame Tag:(int) tag Fuente:(NSString *)fuente tamanyo:(CGFloat)size color:(NSString *)color background:(UIImage *)background;
//Método para mostrar la alerta
- (void)showInView:(UIView*)view;

@end


//Protocolo en el que definimos el metodo que se llama cuando alguno de los botones de la alerta es pulsado
@protocol CustomAlertDelegate
- (void)customAlertView:(TRCustomAlert*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end