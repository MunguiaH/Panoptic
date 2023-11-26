$fn = 100;


/* Cámara */
module camara(){
    cylinder(h = 3, d = 18.5);
    translate([0,0,5.5])
        cube([71.5,31.5,5], center = true);
}

/* Parámetros generales */


r_general = 60;
r_interno = 0.85*r_general;
r_pines = 0.925*r_general;
r_iman = 4;
r_pines_ind = 2.25;
r_pin_compuerta = 0.04*r_general;
r_canal_cableado_h = 2;
r_canal_cableado_v = 2;


/* Base */


/* Parte inferior con espacio para iluminación. PLA Blanco. */
h_base = 10;

module base(){
    difference(){
        cylinder(h = h_base, r = r_general);
        translate([0,0,3])
            cylinder(h = 50, r = r_interno);
    
        /* Canal para cableado */
        rotate([0,0,-30]){
        translate([0,-r_pines,h_base/2-r_canal_cableado_h])
            cylinder(h=h_cuerpo, r = r_canal_cableado_v);
        
        translate([0,0,h_base/2+r_canal_cableado_h/2])
            rotate([0,90,-90])
                cylinder(h=r_pines, r = r_canal_cableado_h);
        }
                
        /* Espacio para LEDs */
        translate([0,0,3])
            cube([20.1,20.1,1.5],center=true);
        translate([22,0,3])
            cube([20.1,20.1,1.5],center=true);
        translate([-22,0,3])
            cube([20.1,20.1,1.5],center=true);
        translate([0,-22,3])
            cube([20.1,20.1,1.5],center=true);
        translate([0,22,3])
            cube([20.1,20.1,1.5],center=true);
        }

        
      /* canal para ensamblado */
      translate([0,0,h_base])
          difference(){
          cylinder(h = 2, r = 1.04*r_interno);
          cylinder(h = 2, r = r_interno);
          }
    
//    /* Pines para ensamblado */
//    for(theta = [18:72:378])
//        translate([r_pines*cos(theta),r_pines*sin(theta),h_base])
//            cylinder(h = 4, r = r_pines_ind);                   
}

/* Bandeja para placas. PLA transparente */
D = [35.5, 60.5, 65.5, 70.5, 90.5];
h = [7.5, 6.5, 5.5, 4.5, 3.5];

h_bandeja = 5;
r_bandeja = 76;

module bandeja(){
    difference(){
        translate([0,0,h_base])
            difference(){    
                cylinder(h=h_bandeja, r=r_general, center = false);
                for(i=[ 0:len(D)-1]){
                    translate([0,0,h_bandeja-h[i]/2])
                        cylinder(h = h[i], d = D[i], center = false);
                    }
            }
        base();
        
        /* Canal para cableado */
        rotate([0,0,-30]){
        translate([0,-r_pines,h_base/2])
            cylinder(h=h_cuerpo+h_base, r = r_canal_cableado_v);
        }
    }
    
//    /* Pines para ensamblado */
//    for(theta = [195:30:345])
//        translate([r_pines*cos(theta),r_pines*sin(theta),h_base+h_bandeja])
//            cylinder(h = 4, r = r_pines_ind);

  /* canal para ensamblado */
  translate([0,0,h_base+h_bandeja])
      difference(){
      cylinder(h = 2, r = 1.04*r_interno);
      cylinder(h = 2, r = r_interno);
      translate([0,55,4])
        cube([130,130,8], center=true);
      }

  
            
    /* Pin para compuerta */
    translate([r_pines,0,h_base+h_bandeja])
        cylinder(h = 2, r = r_pin_compuerta);
}

/* Compuerta. PLA Blanco */

/* Compuerta sin orificios */
module compuerta_sin_orificio(){
    translate([r_pines,0,h_base+h_bandeja]){
        cylinder(h = h_cuerpo, r = 0.05*r_general);
}

translate([0,0,h_base+h_bandeja])
    difference(){
        cylinder(h = h_cuerpo, r = r_general);
        cylinder(h = h_cuerpo, r = 0.96*r_interno);
        translate([-r_general,-r_general,0])
            cube([2*r_general, r_general, h_cuerpo]);
    }
}

module compuerta(){
    difference(){
        compuerta_sin_orificio();
        bandeja();
        
        /* Orificio para imán */
        translate([-r_pines,1.5,h_base+h_cuerpo/2+r_iman])
            rotate([90,0,0])
                cylinder(h = 2, r = r_iman);
                
        /* Orificio para abrir */
        translate([-r_general-3,14,h_base+h_bandeja+h_cuerpo/2-1])
            rotate([90,0,0])
                cylinder(h = 14, r1 = 10, r2 = 2);

    }
    translate([r_pines,0,h_base+h_bandeja+h_cuerpo])
        cylinder(h = 4, r = r_pin_compuerta);
}

/* Cuerpo. PLA Blanco */
h_cuerpo = 100;
module cuerpo(){
    difference(){
        translate([0,0,h_base+h_bandeja])
            cylinder(h = h_cuerpo, r = r_general);
        translate([0,0,h_base+h_bandeja])
            cylinder(h = h_cuerpo, r = 0.96*r_interno);
        translate([-r_general,0,h_base+h_bandeja])
            cube([r_general*2, r_general, h_cuerpo]);
        bandeja();
        
    /* parte de la compuerta */
        theta_compuerta = 268.5; //Acepta ángulos menores a 270°
        r_giro_compuerta = r_pines;
        x_offset = sqrt(r_giro_compuerta^2/(abs(1+tan(theta_compuerta)^2)));
        y_offset = tan(theta_compuerta)*x_offset;

        translate([x_offset+r_pines,y_offset,0])
            rotate([0,0,theta_compuerta])
                compuerta_sin_orificio();
        
        /* Canal para cableado */
        rotate([0,0,-30]){
        translate([0,-r_pines,h_base+h_bandeja])
                cylinder(h=h_cuerpo, r = r_canal_cableado_v);
        }
                
        /* Orificio para imán */
        translate([-r_pines,0,h_base+h_cuerpo/2+r_iman])
            rotate([90,0,0])
                cylinder(h = 2, r = r_iman);
    }
    
  /* canal para ensamblado */
  translate([0,0,h_base+h_bandeja+h_cuerpo])
      difference(){
      cylinder(h = 2, r = 1.04*r_interno);
      cylinder(h = 2, r = r_interno);
      translate([0,60,4])
        cube([130,130,8], center=true);
      }
    
    
//    /* Pines para ensamblado */
//    for(theta = [195:30:345])
//        translate([r_pines*cos(theta),r_pines*sin(theta),h_base+h_bandeja/2+h_cuerpo])
//            cylinder(h = 4, r = r_pines_ind);
}




/* Parte superior. PLA Blanco */
h_top = 40;
module top(){
    difference(){
        translate([0,0,h_base+h_bandeja+h_cuerpo])
            cylinder(h = h_top, r = r_general);
        translate([0,0,h_base+h_bandeja+h_cuerpo+5])
            cylinder(h = h_top, r = r_interno);
        cuerpo();
        compuerta();
    
        /*orificios*/
        /* Para cámara */
        translate([0,0,h_base+h_bandeja+h_cuerpo])
            camara();

            
        /* Para cableado */
        rotate([0,0,-30]){
            translate([0,0,h_base+h_bandeja+h_cuerpo+h_top/2+r_canal_cableado_v])
                rotate([0,90,-90])
                    cylinder(h = r_pines, r = r_canal_cableado_v);
            
            translate([0,-r_pines,h_base+h_bandeja+h_cuerpo])
                cylinder(h=h_top/2+r_canal_cableado_v, r = r_canal_cableado_v);
        }
        
        /* USB */
        rotate([0,0,-90])
            translate([0,0,h_base+h_bandeja+h_cuerpo+h_top/2+r_canal_cableado_v+10])
                cube([r_general,5,h_top/2]);
        
    }
}


/* Tapa. PLA Blanco */
h_tapa = 3.5;
module tapa(){
    difference(){
        translate([0,0,h_base+h_bandeja+h_cuerpo+h_top-h_tapa/2])
            cylinder(h = h_tapa, r = r_general);
        top();
    }
}

        
/* Elementos ordenados */


//base();
//bandeja();
//cuerpo();

//theta_compuerta = 268.5; //Acepta ángulos menores a 270°
//r_giro_compuerta = r_pines;
//x_offset = sqrt(r_giro_compuerta^2/(abs(1+tan(theta_compuerta)^2)));
//y_offset = tan(theta_compuerta)*x_offset;
//translate([x_offset+r_pines,y_offset,0])
//    rotate([0,0,theta_compuerta])
//        compuerta();

compuerta();
//top();
//tapa();


////Corte para pruebas de impresión
//difference(){
//    top();
//    translate([30,-100,h_base+h_bandeja+h_cuerpo])
//        cube([200,200,h_top]);
//    translate([-230,-100,h_base+h_bandeja+h_cuerpo])
//        cube([200,200,h_top]);
//    translate([-50,10,h_base+h_bandeja+h_cuerpo])
//        cube([100,200,h_top]);
//}


/* Elementos explotados */
//base();
//
//translate([0,0,40])
//    bandeja();
//    
//translate([0,0,60])
//    cuerpo();
//    
//translate([30,30,60]){
//    theta_compuerta = 265; //Acepta ángulos menores a 270°
//    r_giro_compuerta = r_pines;
//    x_offset = sqrt(r_giro_compuerta^2/(abs(1+tan(theta_compuerta)^2)));
//    y_offset = tan(theta_compuerta)*x_offset;
//    translate([x_offset+r_pines,y_offset,0])
//        rotate([0,0,theta_compuerta])
//            compuerta();
//}
//
//translate([0,0,100])
//    top();
//    
//translate([0,0,140])
//    tapa();

