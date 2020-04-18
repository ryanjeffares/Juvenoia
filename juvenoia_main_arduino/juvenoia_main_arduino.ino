// Analog pins
int pot1 = 0;
int pot2 = 1;
int softpot = 2;
int button1 = 2;
int button2 = 3;

// Value IDs (must be between 128 and 255)
byte pot1ID = 128;
byte pot2ID = 129;
byte softpotID = 132;
byte button1ID = 130;
byte button2ID = 131;

// Value to toggle between inputs
int select;

/*
** Two functions that handles serial send of numbers of varying length
*/

// Recursiv function that sends the bytes in the right order
void serial_send_recursiv(int number, int bytePart)
{
  if (number < 128) {        // End of recursion
    Serial.write(bytePart);  // Send the number of bytes first
  }
  else {    
    serial_send_recursiv((number >> 7), (bytePart + 1));
  }
  Serial.write(number % 128);  // Sends one byte
}

void serial_send(byte id, int number)
{
  Serial.write(id);
  serial_send_recursiv(number, 1);
}

void setup()  {
  // enable serial communication
  Serial.begin(9600);  
  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
}

void loop()  
{
  // Only do something if we received something (this should be at csound's k-rate)
  if (Serial.available())
  {
      // Read the value (to empty the buffer)
       int csound_val = Serial.read();
       
       // Read one value at the time (determined by the select variable)
       switch (select) {
         case 0: {
           int pot1Val = analogRead(pot1);
           serial_send(pot1ID, pot1Val);           
         }
         break;
         case 1: {
           int pot2Val = analogRead(pot2);
           serial_send(pot2ID, pot2Val);
         }
         break;
         case 2: {
          int button1Val = digitalRead(button1);
          serial_send(button1ID, button1Val);
         }
         break;
         case 3: {
          int button2Val = digitalRead(button2);
          serial_send(button2ID, button2Val);            
         }
         break;
         case 4: {
          int softpotVal = analogRead(softpot);
          serial_send(softpotID, softpotVal);
         }
       }

       // Update the select (0, 1 and 2)
       select = (select+1)%5;
  }    
}
