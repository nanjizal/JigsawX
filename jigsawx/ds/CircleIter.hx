/*
* Copyright (c) 2012, Justinfront Ltd
*   author:  Justin L Mills
*   email:   JLM at Justinfront dot net
*   created: 17 June 2012
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the Justinfront Ltd nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
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


package jigsawx.ds;

enum Sign
{
    UP;
    DOWN;
}


class CircleIter 
{
    
    
    var begin:              Float;
    var fin:                Float;
    var step:               Float;
    var min:                Float;
    var max:                Float;
    var current:            Float;
    var onDirection:        Sign;
    
    
    public static function pi2(     begin_:     Float
                                ,   fin_:       Float
                                ,   step_:      Float 
                                )
    {
        
        return new CircleIter( begin_, fin_, step_, 0, 2*Math.PI );
        
    }
    
    
    public static function pi2pi(   begin_:     Float
                                ,   fin_:       Float
                                ,   step_:      Float
                                )
    {
        
        return new CircleIter( begin_, fin_, step_, -Math.PI, Math.PI );
        
    }
    
    
    public function new (   begin_:     Float
                        ,   fin_:       Float
                        ,   step_:      Float
                        ,   min_:       Float
                        ,   max_:       Float 
                        )
    {
        
        begin           = begin_;
        current         = begin;
        fin             = fin_;
        step            = step_;
        min             = min_;
        max             = max_;
        onDirection     = ( step > 0 )? UP: DOWN;
        
    }
    
    
    public function reset(): CircleIter
    {
        
        current = begin;
        return this;
        
    }
    
    
    public function hasNext(): Bool
    {
        
        switch onDirection
        {
            case UP:
                return ( ( current < fin && current + step > fin ) || current == fin )? false: true;
            
            case DOWN:
                return ( ( current > fin && (( current - step ) < fin) )|| current == fin )? false: true;
            
        }
        
    }
    
    
    public function next() 
    {
        
        current += step;
        
        switch onDirection
        {
            case UP:    if( current > max ) current = min + current - max;
            case DOWN:    if( current < min )    current = max + current - min;
        }
        
        if( !hasNext() ) return fin;
        
        return current;
        
    }
    
    
}
