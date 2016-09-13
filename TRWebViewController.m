//
//  TRWebViewController.m
//  Trafiqueando
//
//  Created by maria on 16/12/15.
//  Copyright (c) 2015 master. All rights reserved.
//

#import "TRWebViewController.h"

@implementation TRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Creamos una petición de conexión a la URL del feed
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.link];
    //Cargamos el contenido de de dicha URL en una vista de web para mostrarla al usuario
    [self.webView loadRequest:requestObj];
    //Añadimos dicha vista como una subvista a la vista principal del controlador
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
