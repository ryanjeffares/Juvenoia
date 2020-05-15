// Analog pins
int pot1 = 0;
int pot2 = 1;
int pot3 = 2;

// Digital pins
const int button1 = 2;
const int button2 = 3;
const int toggle = 4;

// Value IDs (must be between 128 and 255)
byte pot1ID = 128;
byte pot2ID = 129;
byte pot3ID = 132;
byte button1ID = 130;
byte button2ID = 131;
byte toggleID = 133;

// Value to toggle between inputs
int select;

/*
** Two functions that handles serial send of numbers of varying length
*/

// Recursiv function that sends the bytes in the right order
void serial_send_recursiv(int number, int bytePart)
{
  if (number < 128) {        // If our value is 7 bit or less, no unique identifying is required, so we send over the 1 to make our loop in Csound run
    Serial.write(bytePart);  // Send the number of bytes first
  }
  else {    
    serial_send_recursiv((number >> 7), (bytePart + 1)); // If the value needs to be uniquely identified, run it through the function again, bitshifted into a readable byte range, and make the loop run twice
  }
  Serial.write(number % 128);  // Sends one byte
}

void serial_send(byte id, int number)
{
  Serial.write(id);   // Send over the value ID so Csound can sort the next value
  serial_send_recursiv(number, 1);  // Call the recursive function with the sensor value and a 1
}

// This function runs once when the Arduino powers up
void setup()  {
  // enable serial communication
  Serial.begin(9600);  
  // Declare the digital pins as inputs
  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
  pinMode(toggle, INPUT);
}

// This function loops forever and ever...
void loop()  
{
  // Only do something if we received something (this should be at csound's k-rate)
  if (Serial.available())
  {
      // Read the value (to empty the buffer)
       int csound_val = Serial.read();
       
       // Read one value at the time (determined by the select variable) and call the first serial send function
       switch (select) {
         case 0: {
           int pot1Val = analogRead(pot1);
           serial_send(pot1ID, pot1Val);           
           break;
         }
         case 1: {
           int pot2Val = analogRead(pot2);
           serial_send(pot2ID, pot2Val);
           break; 
         }
         case 2: {
          int button1Val = digitalRead(button1);
          serial_send(button1ID, button1Val);
          break;
         }
         case 3: {
          int button2Val = digitalRead(button2);
          serial_send(button2ID, button2Val);            
          break;  
         }
         case 4: {
          int pot3Val = analogRead(pot3);
          serial_send(pot3ID, pot3Val);
          break;
         }
         case 5: {
          int toggleVal = digitalRead(toggle);
          serial_send(toggleID, toggleVal);
          break;
         }
       }

       // Update the select
       select = (select+1)%6;
  }    
}

// keep Csound’s k rate high enough to allow for five bytes to be sent over serial:
//the trigger from Csound, ID, length, value 1, and value 2. For 10 bit integers,
//this can be calculated by dividing five of these bytes by the baud rate of 9600,
//so 50/9600 which is about 5.2 milliseconds. At a k-rate of 256 at a sample rate of 44100 kHz,
//a k-cycle happens every 5.8 milliseconds (256/44100), so this allows enough time to read all the bytes necessary.
