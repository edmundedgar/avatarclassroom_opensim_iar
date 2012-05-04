/*
*  HOT_FLOOR
*  Part of the Sloodle project (www.sloodle.org)
*  Copyright (c) 2011-06 contributors (see below)
*  Released under the GNU GPL v3
*  -------------------------------------------
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*  All scripts must maintain this copyrite information, including the contributer information listed
*
*  Contributors:
*  Paul Preibisch
*
*  DESCRIPTION
*  Purpose of this script is to bounce people out of the pool when floor is "active".  The floor is set to "active" (HOT) when
*  the doors of the pool closed by the owner.
*/
integer HOTFLOOR;
integer ON=1;
integer OFF=0;
string CLOSE_DOORS="p1";

integer SLOODLE_HOT_FLOOR_ON=-1639271142;//used to for shark pool HOT FLOOR
integer SLOODLE_HOT_FLOOR_OFF=-1639271143;//used to for shark pool HOT FLOOR
/** SND_SPLASH http://www.freesound.org/people/Dynamicell/sounds/17832/ | http://creativecommons.org/licenses/sampling+/1.0/ **/
string SND_SPLASH1="SND_SPLASH1";
string SND_SPLASH2="SND_SPLASH2";
string SND_SPLASH3="SND_SPLASH3";
string SND_SPLASH4="SND_SPLASH4";
string SND_SPLASH5="SND_SPLASH5";
list SPLASHES;
integer SNDCOUNTER=0;
integer SNDCOUNTER2=0;

 getSplashSnd(){
//llSay(0,(string)(SNDCOUNTER2%5));    
     if (SNDCOUNTER2%15==0){
        string snd=llList2String(SPLASHES,SNDCOUNTER++);
        if (SNDCOUNTER>4) SNDCOUNTER=0;    
         llTriggerSound(snd, 1);
  
      }
     SNDCOUNTER2++;
    
}
integer thisTime;
integer lastTime;
default {
    state_entry() {
        SPLASHES=[SND_SPLASH1,SND_SPLASH2,SND_SPLASH3,SND_SPLASH4,SND_SPLASH5];        
        HOTFLOOR=OFF;
        getSplashSnd();
        lastTime=0;
    }
    link_message(integer sender_num, integer num, string str, key id) {
        if (num==SLOODLE_HOT_FLOOR_ON){
            HOTFLOOR=ON;
            llSay(0,"hotfloor on");
            llSensor("", "", AGENT, 5, TWO_PI);
        }else
        if (num==SLOODLE_HOT_FLOOR_OFF){
            HOTFLOOR=OFF;
        }
    }
    sensor(integer num_detected) {
        if(HOTFLOOR!=ON)return;
        integer i=0; 
        key av;
       
        for (i=0;i<num_detected;i++){ 
          
            
            
            av=llDetectedKey(i); 
            llPushObject(av, <0,0,1000>, <0,1440,90>, TRUE);
               
        }
       
        
      
    }
    collision(integer num_detected) { 
          getSplashSnd();
        if(HOTFLOOR!=ON)return;
        integer i=0; 
        key av;
 thisTime=llGetUnixTime();
     
        for (i=0;i<num_detected;i++){ 
              if ((thisTime-lastTime)>20){
                
                llTriggerSound("SND_YEEHA", 1);
            }
            
            av=llDetectedKey(i); 
            llPushObject(av, <0,0,1000>, <0,1440,90>, TRUE);
           
        } 
     
        lastTime=thisTime;
     
        llSetTimerEvent(3);
        
         
    } 
    timer() {
        llSetTimerEvent(0);
        llMessageLinked(LINK_SET, -399, CLOSE_DOORS, NULL_KEY);
        HOTFLOOR=OFF;
    }
    
}
