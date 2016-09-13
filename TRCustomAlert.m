//
//  TRCustomAlert.m
//  Trafiqueando
//
//  Created by maria on 8/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRCustomAlert.h"

@implementation TRCustomAlert
@synthesize delegate;
@synthesize AlertView;


//Metodo de construccion de la alerta
- (id)initWithTitle:(NSString *)title message:(NSString *)message type:(NSString *)type delegate:(id)AlertDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle{
    
    //Creamos un frame que se correspondera con el ancho y el alto del bound de la pantalla
       CGRect frame = CGRectMake(0.0,-50.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    //Asignamos el frame creado a nuestra alerta de forma que ocuparemos toda la pantalla, esto se hace para ocurecer el fondo y luego añadir la subvista de la alerta
    if (self=[super initWithFrame:frame]) {//Si se crea correctamente
        //Guardamos el tipo de alerta
        self.type=type;
        //Le asignamos el delegado
        self.delegate = AlertDelegate;
        //Para centrar el foco de atencion en la alerta cambiaremos el fondo oscureciendolo
        self.alpha = 0.95;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //Ajustamos la vista automaticamente manteniendo la altura y la anchura
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
  
        //Creamos una vista con la imagen de fondo
        UIImageView *AlertImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_bg.png"]];
        
        //Creamos un cursor de anchura y le asignamos el valor del ancho de la imagen de fondo
        float alert_width = AlertImgView.frame.size.width;
        //Creamos un cursor de altura que comenzara en 5
        float alert_height = 5.0;
        
   /**************/
  /****TITULO*****/
        
        //Añadimos el titulo de la alerta
        UILabel *TitleLbl;
        //Creamos el frame de la etiqueta Titulo con los cursores de anchura y altura
        CGRect frameTitulo=CGRectMake(10.0, alert_height+5, alert_width-20.0, 30.0);
        if (title){//Si se paso el titulo al constructor de la alerta
            
            //Ponemos los atributos de letra y asignamos el titulo a la etiqueta
            TitleLbl=[self estiloEtiquetaTexto:title Frame:frameTitulo Fuente:@"Forte" tamanyo:18.0 color:@"blanco"];
           
        }
        else{//Si no se paso el titulo al constructor de la alerta
            
            //Ponemos los atributos de letra y asignamos el titulo como Alerta
            TitleLbl = [self estiloEtiquetaTexto:@"Alerta" Frame:frameTitulo Fuente:@"Forte" tamanyo:18.0 color:@"blanco"];
            
        }
         //Desplazamos el cursor de altura
        alert_height += TitleLbl.frame.size.height + 10.0;
        
   /**************/
  /****MENSAJE****/
        
        //Añadimos el contenido o mensaje de la alerta
          UILabel *MessageLbl;
        //Creamos el frame de la etiqueta de mensaje con los cursores de anchura y altura
          CGRect frameMensaje=CGRectMake(20.0, alert_height, alert_width-40.0, 0.0);
        
        if (message){//Si se paso el mensaje al constructor de la alerta
            //Ponemos los atributos de letra y asignamos el mensaje a la etiqueta
            MessageLbl=[self estiloEtiquetaTexto:message Frame:frameMensaje Fuente:@"Forte" tamanyo:16 color:@"blanco"];
            //Desplazamos el cursor de altura
            alert_height +=MessageLbl.frame.size.height+5;
        }
        else {//Si no se paso el mensaje al constructor de la alerta
            //Ponemos los atributos de letra y asignamos el mensaje de desconocido a la etiqueta
            MessageLbl=[self estiloEtiquetaTexto:@"Desconocido" Frame:frameMensaje Fuente:@"Forte" tamanyo:16 color:@"blanco"];
            //Desplazamos el cursor de altura
            alert_height += 15.0;
        }
        
    /***************/
    /****BOTONES****/
        
        //Obtenemos la imagen de fondo de los botones
        UIImage *FondoBtnImg = [UIImage imageNamed:@"cancel_btn.png"];

        //Añadimos los botones a la alerta
        UIButton *CancelarBtn;
        UIButton *AceptarBtn;
        
        if (cancelButtonTitle && otherButtonTitle){//Si la alerta posee dos botones
        
            //Creamos un cursor de anchura
            float x_displ = (int)((alert_width-FondoBtnImg.size.width*2)/3.0);
            
            //Creamos el frame para el primer boton-->Cancelar
            CGRect frameBtn1=CGRectMake(x_displ, alert_height, FondoBtnImg.size.width, FondoBtnImg.size.height);
            //Le damos estilo al botón
            CancelarBtn = [self estiloBotonTexto:cancelButtonTitle Frame:frameBtn1 Tag:1000 Fuente:@"Forte" tamanyo:18.0 color:@"blanco"background:FondoBtnImg];
            //Asociamos el método que se llamará cuando pulsemos el botón
            [CancelarBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //Creamos el frame para el segundo botón-->Aceptar
            CGRect frameBtn2=CGRectMake(x_displ*2+FondoBtnImg.size.width, alert_height, FondoBtnImg.size.width, FondoBtnImg.size.height);
            //Le damos estilo al botón
            AceptarBtn = [self estiloBotonTexto:otherButtonTitle Frame:frameBtn2 Tag:1001 Fuente:@"Forte" tamanyo:18.0 color:@"blanco" background:FondoBtnImg];
            //Asociamos el método que se llamará cuando pulsemos el botón
            [AceptarBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            //Desplazamos el cursor de altura de la alerta
            alert_height += CancelarBtn.frame.size.height + 15.0;
        }
        else if (cancelButtonTitle){//Si la alerta solo tiene el boton de aceptar
           //Creamos el frame para el botón-->Aceptar
            CGRect frameBtn=CGRectMake((int)((alert_width-FondoBtnImg.size.width)/2.0), alert_height, FondoBtnImg.size.width, FondoBtnImg.size.height);
             //Le damos estilo al botón
            AceptarBtn = [self estiloBotonTexto:cancelButtonTitle Frame:frameBtn Tag:1000 Fuente:@"Forte" tamanyo:18.0 color:@"blanco"background:FondoBtnImg];
           //Asociamos el método que se llamará cuando pulsemos el botón
            [AceptarBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
           //Desplazamos el cursor de altura de la alerta
            alert_height += AceptarBtn.frame.size.height + 15.0;
        }
        else{//En clq otro caso
            //Desplazmaos el cursor de altura
            alert_height += 15.0;
        }
        
    /***************/
    /****FONDO******/
        
        //Añadimos el fondo a la alerta
        //Creamos el frame de nuestra vista de alerta
        AlertView = [[UIView alloc] initWithFrame:CGRectMake((int)((self.frame.size.width-alert_width)/2.0), (int)((self.frame.size.height-alert_height)/2.0), alert_width, alert_height+20)];
        //Ajustamos la vista automaticamente manteniendo los margenes
        AlertView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //Adaptamos la vista de fondo al tamaño de nuestra alerta
        AlertImgView.frame = AlertView.bounds;
        //Añadimos la vista de fondo a la vista de nuestra alerta
        [AlertView addSubview:AlertImgView];
        
        //Añadimos las vistas de los campos a la vista de nuestra alerta
        if (TitleLbl){[AlertView addSubview:TitleLbl];}
        if (MessageLbl){[AlertView addSubview:MessageLbl];}
        if (CancelarBtn){[AlertView addSubview:CancelarBtn];}
        if (AceptarBtn){[AlertView addSubview:AceptarBtn];}
        
        //Añadimos la vista de nuestra alerta a la vista de fondo oscurecido creada al principio
        [self addSubview:AlertView];
    }
    

    return self;
}


#pragma mark - Métodos para dar estilo a los botones y las etiquetas de la alerta
//Metodo para dar estilo a los textos de la alerta
-(UILabel *)estiloEtiquetaTexto:(NSString *)texto Frame:(CGRect)frame Fuente:(NSString *)fuente tamanyo:(CGFloat)size color:(NSString *)color{
   
    //Iniciamos la etiqueta con el frame pasado como argumento
    UILabel *Label = [[UILabel alloc] initWithFrame:frame];
    //Asignamos el color de fondo de la etiqueta
    Label.backgroundColor = [UIColor clearColor];
    
    
    //Creamos la fuente
    UIFont *font = [UIFont fontWithName:fuente size:size];
    
    //Asignamos el color al texto
    UIColor *colorLetra;
    if([color isEqualToString:@"blanco"]){colorLetra = [UIColor whiteColor];}
    
    //Definimos el estilo de parrafo
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment =NSTextAlignmentCenter;
    
    //Dicionario con los atributos del texto
    NSDictionary *atributos=@{NSFontAttributeName: font,NSParagraphStyleAttributeName : style,NSForegroundColorAttributeName:colorLetra};
    
    //Creamos un texto con atributos
    NSAttributedString *attributedText =[[NSMutableAttributedString alloc] initWithString:texto attributes:atributos];
    
    //Obtenemos rectangulo que ocupara nuestro texto
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    //Obtenemos las dimensiones
    CGSize sizeText = rect.size;
    
    //Redimensionamos la etiqueta
    Label.frame=CGRectMake(Label.frame.origin.x,Label.frame.origin.y,Label.frame.size.width, sizeText.height);
    
    //Para soportar multilineas
    Label.numberOfLines=0;
    
    //Colocamos el texto
    Label.attributedText=attributedText;
    
    return Label;
    
    
}
//Método para dar estilo a los botones de la alerta
-(UIButton *)estiloBotonTexto:(NSString *)texto Frame:(CGRect)frame Tag:(int) tag Fuente:(NSString *)fuente tamanyo:(CGFloat)size color:(NSString *)color background:(UIImage *)background{
    //Creamos un botón
    UIButton *Btn = [[UIButton alloc] initWithFrame:frame];
    //Le asociamos el tag
    [Btn setTag:tag];
    //Le ponenmos el texto
    [Btn setTitle:texto forState:UIControlStateNormal];
    //Asignamos al texto la fuente y el tamaño
    [Btn.titleLabel setFont:[UIFont fontWithName:fuente size:size]];
    //Indicamos que el color del texto del boton sea blanco
    if([color isEqualToString:@"blanco"]){
        [Btn setTintColor:[UIColor whiteColor]];
    }
    //Le ponemos el fondo al botón
    [Btn setBackgroundImage:background forState:UIControlStateNormal];
    return Btn;
    
}


#pragma mark - Métodos para mostrar/quitar la alerta
//Metodo al presionar el boton de la alerta
- (void)onBtnPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    //Obtenemos el tag del boton 0->CancelButton 1->OtherButton
    int button_index = button.tag-1000.0;
    //Lanzamos el metodo que implementa el delegado
    if ([delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
        [delegate customAlertView:self clickedButtonAtIndex:button_index];
    //Quitamos con una animacion la alerta
    [self animateHide];
    
}
//Metodo para mostrar la alerta
- (void)showInView:(UIView*)view{
    if ([view isKindOfClass:[UIView class]])
    {
        //Añadimos la vista de la alerta a la vista actual
        [view addSubview:self];
        //Mostramos la alerta por medio de una animacion
        [self animateShow];
    }
}




#pragma mark - Animaciones de la alerta
//Animacion al abrir la alerta
- (void)animateShow{
    //Creamos una animación
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //Indicamos las escalas
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    //Creamos un array con los valores de escala
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    //Añadimos el array con los factores de escala a la animación
    [animation setValues:frameValues];
    //Creamos un array con los tiempos asociados a los valores de escala
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    //Añadimos el array de tiempos a la animación
    [animation setKeyTimes:frameTimes];
    //Congelamos la animación cuando termine
    animation.fillMode = kCAFillModeForwards;
    //Indicamos que no queremos eliminar la animación una vez concluya
    animation.removedOnCompletion = NO;
    //Establecemos el tiempo de la animación
    animation.duration = 0.2;
    //Añadimos la animación a la alerta cuando esta se muestre
    [AlertView.layer addAnimation:animation forKey:@"show"];
}
//Animacion al cerrar la alerta
- (void)animateHide{
    //Creamos una animacion para el frame de la alerta indicando que propiedad vamos a animar
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    //Creamos tres escalas para el frame de la alerta
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.0, 0.0, 1);
   
    //Creamos una matriz con los valores de escala
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            nil];
    //Añadimos a la animacion los valores de escala
    [animation setValues:frameValues];
    
    //Creamos un array de tiempos
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           nil];
    //Añadimos los tiempos a la animacion
    [animation setKeyTimes:frameTimes];
    //Congelamos la animación cuando termine
    animation.fillMode = kCAFillModeForwards;
    //Indicamos que no queremos eliminar la animación una vez concluya
    animation.removedOnCompletion = NO;
    //Indicamos que la duracion de la animacion será de 0,1s
    animation.duration = 0.2;
    
    //Añadimos la animacion que se ejecutará cuando la alerta desaparezca
    [AlertView.layer addAnimation:animation forKey:@"hide"];
    
    //Elinamos la vista de la alerta
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.105];
}



@end
