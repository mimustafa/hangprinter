/* for 64 */
const float tans[65] = {0.0, 0.01227246237956628, 0.02454862210892544, 0.03683218099484564, 0.04912684976946725, 0.06143635258159376, 0.07376443152244928, 0.08611485119762791, 0.09849140335716425, 0.110897911595913, 0.1233382361367387, 0.1358162787093877, 0.1483359875383474, 0.1609013624534892, 0.1735164601378558, 0.1861853995275837, 0.198912367379658, 0.2117016240239833, 0.2245575093171293, 0.2374844488160702, 0.2504869601913055, 0.263569659899918, 0.2767372701404143, 0.2899946261126061, 0.3033466836073424, 0.3167985269526038, 0.330355377344334, 0.3440226015924263, 0.3578057213145241, 0.3717104226127435, 0.3857425662711212, 0.3999081985145372, 0.414213562373095, 0.4286651096994995, 0.4432695138908643, 0.4580336833706724, 0.4729647758913199, 0.4880702137228629, 0.5033576997992942, 0.5188352348999757, 0.5345111359507916, 0.5503940555372639, 0.566493002730344, 0.5828173653349761, 0.5993769336819237, 0.616181926094866, 0.6332430161775691, 0.6505713620801533, 0.6681786379192989, 0.6860770675448629, 0.7042794608650442, 0.7227992529642059, 0.7416505462720354, 0.7608481560702512, 0.7804076596539435, 0.8003454494993202, 0.8206787908286602, 0.8414258840072547, 0.8626059322567399, 0.8842392152253498, 0.906347169019147, 0.9289524733703675, 0.9520791467009252, 0.9757526499323765, 1.0};
const float cache[65] = {1.0, 1.000075303831095, 1.000301272041302, 1.000678074885643, 1.001205996470393, 1.001885435276175, 1.002716904892817, 1.003701034968476, 1.004838572376311, 1.006130382602739, 1.007577451362089, 1.009180886443291, 1.010941919795087, 1.012861909857108, 1.014942344145111, 1.017184842099628, 1.019591158208318, 1.022163185413362, 1.024902958816449, 1.027812659695079, 1.030894619845249, 1.034151326266982, 1.037585426210666, 1.041199732603783, 1.044997229879378, 1.048981080229448, 1.05315463030854, 1.057521418414975, 1.062085182179568, 1.066849866794267, 1.071819633815984, 1.076998870583968, 1.082392200292394, 1.088004492763556, 1.093840875971018, 1.099906748366472, 1.106207792068889, 1.112749986979771, 1.11953962589416, 1.126583330683404, 1.133888069632715, 1.141461176024291, 1.14931036806532, 1.157443770269642, 1.165869936412268, 1.174597874187579, 1.183637071714833, 1.192997526048913, 1.202689773870091, 1.212724924544292, 1.22311469576502, 1.233871452010141, 1.24500824607133, 1.256538863941542, 1.268477873376807, 1.280840676483328, 1.29364356671998, 1.306903790750257, 1.320639615627412, 1.334870401852683, 1.349616682910011, 1.364900251952839, 1.380744256400425, 1.397173301294458, 1.414213562373095};
const float divs[64] = {81.48324020654617, 81.45869897802326, 81.40963130369587, 81.33606674009614, 81.23804959976664, 81.11563892456739, 80.96890845011201, 80.79794656135175, 80.60285623933564, 80.38375499917866, 80.14077481927563, 79.87406206180044, 79.58377738454598, 79.27009564414729, 78.93320579075522, 78.57331075421982, 78.19062732185495, 77.78538600784995, 77.35783091441968, 76.90821958476502, 76.43682284793906, 75.94392465570959, 75.42982191151566, 74.89482429162886, 74.33925405860933, 73.76344586719139, 73.16774656269929, 72.55251497211843, 71.9181216879546, 71.26494884500138, 70.59338989015386, 69.90384934541692, 69.19674256423025, 68.47249548127898, 67.731544355924, 66.97433550941749, 66.20132505605467, 65.41297862842823, 64.60977109694736, 63.79218628379614, 62.96071667149342, 62.11586310624337, 61.25813449624342, 60.38804750513489, 59.50612624078624, 58.6129019395908, 57.70891264646706, 56.79470289076401, 55.87082335825257, 54.93783055941768, 53.99628649423485, 53.04675831364147, 52.08981797790978, 51.12604191211419, 50.15601065891911, 49.18030852888142, 48.19952324847784, 47.21424560608863, 46.22506909612424, 45.2325895615254, 44.2374048348529, 43.24011437817475, 42.241318921969, 41.24162010327328};

#define TAN_PI_8  0.414213562373095
#define TAN_PI_8_int  414

float tmp;
int i;
int first;
int last;
float c;
float delta_from_high;
float delta_from_low;
float lin_delta;

unsigned long int section0_start;
unsigned long int section0;
unsigned long int section1_start;
unsigned long int section1;

float return_gibberish(float x, float y){
  return y*(divs[1] - 15.0) + x*(1.1*y - c*cache[1]);
}

static unsigned int cache2[3] = {1000, 1082, 1414};
static unsigned int divs2[2] = {2414, 1707};
static unsigned int intx;
static unsigned int inty;
float taxi_approx2(float x, float y){
  //static float cache2[3] = {1.0, 1.08239220029239, 1.41421356237309};
  //static float divs2[2] = {2.41421356237309, 1.70710678118655};
  if(y > x){
    tmp = x;
    x = y;
    y = tmp;
  }
  intx = (unsigned int)(x);
  inty = (unsigned int)(y);
  intx *= 1000;
  inty *= 1000;

  if(y <= x*TAN_PI_8_int){
    c  = divs[0]*(tans[0]*x - y);
    return((x + c)*cache[0] - c*cache[1]);
  }
  c  = divs[1]*(tans[1]*x - y);
  return((float)(((x + c)*cache[1] - c*cache[2])/1000));
}


float taxi_approx64_delta(float x, float y){
  //section0_start = millis();
  /* Make x > y true */
  if(y > x){
    tmp = x;
    x = y;
    y = tmp;
  }
  /* Binary search. Should maybe be unrolled explicitly in Arduino...
   * Average number of binary-search-iterations is 6.0 (on the square testing grid)
   * Average number of linear-search-iterations is 36.0 (also on the square testing grid)
   * While form of binary search uses ca 8 operations per iteration?
   * Unrollong loop saves ca four operations per iteration?
   * (two assignments, one jmp and on stop criterion comparison)? */
  if(y <= x*tans[32]){
    first = 0;
    last = 32;
    i = 16;
  } else {
    first = 32;
    last = 64;
    i = 48;
  }
  for(;last - first != 1; i = (first + last) >> 1){
    if (y <= x*tans[i]){
      last = i;
    }else{
      first = i;
    }
  }

  //section0 += millis() - section0_start;
  //section1_start = millis();

  /* With this number, it's possible to make the optimal linear combination
   * of two cached values to get as close to sqrt(x*x + y*y) as possible */
  c  = divs[i]*(tans[i]*x - y);

  /** The linear compensation of the error **
   ** Don't really know if this is economical use of clock cycles
   ** compared to just adding more cached tans **/

  /* These variables could probably be saved in on to save clock cycles */
  //delta_from_high = (tans[i+1]*x - y);
  //delta_from_low  = (y - tans[i]*x);
  ///* These two ifs could be combined to sometimes save an assignment.
  // * Would look less clear though. */
  //if(delta_from_high < delta_from_low){
  //  lin_delta = delta_from_high;
  //}else{
  //  lin_delta = delta_from_low;
  //}
  ///* Giving the compensation a flat top to closer resemble
  // * the curve that we're really trying to compensate for */
  //if(lin_delta > 0.3*x*(tans[i+1] - tans[i])){
  //  lin_delta = 0.3*x*(tans[i+1] - tans[i]);
  //}

  // 0.0030531 found by trial and error (largest value with no negative error)
  //return((x + c)*cache[i] - c*cache[i+1] - 0.0030531*lin_delta);
  return((x + c)*cache[i] - c*cache[i+1]);
}

// Normalizes subnormal number
float norm2(float x){
  __asm__ volatile(
"1:	subi	r25, lo8(1)\n\t"
"	sbci	r21, hi8(1)\n\t"
"	lsl	r22\n\t"
"	rol	r23\n\t"
"	rol	r25\n\t"
"	brpl	1b\n\t"
"	ret\n\t"
  );
}

float rough_square(float x){
  __asm__ volatile(
// contents of square.S
"   movw	r18, r22\n\t"
"   movw	r20, r24\n\t" // B = A
// fp_split3 starts here
"   sbrc	r21, 7\n\t"
"   subi	r25, 0x80\n\t"
//  split B
"   lsl	r20\n\t"
"   rol	r21\n\t" //	; exponent
//"   breq	4f\n\t" // TODO: Handle these like then0 else0 was handeled for A
"   cpi	r21, 0xff\n\t" // C = 1, if r21 != 0xff
//"   breq	5f\n\t"
"1:	ror	r20\n\t" //	restore rB2 and (possible) hidden bit
// entry of fp_splitA
" 	lsl	r24\n\t"
" 	rol	r25\n\t" // kick sign bit out. Arguments always positive
" 	cpi	r25, 0xff\n\t"
" 	breq	.then0\n\t"
"   ror	r24\n\t"
"   rjmp .else0\n\t"
".then0:\n\t"
"  lsr	r24\n\t"
".else0:\n\t"
// fp_split3 ends here


// rB3.rA3 := rA3 + rB3
"   add	r25, r21\n\t"
"   ldi	r21, 0\n\t"
"   adc	r21, r21\n\t"

//  multiplication:  r24.r23.r22 * r20.r19.r18  -->  r24.r23.r22.r27.r31.r30
//  r31.r30 = r22 * r18
" 	mul	r22, r18\n\t"
" 	movw	r30, r0\n\t"
//  r27.r31 += r23 * r18
" 	mul	r23, r18\n\t"
" 	clr	r27\n\t"
" 	add	r31, r0\n\t"
" 	adc	r27, r1\n\t"
//  r26.r27.r31 = r27.r31 + r22 * r19
" 	mul	r22, r19\n\t"
" 	clr	r26\n\t"
" 	add	r31, r0\n\t"
" 	adc	r27, r1\n\t"
" 	adc	r26, r26\n\t"
//  r22.r26.r27 = r26.r27 + r22 * r20
" 	mul	r22, r20\n\t"
" 	clr	r22\n\t"
" 	add	r27, r0\n\t"
" 	adc	r26, r1\n\t"
" 	adc	r22, r22\n\t"
//  r22.r26.r27 += r24 * r18
" 	mul	r24, r18\n\t"
" 	clr	r18\n\t"
" 	add	r27, r0\n\t"
" 	adc	r26, r1\n\t"
" 	adc	r22, r18\n\t"
//  r22.r26.r27 += r23 * r19
" 	mul	r23, r19\n\t"
" 	add	r27, r0\n\t"
" 	adc	r26, r1\n\t"
" 	adc	r22, r18\n\t" // r18 == 0
//  r18.r22.r26 = r22.r26 + r24 * r19
" 	mul	r24, r19\n\t"
" 	add	r26, r0\n\t"
" 	adc	r22, r1\n\t"
" 	adc	r18, r18\n\t" // r18 was 0
//  r18.r22.r26 += r23 * r20
" 	mul	r23, r20\n\t"
" 	clr	r19\n\t"
" 	add	r26, r0\n\t"
" 	adc	r22, r1\n\t"
" 	adc	r18, r19\n\t"
//  r18.r22 += r24 * r20
" 	mul	r24, r20\n\t"
" 	add	r22, r0\n\t"
" 	adc	r18, r1\n\t"
//  move result:  r24.r23.r22.r27.r31.r30 = r18.r22.r26.r27.r31.r30
" 	mov	r24, r18\n\t"
" 	mov	r23, r22\n\t"
" 	mov	r22, r26\n\t"
//  __zero_reg__
" 	clr	r1\n\t"

//  exponent -= 127	(Why not 126?  For compare conviniency.)
" 	subi	r25, lo8(127)\n\t"
" 	sbci	r21, hi8(127)\n\t"

" 10:	tst	r24\n\t"
" 	brmi	11f\n\t"	// mantissa is normal
//  mantissa <<= 1"
" 	lsl	r30\n\t"
" 	rol	r31\n\t"
" 	rol	r27\n\t"
" 	rol	r22\n\t"
" 	rol	r23\n\t"
" 	rol	r24\n\t"
//  exponent -= 1
" 	subi	r25, lo8(1)\n\t"
" 	sbci	r21, hi8(1)\n\t"
" 	brne	10b\n\t"
//  check to overflow
" 11:	cpi	r25, 254\n\t"
" 	cpc	r21, r1\n\t"
//" 	brlo	15f\n\t"
//" 	rjmp	_U(__fp_inf)\n\t"
//  check lowest value of exponent to avoid long operation
//" 12:	rjmp	_U(__fp_szero)\n\t"
" 13:	cpi	r21, hi8(-24)\n\t" // here r21 < 0
//" 	brlt	12b\n\t"
" 	cpi	r25, lo8(-24)\n\t"
//" 	brlt	12b\n\t"
//  mantissa >>= -r25
" 14:	lsr	r24\n\t"
" 	ror	r23\n\t"
" 	ror	r22\n\t"
" 	ror	r27\n\t"
" 	ror	r31\n\t"
" 	ror	r30\n\t"
" 	subi	r25, -1\n\t"
" 	brne	14b\n\t"
//  for rounding
" 15:	or	r31, r30\n\t"
//  pack
" 	lsl	r24\n\t"
" 	adc	r25, r1\n\t"	// restore exponent for normal values
" 	lsr	r25\n\t"
" 	ror	r24\n\t"
" 	bld	r25, 7\n\t" // sign
" 	ret\n\t"
);
}


/* A less safe sqrt (doesn't handle sqrt, negatives, NaN or Inf)
 * works on atmega2560 */
float sqrt2(float x){
  //volatile register int val __asm__("r0");

  __asm__ volatile(
                  "#define rB0 r18\n\t"
                  "#define rB1 r19\n\t"
                  "#define rB2 r20\n\t"
                  "#define rB3 r21\n\t"
                  "#define rA0 r22\n\t"
                  "#define rA1 r23\n\t"
                  "#define rA2 r24\n\t"
                  "#define rA3 r25\n\t"
                  "#define rBE r26\n\t"
                  "#define rAE r26\n\t"
                  // ZL = r30
                  // ZH = r31

                   // r21 is return exponent
                   // Return manitssa: r20.r19.r18
                   //"	call	__fp_splitA \n\t"
	                 "  lsl	r24\n\t"
                   //"  bst	r25, 7\n\t"
	                 "  rol	r25\n\t" // kick sign bit out. Arguments to sqrt2 always positive
	                 "  cpi	r25, 0xff\n\t"
	                 "  breq	.then\n\t"
                   "  ror	r24\n\t"
                   "  rjmp .else\n\t"
                   ".then:\n\t"
                   "  lsr	r24\n\t"

// if cpi then lsr r24 else ror r24
                   //".fp_hack_2:\n\t"
                   //"  lsr	r24\n\t"
                   //"rjmp .back"





                   ".else:\n\t"
                   "	subi	r25, 127\n\t"
                   //"	sbc	r21, r21\n\t" // Not needed it seems? r21 not used
                   "	clr	r0\n\t"
                   "	ldi	r26, 0x60\n\t" // First guess exponent of sqrt(mantissa(r24.r23.r22), exponent(r25))? Rotation mask, what is that?
                   "	ldi	r20, 0xa0\n\t"
                   //"	movw	r18, r0\n\t"
                   "	mov	r19, r1\n\t"

                   "	subi	r24, 0x80\n\t"
                   //"	lsr	r21\n\t" // Not needed either?
                   "	ror	r25\n\t"
                   "	brcc	1f\n\t"
                   "	subi	r24, lo8(-0x40)\n\t"

                   ".Loop:\n\t"
                   //"  lsl	r22\n\t"
                   "	lsl	r23\n\t"
                   "	rol	r24\n\t"
                   "	brcs	2f\n\t"
                   //"1: cp	r18, r22\n\t"
                   "1:	cp	r19, r23\n\t"
                   "	cpc	r20, r24\n\t"
                   "	brcc	3f\n\t"
                   //"2:	sub	r22, r18\n\t"
                   "2:	sub	r23, r19\n\t"
                   "	sbc	r24, r20\n\t"
                   //"	or	r18, r0\n\t"
                   "	or	r19, r1\n\t"
                   "	or	r20, r26\n\t"
                   "3:	lsr	r26\n\t"
                   "	ror	r1\n\t"
                   "	ror	r0\n\t"
                   //"	eor	r18, r0\n\t"
                   "	eor	r19, r1\n\t"
                   "	eor	r20, r26\n\t"
                   "	brcc	.Loop\n\t"

                   //".Loop1:\n\t"
                   ////"  lsl	r22\n\t"
                   //"	lsl	r23\n\t"
                   //"	rol	r24\n\t"
                   //"	brcs	4f\n\t"
                   ////"	cp	r18, r22\n\t"
                   //"	cp	r19, r23\n\t"
                   //"	cpc	r20, r24\n\t"
                   //"	brcc	5f\n\t"
                   ////"4:	sbc	r22, r18\n\t"
                   //"4:	sbc	r23, r19\n\t"
                   //"	sbc	r24, r20\n\t"
                   ////"	add	r18, r0\n\t"
                   //"	add	r19, r1\n\t"
                   //"	adc	r20, r1\n\t"
                   //"5:	com	r26\n\t"
                   //"	brne	.Loop1\n\t"

                   //"	movw	r22, r18\n\t"
                   "  ldi r22, 170\n\t"
                   "	mov	r23, r19\n\t"
                   "	mov	r24, r20\n\t"

                   "	subi	r25, lo8(-127)\n\t"
                   "	lsl	r24\n\t"
                   "	lsr	r25\n\t"
                   "	ror	r24\n\t"
                   "	ret\n\t"

                   );
  // For printing contents of two registers...
  //int val2 = val;
  //Serial.print("r0: ");
  //Serial.println(val2 & 0x00FF, BIN);
  //Serial.print("r1: ");
  //Serial.println((val2 & 0xFF00) >> 8, BIN);
  //return 1.0;
}

float float_div2(float a){
  __asm__ volatile("	call	__fp_splitA \n\t"
                   "	ldi	r18, 1\n\t"
                   "	ldi	r19, 255\n\t"
                   "	ldi	r20, 1\n\t"
                   "	ldi	r21, 1\n\t"
                   "	ldi	r22, 1\n\t"
                   "	ldi	r23, 1\n\t"
                   "	ldi	r24, 1\n\t"
                   "	ldi	r25, 1\n\t"
                   "  ret\n\t"
                   );
}

// Fixed point iteration using previous result as initial guess
// l holds previous found length and squared length (exact through x*x + y*y, not through l[0]*l[0])
// Never returns...
void sqrt3( float l[2], float x, float y){
  float diff;
  // old squared length - new squared length
  //diff = l[1];
  l[1] = x*x + y*y;
  //diff -= l[1];
  // fixed point iteration
  do{
    diff = l[0]*l[0] - l[1];
    l[0] = l[0] - diff;
  }while(fabs(diff) > 0.01);
}

float sqrt4(float x, float y){
  float tmp;
  x = fabs(x);
  y = fabs(y);
  if(y>x){
    tmp = x;
    x = y;
    y = tmp;
  }
  return x + y/2;
}

void setup(){
  Serial.begin(9600);
  delay(100); // Wait 50 microseconds for serial initialization
  Serial.println("Benchmarking vector length functions...");
}

void print_reg_value(){
  volatile register int val __asm__("r22");
  __asm__ volatile("ldi r22, 0b10011111\n\t");
  __asm__ volatile("ldi r23, 0b11111111\n\t");
  short val2 = val;
  Serial.print("r22: ");
  Serial.println(val2 & 0x00FF, BIN);
  Serial.print("r23: ");
  Serial.println((val2 & 0xFF00) >> 8, BIN);
}

void loop(){
  float a = 11111111.0;
  Serial.println(rough_square(a), 16);
  delay(2000);
}


void loop0(){
  unsigned long start, time0, time1, looptime;
  volatile float result = 999.9;
  float x, y;
  //float l[2] = { 999.9, 0 };

  float STEP = 3.3;
  float STARTLENGTH = 1000.0;
  float STOPLENGTH = 2200.0;


  start = millis();
  for(x = STARTLENGTH; x < STOPLENGTH; x += STEP){
    for(y = STARTLENGTH; y < STOPLENGTH; y += STEP){
      __asm__ volatile("");
      result = x*x + y*y;
    }
  }
  looptime = millis() - start;
  Serial.print("looptime is  ");
  Serial.println(looptime);


  start = millis();
  for(x = STARTLENGTH; x < STOPLENGTH; x += STEP){
    for(y = STARTLENGTH; y < STOPLENGTH; y += STEP){
      result=sqrt(x*x + y*y);
    }
  }
  time0 = millis() - start;
  Serial.print("sqrt(x*x+y*y) took  ");
  Serial.println(time0 - looptime);

  //start = millis();
  //for(x = STARTLENGTH; x < STOPLENGTH; x += STEP){
  //  for(y = STARTLENGTH; y < STOPLENGTH; y += STEP){
  //    result=sqrt4(x, y);
  //  }
  //}
  //time = millis() - start;
  //Serial.print("sqrt4(x,y) took ");
  //Serial.println(time);


  //start = millis();
  //for(x = STARTLENGTH; x < STOPLENGTH; x += STEP){
  //  for(y = STARTLENGTH; y < STOPLENGTH; y += STEP){
  //    __asm__ volatile("");
  //    sqrt3(l, x, y);
  //  }
  //}
  //time = millis() - start;
  //Serial.print("sqrt3(x*x+y*y) took ");
  //Serial.println(time);

  start = millis();
  for(x = STARTLENGTH; x < STOPLENGTH; x += STEP){
    for(y = STARTLENGTH; y < STOPLENGTH; y += STEP){
      result=sqrt2(x*x + y*y);
    }
  }
  time1 = millis() - start;
  Serial.print("sqrt2(x*x+y*y) took ");
  Serial.println(time1 - looptime);


  Serial.print("improvement is ");
  Serial.println(1.0 - (float)(time1 - looptime)/(float)(time0 - looptime),5);

  float max_err = 0.0;
  float err;
  result = 999.9;
  for(x = STARTLENGTH; x < STOPLENGTH; x += STEP){
    for(y = STARTLENGTH; y < STOPLENGTH; y += STEP){
      err = fabs(sqrt(x*x+y*y) - sqrt2(x*x + y*y));
      //err = fabs(sqrt(x*x+y*y) - norm2(x));
//      if(err != 0.0) {
//        Serial.println("We have a difference");
//        return;
//      }
      if(err > max_err) max_err = err;
    }
  }
  Serial.print("max_err: ");
  Serial.println(max_err,10);
  Serial.println("");
  return;
}
