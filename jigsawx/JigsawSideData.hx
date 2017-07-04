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


package jigsawx;


typedef JigsawPieceData = 
{
    var north:     JigsawSideData;
    var east:    JigsawSideData;
    var south:    JigsawSideData;
    var west:    JigsawSideData;
}

enum Bubble
{
    IN;
    OUT;
}


class JigsawSideData
{
    
    
    // if the nobble is IN OUT or null ( flat side )
    public var bubble:          Bubble;
    
    //offsets random multiplier
    public var squew:           Float;
    
    // inout random multiplier
    public var inout:           Float;
    
    //ellipse width and height random multiplier, drawn in the order left, centre, right
    public var leftWide:        Float;
    public var leftHi:          Float;
    public var centreWide:      Float;
    public var centreHi:        Float;
    public var rightWide:       Float;
    public var rightHi:         Float;
    
    
    
    // returns half a jigsawPieceData, the other side is populated from piece above and from left
    public static function halfPieceData(): JigsawPieceData
    {
        
        #if !noRandom return  { north: null, east: create(), south: create(), west: null };
        
        // Test use -D noRandom
        #else return  { north: null, east: createSimple(), south: createSimple(), west: null };
        #end
        
    }
    
    
    private static function createBubble(): Bubble 
    { 
        
        return ( Math.round( Math.random() ) == 1 )? IN: OUT; 
        
    }
    
    
    private static function swapBubble( bubble: Bubble ): Bubble
    {
        
        if( bubble == OUT ) return IN;
        if( bubble == IN ) return OUT;
        return null;
        
    }
    
    
    // reflect side
    public static function reflect( j: JigsawSideData ): JigsawSideData
    {
        
        var side            = new JigsawSideData();
        side.bubble         = swapBubble( j.bubble );
        
        //left right or up dawn offset.
        side.squew          = j.squew;
        
        // in out
        side.inout          = j.inout;
        
        // radii of ellipses
        side.leftWide       = j.rightWide;
        side.leftHi         = j.rightHi;
        side.centreWide     = j.centreWide;
        side.centreHi       = j.centreHi;
        side.rightWide      = j.leftWide;
        side.rightHi        = j.leftHi;
        
        return side;
        
    }
    
    
    // when you want to test no random.
    public static function createSimple(): JigsawSideData
    {
        
        var side            = new JigsawSideData();
        side.bubble         = createBubble();
        
        //left right or up dawn offset.
        side.squew          = 0.5;
        
        // in out
        side.inout          = 0.5;
        
        // radii of ellipses
        side.leftWide       = 0.5;
        side.leftHi         = 0.5;
        side.centreWide     = 0.5;
        side.centreHi       = 0.5;
        side.rightWide      = 0.5;
        side.rightHi        = 0.5;
        
        return side;
        
    }
    
    
    public static function create(): JigsawSideData
    {
        
        var side            = new JigsawSideData();
        side.bubble         = createBubble();
        
        //left right or up dawn offset.
        side.squew          = Math.random();
        // in out
        side.inout          = Math.random();
        // radii of ellipses
        side.leftWide       = Math.random();
        side.leftHi         = Math.random();
        side.centreWide     = Math.random();
        side.centreHi       = Math.random();
        side.rightWide      = Math.random();
        side.rightHi        = Math.random();
        
        return side;
        
    }
    
    // use create instead
    private function new(){}
    
}
