// patch
Blit s => ADSR e => JCRev r => dac;
.5 => s.gain;
0.01 => r.mix;

// set adsr
e.set( 0.01::ms, 0.01::ms, .01, 0.01::ms );


OscSend xmit;
xmit.setHost("localhost", 8080);

OscRecv recv;
8000 => recv.port;
recv.listen();

clear_all();

xmit.startMsg("/life/enc_enable", "ii");
0 => xmit.addInt;
1 => xmit.addInt;

recv.event("/life/press", ",iii") @=> OscEvent oe;
recv.event("/life/enc", "ii") @=> OscEvent enc;

int world[16][32][2];

int x,y,state,count,collect,i,rate,change;

float speed;

1600 => rate;
(0.05*rate/1000.0) => speed;

0 => i;
2 => collect;

while ( true ) 
{
	(i+ 1) % collect => i;
	if (i == 0)
	while ( oe.nextMsg() != 0 )
	{
		oe.getInt() => x;	
		oe.getInt() => y;
		oe.getInt() => state;

		if (state == 1) {
			1 => world[x][y][1];
		}
	}
	while ( enc.nextMsg() != 0 )
	{
		enc.getInt() => i;	
		enc.getInt() => change;

		rate + change => rate;
		if (rate<1000) 1000=>rate;
		//<<< "rate:", rate >>>;
		(0.05*rate/1000.0) => speed;
	}

	//clear_all();

	for(0 => x; x < 16; x++)
        for(0 => y; y < 32; y++) { 
		if (world[x][y][1] == 1 ) {
    	   	1 => world[x][y][0]; 
        	led_set(x,y,1);

		    Std.mtof( 50 + (y*10) + (x*2) ) => s.freq;
			y => s.harmonics;
		    e.keyOn();
    		1::ms => now;
    		e.keyOff();
        } 
      	if (world[x][y][1] == -1) {
  			0 => world[x][y][0];  
			led_set(x,y,0);      	
		}

		0 => world[x][y][1]; 
	}

	// Birth and death cycle 
	for (0=>x; x < 16; x++) { 
        for (0=>y; y < 32; y++) { 
      		neighbors(x, y) => count; 
      		if (count == 3 && world[x][y][0] == 0) 
      			1 => world[x][y][1]; 
      		if ((count < 2 || count > 3) && world[x][y][0] == 1) 
     		 	-1 => world[x][y][1];    
    	} 
  	} 

	speed::second => now;


}

// Add error checking in here somewhere.
fun void led_set(int x,int y,int s)
{
	xmit.startMsg("/life/led", "iii");
	x => xmit.addInt;
	y => xmit.addInt;
	s => xmit.addInt;
}

fun void clear_all()
{
	0 => int row;
	while (row < 16) {
		xmit.startMsg("/life/led_row", "iii");
		row => xmit.addInt;
		0 => xmit.addInt;
		0 => xmit.addInt;
		1 +=> row;
		0.005::second => now;
	}
}

// Count the number of adjacent cells 'on' 
fun int neighbors(int x, int y) 
{ 
  return world[(x + 1) % 16][y][0] + 
  world[x][(y + 1) % 32][0] + 
         world[(x + 16 - 1) % 16][y][0] + 
         world[x][(y + 32 - 1) % 32][0] + 
         world[(x + 1) % 16][(y + 1) % 32][0] + 
         world[(x + 16 - 1) % 16][(y + 1) % 32][0] + 
         world[(x + 16 - 1) % 16][(y + 32 - 1) % 32][0] + 
         world[(x + 1) % 16][(y + 32 - 1) % 32][0]; 
} 