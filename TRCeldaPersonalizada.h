//
//  TRCeldaPersonalizada.h
//  Trafiqueando
//
//  Created by maria on 19/11/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRCeldaPersonalizada : UITableViewCell

/*********VARIABLES O PROPIEDADES***********/
@property (nonatomic,weak) IBOutlet UILabel *tituloCelda;
@property (nonatomic,weak) IBOutlet UILabel *fechaCelda;
@property (weak, nonatomic) IBOutlet UIImageView *imagenCelda;
@property (weak, nonatomic) IBOutlet UILabel *tipoCelda;


@end
