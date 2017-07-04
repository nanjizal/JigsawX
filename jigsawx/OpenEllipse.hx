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

import jigsawx.ds.CircleIter;
import jigsawx.math.Vec2;


class OpenEllipse
{
    
    
    public var rotation:                Float;
    public var beginAngle:              Float;
    public var finishAngle:             Float;
    public var stepAngle:               Float;
    public var centre:                  Vec2;
    public var dimensions:              Vec2;
    private var circleIter:             CircleIter;
    private var _points:                Array<Vec2>;
    
    
    
    public function new(){}
    
    
    public function getBegin(): Vec2
    {
        
        return createPoint( centre, dimensions, beginAngle );
        
    }
    
    
    public function getFinish(): Vec2
    {
        
        return createPoint( centre, dimensions, finishAngle );    
        
    }
    
    
    public function getBeginRadius()
    {
        
        return pointDistance( centre, getBegin() );
        
    }
    
    
    public function getFinishRadius()
    {
        
        return pointDistance( centre, getFinish() );
        
    }
    
    
    private function pointDistance( A: Vec2, B: Vec2 ): Float
    {
        
        var dx         = A.x - B.x;
        var dy         = A.y - B.y;
        
        return Math.sqrt( dx*dx + dy*dy );
        
    }
    
    
    public function setUp()
    {
        
        circleIter = CircleIter.pi2pi( beginAngle, finishAngle, stepAngle );
        
    }
    
    
    public function getRenderList(): Array<Vec2>
    { 
        
        _points = new Array();
        
        if( circleIter == null ) setUp();
        
        _points.push( createPoint( centre, dimensions, beginAngle ) );

        for( theta in CircleIter.pi2pi( beginAngle, finishAngle, stepAngle ).reset() )
        {
            
            _points.push( createPoint( centre, dimensions, theta ) );
            
        }
        return _points;
        
    }
    
    
    public function createPoint( centre: Vec2, dimensions: Vec2, theta: Float ): Vec2
    {
        
        var offSetA     = 3*Math.PI/2 - rotation;// arange so that angle moves from 0... could tidy up dxNew and dyNew!
        var dx          = dimensions.x*Math.sin( theta );// select the relevant sin cos so that 0 is upwards.
        var dy          = -dimensions.y*Math.cos( theta );
        var dxNew       = centre.x -dx*Math.sin( offSetA ) + dy*Math.cos( offSetA );
        var dyNew       = centre.y -dx*Math.cos( offSetA ) - dy*Math.sin( offSetA );
        
        return new Vec2( dxNew, dyNew );
        
    }
    
    
}
