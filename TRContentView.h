//
//  TRContentView.h
//  Trafiqueando
//
//  Created by maria on 12/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRContentView : UIView

/***********VARIABLES O PROPIEDADES********/
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *subtitulo;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UILabel *fecha;

/********MÉTODOS**************/
-(id)init;
-(void)ColocarTitulo:(NSString*)titulo SubTitulo:(NSString *)subtitulo yFecha:(NSString*) fecha;
@end
