//
//  TRContentView.m
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRContentView.h"

@implementation TRContentView
//Método inicializador de la clase que carga la vista TRContentView.xib
-(id)init{
    if(self=[super init]){
        //Asociamos la vista TRContentView.xib a esta clase
        self=[[[NSBundle mainBundle] loadNibNamed:@"TRContentView" owner:self options:nil] firstObject];
    }
    return self;
}
//Métdodo que rellena los campos de la vista
-(void)ColocarTitulo:(NSString*)titulo SubTitulo:(NSString *)subtitulo yFecha:(NSString*) fecha{
  
    /***********Ponemos el TITULO*********/
    self.titulo.text=titulo;
    
    /**********Ponemos el SUBTITULO*******/
    //Obtenemos el frame de la etiqueta subtitulo
    CGRect frameSubtitulo=self.subtitulo.frame;
    //Cogemos la altura inicial de la etiqueta
    CGFloat alturaInicial=frameSubtitulo.size.height;
    
    //Ponemos la primera letra de cada palabra en mayúscula
    NSString *subtituloStr=[subtitulo capitalizedString];
    NSAttributedString *attributedText=[[NSAttributedString alloc] initWithString:subtituloStr];
    //Obtenemos rectangulo que ocupara nuestro texto
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){frameSubtitulo.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //Obtenemos las dimensiones
    CGSize size = rect.size;
    //Redimensionamos la altura de la etiqueta
    frameSubtitulo.size.height=size.height;
    //Asignamos a la etiqueta su nuevo frame
    self.subtitulo.frame=frameSubtitulo;
    
    //Para soportar multilineas
    self.subtitulo.numberOfLines=0;
    //Colocamos el texto
    self.subtitulo.attributedText=attributedText;
    
    
    /*******Ponemos la FECHA***********/
    //Colocamos la fecha
    //Obtenemos la posición en la que comenzará la etiqueta de la fecha
    CGFloat posYfecha=self.subtitulo.frame.origin.y+self.subtitulo.frame.size.height+5;
    //Recolocamos la etiqueta en dicha posición
    CGRect framefecha=self.fecha.frame;
    framefecha.origin.y=posYfecha;
    self.fecha.frame=framefecha;    
    //Colocamos el valor de la fecha
    self.fecha.text=fecha;
    
    
    /*******REDIMENSIONAMOS LA TARJETA***********/
    //Aumentamos el tamaño de la tarjeta:El aumento se corresponde al incremento de altura de la etiqueta de subtitulo
    CGFloat incremento=size.height-alturaInicial;
    //Redimensionamos la altura de la tarjeta
    CGRect frameTotal=self.frame;
    frameTotal.size.height=frameTotal.size.height+incremento+5;
    self.frame=frameTotal;

}
@end
