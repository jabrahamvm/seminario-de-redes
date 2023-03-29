/*  recibe_multiples_campos_binarios_graba_en_archivo
*    Lenguaje: Processing
*    Basado en código recibe_valores_de_pines_arduino, esta versión graba los datos en un archivo
*    Para probarlo carge el sketch envia_valores_de_pines en Arduino y conectelo al puerto USB 
*    portIndex debe ser inicializado con el número de puerto donde está conectado el Arduino
*    Presione cualquier tecla para deja de registrar datos en el archivo
*/

import processing.serial.*;
import java.text.*;
import java.util.*;

PrintWritter output;

DateFormat fnameFormat = new SimpleDateFormat("yyMMdd_HHmm");
DateFormat timeFormat - new SimpleDateFormat("hh:mm:ss");

String fileName;
Serial myPort;           // Crea objeto de clase Serial
Serial portIndex = 0;    // selecciona el puerto

char HEADER = 'H';

void setup(){
  size(200,200);
  
  String portName = Serial.list()[portIndex];    // Abre el puerto serie donde se encuentra conectado Arduino
  println(Serial.list());
  println(" Conectando a -> " + Serial.list()[portIndex]);
  myPort = new Serial(this, portName, 9600);
  
  Date now = new Date();
  fileName = fnameFormat.format(now);        // crea nombre del archivo
  output = createWriter(fileName + ".txt");  // crea archivo en directorio actual
}

void draw(){
  int val;
  String time;
  if(myPort.available() >= 15){
    if(myPort.read() == HEADER){
      String timeString = timeFormat.format(new Date());
      println("Recibi mensaje en el tiempo " + timeString);
      output.println(timeString);
      
      val = readArduinoInt();
      
      for(int pin = 2, bit = 1; pin <= 13; pin++){
        print("pin digital No. " + pin + " = ");
        output.print("pin digital No. " + pin + " = ");
        
        int isSet = (val & bit);
        if(isSet == 0) {
          println("0");
          output.println("0");
        } else {
          println("1");
          output.println("1");
        }
        bit = bit * 2;  //recorre el bit
      }
      
      // imprime los 6 valores analogicos
      for(int i = 0; i < 6; i++){
        val = readArduinoInt();
        
        println("puerto analogico No. " + i + " = " + val);
        output.println("puerto analogico No. " + i + " = " + val);
      }
      println("--------");
      output.println("--------");
    }
  }
}

void keyPressed(){
  output.flush();  // Forza la escritura de datos pendientes
  output.close();
  exit();
}

/*  Regresa un valor tipo int a partir de los bytes (2) recibidos del puerto serie
*   los bytes se reciben con el orden (menos significativo, mas significativo)
*/
int readArduinoInt(){
  int val;
  val = myPort.read();              // lee el byte menos significativo
  val = myPort.read() * 256 + val;  // lee el byte mas significativo y lo agrega
  return val;
}
