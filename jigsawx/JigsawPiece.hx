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

import jigsawx.JigsawSideData;
import jigsawx.math.Vec2;
import jigsawx.JigsawMagicNumbers;

enum Compass
{
    NORTH;
    SOUTH;
    EAST;
    WEST;
}


class JigsawPiece
{
    
    
    public var enabled:                 Bool;
    private var curveBuilder:           OpenEllipse;
    private var stepAngle:              Float;
    private var centre:                 Vec2;
    private var points:                 Array<Vec2>;
    public var sideData:                JigsawPieceData;
    private var first:                  Vec2;
    public var xy:                      Vec2;
    public var row:                     Int;
    public var col:                     Int;
    
    
    
    public function new(    xy_:        Vec2
                        ,   row:        Int
                        ,   col:        Int
                        ,   lt:         Vec2,    rt:    Vec2,   rb:     Vec2,   lb:     Vec2
                        ,   sideData_:  JigsawPieceData 
                        )
    {
        
        enabled                         = true;
        xy                              = new Vec2( xy_.x, xy_.y );
        sideData                        = sideData_;
        points                          = [];
        stepAngle                       = JigsawMagicNumbers.stepSize*Math.PI/180;
        first                           = lt;
        
        // NORTH side
        if( sideData.north != null )    createVertSide( lt, rt, sideData.north, NORTH );
        points.push( rt );
        
        // EAST side
        if( sideData.east != null )     createHoriSide( rt, rb, sideData.east, EAST );
        points.push( rb );
        
        // SOUTH side
        if( sideData.south != null )    createVertSide( rb, lb, sideData.south, SOUTH );
        points.push( lb );
        
        // WEST side
        if( sideData.west != null )     createHoriSide( lb, lt, sideData.west, WEST );
        points.push( lt );
        
    }
    
    
    public function getPoints(): Array<Vec2>
    {
        
        return points;
        
    }
    
    
    public function getFirst(): Vec2
    {
        
        return first;
        
    }
    
    
    private function createVertSide(    A:          Vec2
                                    ,   B:          Vec2
                                    ,   side:       JigsawSideData
                                    ,   compass:    Compass
                                    )
    {
        
        drawSide(       A.x + ( B.x - A.x )/2 + JigsawMagicNumbers.dMore/2  - side.squew*( JigsawMagicNumbers.dMore )
                ,       A.y + ( B.y - A.y )/2 + JigsawMagicNumbers.dinout/2 - side.inout*( JigsawMagicNumbers.dinout )
                ,       side
                ,       compass
                );
        
    }
    
    
    private function createHoriSide (   A:          Vec2
                                    ,   B:          Vec2
                                    ,   side:       JigsawSideData
                                    ,   compass:    Compass
                                    )
    {
        
        drawSide(       A.x + ( B.x - A.x )/2 + JigsawMagicNumbers.dinout/2 - side.inout*( JigsawMagicNumbers.dinout )
                ,       A.y + ( B.y - A.y )/2 + JigsawMagicNumbers.dMore/2  - side.squew*( JigsawMagicNumbers.dMore )
                ,       side
                ,       compass 
                );
        
    }
    
    
    private function drawSide( dx: Float, dy: Float, sideData: JigsawSideData, compass: Compass )
    {
        
        var halfPI                      = Math.PI/2;
        var dimensions                  = new Vec2();
        var offsetCentre                = new Vec2();
        var bubble                      = sideData.bubble;
        
        centre = 
        switch( compass )
        {
            case NORTH:     new Vec2( dx,                                                   dy + 6*switch bubble{ case IN: 1; case OUT: -1; }   );
            case EAST:      new Vec2( dx - 6*switch bubble{ case IN: 1; case OUT: -1; },    dy                                                  );
            case SOUTH:     new Vec2( dx,                                                   dy - 6*switch bubble{ case IN: 1; case OUT: -1; }   );
            case WEST:      new Vec2( dx + 6*switch bubble{ case IN: 1; case OUT: -1; },    dy                                                  );
        }
        
        curveBuilder                    = new OpenEllipse();
        curveBuilder.centre             = centre;
        
        // large Arc
        dimensions.x                    = ( 1 + ( 0.5 - sideData.centreWide )/2 ) *  JigsawMagicNumbers.ellipseLargex;
        dimensions.y                    = ( 1 + ( 0.5 - sideData.centreHi )/2 ) *    JigsawMagicNumbers.ellipseLargex;
        
        curveBuilder.dimensions         = dimensions;
        curveBuilder.beginAngle         = Math.PI/8;
        curveBuilder.finishAngle        = -Math.PI/8;
        curveBuilder.stepAngle          = stepAngle;
        curveBuilder.rotation           = switch bubble { case IN: 0; case OUT: Math.PI; }
        
        switch( compass )
        {
            case NORTH:
            case EAST:      curveBuilder.rotation += halfPI;
            case SOUTH:     curveBuilder.rotation += Math.PI; 
            case WEST:      curveBuilder.rotation += 3*halfPI; 
        }
        
        var secondPoints                = curveBuilder.getRenderList();
        
        if( bubble == IN )              secondPoints.reverse();
        
        var theta                       = curveBuilder.beginAngle - curveBuilder.finishAngle + Math.PI;
        var cosTheta                    = Math.cos( theta );
        var sinTheta                    = Math.sin( theta );

        var hyp                         = curveBuilder.getBeginRadius();
        // left Arc
        dimensions.x                    = ( 1 + ( 0.5 - sideData.leftWide )/2 ) *   JigsawMagicNumbers.ellipseSmallx;
        dimensions.y                    = ( 1 + ( 0.5 - sideData.leftHi )/2 ) *     JigsawMagicNumbers.ellipseSmally;
        
        curveBuilder.dimensions         = dimensions;
        curveBuilder.beginAngle         = halfPI;
        curveBuilder.finishAngle        = -halfPI;
        curveBuilder.stepAngle          = stepAngle;
        curveBuilder.rotation           = theta + switch bubble { case IN: 0; case OUT: halfPI; };
        
        switch( compass )
        {
            case NORTH:
            case EAST:      curveBuilder.rotation += halfPI;
            case SOUTH:     curveBuilder.rotation += Math.PI; 
            case WEST:      curveBuilder.rotation += 3*halfPI; 
        }
        
        var hypLeft                     = hyp + curveBuilder.dimensions.x;
        
        switch( compass )
        { 
            case NORTH:
                offsetCentre.x          = centre.x + hypLeft*cosTheta;
                offsetCentre.y          = centre.y + switch bubble { case IN: hypLeft*sinTheta; case OUT: -hypLeft*sinTheta; }
                
            case EAST:
                offsetCentre.x          = centre.x + switch bubble { case IN: -hypLeft*cosTheta; case OUT: hypLeft*cosTheta; }
                offsetCentre.y          = centre.y + hypLeft*sinTheta;
            
            case SOUTH:
                offsetCentre.x          = centre.x - hypLeft*cosTheta;
                offsetCentre.y          = centre.y - switch bubble { case IN: hypLeft*sinTheta; case OUT: - hypLeft*sinTheta; }
            
            case WEST:
                offsetCentre.x          = centre.x + switch bubble { case IN: hypLeft*cosTheta; case OUT: -hypLeft*cosTheta; }
                offsetCentre.y          = centre.y - hypLeft*sinTheta;
            
        }
        
        curveBuilder.centre             = offsetCentre;
        var startPoint                  = curveBuilder.getBegin();
        var firstPoints                 = curveBuilder.getRenderList();
        
        if( sideData.bubble == OUT )    firstPoints.reverse();
        firstPoints.pop();
        firstPoints.pop();
        secondPoints.shift();
        secondPoints.shift();
        secondPoints.shift();
        points                          =  points.concat( firstPoints.concat( secondPoints ) );
        
        // right Arc
        dimensions.x                    = ( 1 + ( 0.5 - sideData.rightWide )/2 ) *  JigsawMagicNumbers.ellipseSmallx;
        dimensions.y                    = ( 1 + ( 0.5 - sideData.rightHi )/2 ) *    JigsawMagicNumbers.ellipseSmally;
        curveBuilder.dimensions         = dimensions;
        curveBuilder.beginAngle         = halfPI;
        curveBuilder.finishAngle        = -halfPI;
        curveBuilder.stepAngle          = stepAngle;
        curveBuilder.rotation           = theta + switch bubble { case IN: - halfPI; case OUT: Math.PI; };
        
        switch( compass )
        {
            case NORTH:
            case EAST:      curveBuilder.rotation += halfPI;
            case SOUTH:     curveBuilder.rotation += Math.PI; 
            case WEST:      curveBuilder.rotation += 3*halfPI; 
        }
        
        var hypRight                    = hyp + curveBuilder.dimensions.x;
        
        switch( compass )
        { 
            case NORTH:
                offsetCentre.x          = centre.x - hypRight*cosTheta;
                offsetCentre.y          = centre.y + switch bubble { case IN: hypRight*sinTheta; case OUT: -hypRight*sinTheta; };
                
            case EAST:
                offsetCentre.x         = centre.x + switch bubble { case IN: -hypLeft*cosTheta; case OUT: hypLeft*cosTheta; }
                offsetCentre.y         = centre.y - hypLeft*sinTheta;
                
            case SOUTH:
                offsetCentre.x          = centre.x + hypRight*cosTheta;
                offsetCentre.y          = centre.y - switch bubble { case IN: hypRight*sinTheta; case OUT: -hypRight*sinTheta; };
            
            case WEST:
                offsetCentre.x         = centre.x + switch bubble { case IN: hypLeft*cosTheta; case OUT: -hypLeft*cosTheta; }
                offsetCentre.y         = centre.y + hypLeft*sinTheta;
            
        }
        
        curveBuilder.centre             = offsetCentre;
        var    thirdPoints              = curveBuilder.getRenderList();
        if( bubble == OUT )             thirdPoints.reverse();
        thirdPoints.shift();
        thirdPoints.shift();
        points.pop();
        points.pop();
        points.pop();
        points                          = points.concat( thirdPoints );
        
    }
    
    
}
