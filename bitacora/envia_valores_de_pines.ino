/*  sketch envia_valores_de_pines
*   Envia valores de pines digitales y analogicos como datos binarios
*
*/

const char HEADER = 'H';

void setup(){
  Serial.begin(9600);
  for(int i = 2; i <= 13; i++){
    pinMode(i, INPUT);        // Configura los pines 2 al 13 como entradas
    digitalWrite(i, HIGH);    // activa los resistores pull-ups
  }
}

void loop(){
  Serial.write(HEADER);   // Envia la cabera
  int values = 0;
  int bit = 0;

  //recorre los pines del 2 al 13
  for(int i = 2; i <= 13; i++){
    bitWrite(values, bit, digitalRead(i));    // Guarda el valor (0 o 1) del pin en el bit asociado a el
    bit = bit + 1;                            // avanza al siguiente
  }
  sendBinary(values);                         // Envia el entero

  // recorre los pines analogicos
  for(int i = 0; i < 6; i++){
    values = analogRead(i);
    sendBinary(values);                       // Envia el valor leido
  }
  delay(1000); 
}

// Funcion para enviar un int por el puerto de serie
void sendBinary(int value){
  Serial.write(lowByte(value));               // Envia low byte
  Serial.write(highByte(value));              // Envia high byte
}