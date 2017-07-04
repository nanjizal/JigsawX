/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* created: 28 Dec 2012
* ported and update to haxe3: 2 April 2012
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* * Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
* * Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
* * Neither the name of the Justinfront Ltd nor the
* names of its contributors may be used to endorse or promote products
* derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY Justinfront Ltd ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Justinfront Ltd BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package utils;

enum UKweekDays
{    
    SUNDAY;
    MONDAY;
    TUESDAY;
    WEDNESDAY;
    THURSDAY;
    FRIDAY;
    SATURDAY;
}
enum UKmonths
{
    JANUARY;
    FEBRUARY;
    MARCH;
    APRIL;
    MAY;
    JUNE;	
    JULY;
    AUGUST;
    SEPTEMBER;
    OCTOBER;
    NOVEMBER;
    DECEMBER;
}

class CalendarMonthUtil
{
    
    public static inline var cols:  Int = 7;
    
    public var monthDays:           Int;
    public var dateInMonth:         Int;
    public var date:                Date;
    public var startOffset:         Int;
    
    public var rows:                Int;
    public var dayNo:               Int;
    public var currentMonth:        Int;
    public var monthBefore:         Int;
    public var monthAfter:          Int;
    public var currentMonthName:    String;
    public var monthBeforeName:     String;
    public var monthAfterName:      String;
    public var months:              Array<UKmonths>;
    public var weekDays:            Array<UKweekDays>;
    
    
	public function new( date_: Date )
	{
	    
		date = date_;
		
		months          = Type.allEnums( UKmonths );
		weekDays        = Type.allEnums( UKweekDays );
		
		update();
	    
	}
	
	public function monthOffset( no: Int )
	{
	    
	    date = new Date(    date.getFullYear()
                        ,   date.getMonth() + no
                        ,   date.getDay()
                        ,   date.getHours()
                        ,   date.getMinutes()
                        ,   date.getSeconds()
                        );
        update();
	    
	}
	
	public function next()
	{
	    date = new Date(    date.getFullYear()
                        ,   date.getMonth() + 1
                        ,   date.getDay()
                        ,   date.getHours()
                        ,   date.getMinutes()
                        ,   date.getSeconds()
                        );
        update();
	}
	
	public function previous()
	{
	    date = new Date(    date.getFullYear()
                        ,   date.getMonth()
                        ,   date.getDay()
                        ,   date.getHours()
                        ,   date.getMinutes()
                        ,   date.getSeconds()
                        );
        update();
	}
	
	public function update()
	{
	    
	    monthDays           = DateTools.getMonthDays( date );
	    dateInMonth         = date.getDate();
	    dayNo               = date.getDay();
	    var daysDifference  = dayNo;
        var defaultNameDay  = dateInMonth % cols;
        
	    if( defaultNameDay > dayNo )
	    {
	        daysDifference += cols;
	    }
	    
	    startOffset         = -( daysDifference - defaultNameDay - 1 );
        rows                = Math.ceil( (monthDays - startOffset + 1)/cols );
        
        currentMonth        = date.getMonth();
        monthBefore         = ( currentMonth == 0 )? 11: currentMonth - 1;
        monthAfter          = ( currentMonth == 11 )? 0: currentMonth + 1;  
        
        currentMonthName    = Std.string( months[ currentMonth ] );
        monthBeforeName     = Std.string( months[ monthBefore ] );
        monthAfterName      = Std.string( months[ monthAfter ] );
        
	}
    
}