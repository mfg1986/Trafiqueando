//
//  TRCeldaPersonalizada.m
//  Trafiqueando
//
//  Created by maria on 19/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRCeldaPersonalizada.h"

@implementation TRCeldaPersonalizada
@synthesize tituloCelda;
@synthesize tipoCelda;
@synthesize imagenCelda;
@synthesize fechaCelda;

//Método inicializador de la clase
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//Método que se llama para configurar la vista cuando la celda ha sido seleccionada
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
