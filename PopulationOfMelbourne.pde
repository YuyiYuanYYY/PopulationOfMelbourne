Table table;

PFont myFont;
PImage sun;
PImage moon;

int myrow;
double hour;
double hour1;

//double h_r, h_g, h_b;

String year;
String month;
String day;
String date;

float[] days;
float hour_num;
float Sum_pop;
float[] angles;
float lastAngle;
float[] hours;
float[] hours_pop;

float[] Fdays;
float[] Fangles;
float FlastAngle;
float Fsum_pop;
float[] Wdays;
float[] Wangles;
float WlastAngle;
float Wsum_pop;

//the center of the main pie chart
int pie_x, pie_y;

int F_x, F_y;
int W_x, W_y;

void setup(){
  size(2500, 1500);
  
  //read csv files
  table = loadTable("2012_030405-HOUR.CSV", "header");
  
  //set font
  myFont = createFont("Microsoft YaHei", 20);
  textFont(myFont);
  
  //load img
  sun = loadImage("sun.png");
  //moon = loadImage("moon.png");
  
  //set frameRate
  frameRate(10);
  
  myrow=0;
  hour=0;
  hour1=0;
  
  //h_r=140/11;
  //h_g=114/11;
  //h_b=102/11; 
  
  days = new float[7];
  hour_num=0;
  Sum_pop=0;
  angles = new float[7];
  lastAngle=0;
  hours = new float[24];
  hours_pop = new float[24];
  
  Fdays = new float[7];
  Fangles = new float[7];
  FlastAngle=0;
  Fsum_pop=0;
  
  Wdays = new float[7];
  Wangles = new float[7];
  WlastAngle=0;
  Wsum_pop=0;
  
  pie_x=0;
  pie_y=0;
  
  F_x=0;
  F_y=0;
  
  W_x=0;
  W_y=0;
  
  noLoop();
}

void draw(){  
  //caculate the color of background
  //day RGB:236,239,241
  //night RGB:96,125,139
  
  //hour = sin(radians(table.getFloat(myrow,6)/23*180));  
  //background(96+(int)(h_r*hour), 125+(int)(h_g*hour), 139+(int)(h_b*hour));
  background(120,144,156);
    
  //Iterate over each row of data
  if(myrow<table.getRowCount()){
    hour_num = 0;
    
    //Iterate over each column of data
    for(int d=7; d<table.getColumnCount(); d++){
      //count the number of people (per hour)
      hour_num += table.getInt(myrow,d);      
           
      //print cities' name
      textAlign(RIGHT);
      textSize(20);
      //set the text color
      textColor(d);
      text(table.getColumnTitle(d), 300, (d-6)*50); 
            
      //draw population bar chart
      noStroke();
      rect(310, 28+(d-7)*50, table.getFloat(myrow,d)/8, 25, 10);
      
      //print population number
      fill(38,50,56);
      text(table.getInt(myrow,d), 310+table.getFloat(myrow,d)/8000*1200+45, (d-6)*50); 
            
      //print date text
      year = table.getString(myrow, 1);
      month = table.getString(myrow, 2);
      day = table.getString(myrow, 3);
      date = year+"-"+month+"-"+day+"     "+table.getString(myrow, 6)+" o'clock";
      textSize(72);
      textAlign(LEFT);
      text(date, 1450, 910);   
      
      //draw the sun time line
      line(1970, 920, 2450, 920);
      if(table.getInt(myrow,6)>=6 && table.getInt(myrow,6)<18){
        hour1 = sin(radians((table.getFloat(myrow,6)-6)/12*180));
      }
      else{
        hour1 = 0;
      }
      image(sun, 1810+(int)(470*(table.getFloat(myrow,6)-6)/12), 920-(int)(150*hour1), (int)(70*hour1), (int)(70*hour1));  
      
      //draw line chart scale
      stroke(69,90,100);
      strokeWeight(4);
      line(119, 1420, 119, 950);
      line(119, 950, 114, 958);
      line(119, 950, 124, 958);      
      line(119, 1420, 2450, 1420);
      line(2450, 1420, 2442, 1415);
      line(2450, 1420, 2442, 1425); 
      
      //x-axis represents time
      textSize(25);
      for(int i = 0; i<24; i++){
        line(119+i*97, 1420, 119+i*97, 1410);
        text(Integer.toString(i), 112+i*97, 1446);        
      }
      text("O'clock", 2400, 1450);
      
      //y-axis represents the number of people
      textAlign(RIGHT);
      for(int i = 0; i < 6; i++){
        line(119, 1420-90*i, 129, 1420-90*i);
        text(Integer.toString(6000*i), 110, 1430-90*i);
      }
      textAlign(LEFT);
      text("Human Traffic", 33, 935);     
    }
    
    //add up the number of people in Flagstaff Station
    Fdays[table.getInt(myrow,5)-1] += table.getInt(myrow, 13);
    Fsum_pop += table.getInt(myrow, 13);
      
    //add up the number of people in Waterfront City
    Wdays[table.getInt(myrow,5)-1] += table.getInt(myrow, 19);
    Wsum_pop += table.getInt(myrow, 19);
  }
  
  //all the calculate process
  Sum_pop += hour_num;//add up all the people
  days[table.getInt(myrow,5)-1] += hour_num;//add up the number of people each weekday
  hours[table.getInt(myrow,6)] += hour_num;//add up the number of people each hour
    
  //calculate the average number of people each hour
  hours_pop[table.getInt(myrow,6)] = (hours[table.getInt(myrow,6)]/((int)(myrow/24)+1))/30000;
  
  //calculate each pie chart angle
  for(int i = 0; i < 7; i++){
    angles[i] = radians((days[i]/Sum_pop)*360);
    Fangles[i] = radians((Fdays[i]/Fsum_pop)*360);
    Wangles[i] = radians((Wdays[i]/Wsum_pop)*360);
  }  
    
  //print weekdays
  textSize(25);
  text("Monday", 1510, 695);
  text("Tuesday", 1510, 735);
  text("Wednesday", 1510, 775);
  text("Thursday", 1510, 815);
  text("Friday", 1740, 695);
  text("Saturday", 1740, 735);
  text("Sunday", 1740, 775);
  
  textSize(30);
  stroke(2);
  text("Melbourne's Weekly Traffic Distribution", 1400, 630);
  
  textSize(25);
  text("Flagstaff Station's Weekly Traffic Distribution", 1940, 380);
  text("Waterfront City's Weekly Traffic Distribution", 1945, 760);
  
  //draw pie chart
  pie_x=1660;
  pie_y=310;
  
  F_x=W_x=2232;
  F_y=180;
  W_y=560;
  noStroke();
  for(int i = 0; i < 7; i++){
    //draw the main pie chart
    float pie_color_r = map(i, 0, 7, 1, 225);
    float pie_color_g = map(i, 0, 7, 87, 245);
    float pie_color_b = map(i, 0, 7, 155, 254);
    float pie_r = map(i, 0, 7, 480, 600);
    fill(pie_color_r, pie_color_g, pie_color_b);
    arc(pie_x, pie_y, pie_r, pie_r, lastAngle, lastAngle+angles[i]);
    rect(1470+230*(int)(i/4), 670+(int)(i%4)*40, 30, 30, 10);
    lastAngle += angles[i];
    
    //draw the Flagstaff Station pie chart
    float FW_r = map(i, 0, 7, 240, 310);
    arc(F_x, F_y, FW_r, FW_r, FlastAngle, FlastAngle+Fangles[i]);
    FlastAngle += Fangles[i];
    
    //draw the Waterfront City pie chart
    arc(W_x, W_y, FW_r, FW_r, WlastAngle, WlastAngle+Wangles[i]);
    WlastAngle += Wangles[i];
  }
    
  //draw line chart  
  fill(255,165,0,180);
  
  //draw 0o'clock point
  ellipse(119, 1420-450*hours_pop[0], hours_pop[0]*150, hours_pop[0]*150);
  
  for(int i = 1; i < 24; i++){
    //draw each time line
    stroke(244,164,96);
    strokeWeight(3);
    line(119+(i-1)*97, 1420-450*hours_pop[i-1], 119+i*97, 1420-450*hours_pop[i]);
    
    //draw each point
    noStroke();
    fill(255,165,0,180);
    ellipse(119+i*97, 1420-450*hours_pop[i], hours_pop[i]*150, hours_pop[i]*150);
  }
  
  myrow++;
}

void textColor(int n){
  switch(n){
    case 7:
    fill(244,67,54);
    break;
    case 8:
    fill(156,39,176);
    break;
    case 9:
    fill(63,81,181);
    break;
    case 10:
    fill(3,169,244);
    break;
    case 11:
    fill(0,150,136);
    break;
    case 12:
    fill(139,195,74);
    break;
    case 13:
    fill(255,235,59);
    break;
    case 14:
    fill(255,152,0);
    break;
    case 15:
    fill(121,85,72);
    break;
    case 16:
    fill(176,190,197);
    break;
    case 17:
    fill(233,30,99);
    break;
    case 18:
    fill(103,58,183);
    break;
    case 19:
    fill(33,150,243);
    break;
    case 20:
    fill(0,188,212);
    break;
    case 21:
    fill(76,175,80);
    break;
    case 22:
    fill(192,202,51);
    break;
    case 23:
    fill(255,193,7);
    break;
    case 24:
    fill(244,81,30);
    break;
    default:
    fill(244,67,54);
    break;
  }
}

void mouseClicked(){
  //terminate the loop
  if(looping){
    noLoop();
  }
  else{
    loop();
  }
}
