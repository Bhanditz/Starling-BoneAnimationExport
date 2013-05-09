package
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class Util
	{
		
		
		private static function getMovieFramesInfo(mc:MovieClip):Object{
			var labels:Array = mc.currentLabels;
			var labelsLength:int = labels.length;
			var currentLabel:FrameLabel;
			var totalFrames:int = mc.totalFrames;
			var currentFrame:int = 0;
			
			var framesObject:Object = new Object();
			
			for(var i:int=0;i<labelsLength;i++){
				currentLabel = labels[i];
				currentFrame = currentLabel.frame;
				mc.gotoAndStop(currentLabel.name);
				
				var labelFramesObject:Array = [];
				var index:int = 0;
				
				while(mc.currentLabel == currentLabel.name && currentFrame <= totalFrames){
					var childNumber:int = mc.numChildren;
					var child:DisplayObject;
					var data:Array = [];
					for(var j:int=0;j<childNumber;j++){
						child = mc.getChildAt(j);
						data[j] = [child.name,child.x,child.y,int(child.rotation)];
					}
					labelFramesObject[index] = data;
					index ++;
					
					currentFrame ++;
					mc.gotoAndStop(currentFrame);
				}
				
				framesObject[currentLabel.name] = labelFramesObject;
			}
			return framesObject;
		}
		
		public static function getPivotAndMaxRect(mc:DisplayObject):Rectangle{
			var pivotx:Number = -1000000;
			var pivoty:Number = -1000000;
			var maxW:Number = -1000000;
			var maxH:Number = -1000000;
			var rect:Rectangle;
			
			var isMc:Boolean = mc is MovieClip;
			var totalFrames:int = isMc?(mc as MovieClip).totalFrames:1;
			
			for(var i:int = 1; i <= totalFrames ; i++){
				if(isMc) (mc as MovieClip).gotoAndStop(i);
				
				rect = mc.getBounds(mc);
				
				if(pivotx == -1000000 || pivoty == -1000000){
					pivotx = rect.x;
					pivoty = rect.y;
				}else{
					pivotx = rect.x < pivotx ? rect.x : pivotx;
					pivoty = rect.y < pivoty ? rect.y : pivoty;
				}
				
				if(maxH == -1000000 || maxW == -1000000){
					maxH = rect.height;
					maxW = rect.width;
				}else{
					maxW = (rect.width + rect.x - pivotx) < maxW ? maxW : (rect.width + rect.x - pivotx);
					maxH = (rect.height + rect.y - pivoty) < maxH ? maxH : (rect.height + rect.y - pivoty);
				}
			}
			return new Rectangle(-pivotx,-pivoty,maxW,maxH);
		}
		
		/** Converts an angle from degrees into radians. */
		public static function deg2rad(deg:Number):Number
		{
			return deg / 180.0 * Math.PI;   
		}
		
		/** Converts an angle from radions into degrees. */
		public static function rad2deg(rad:Number):Number
		{
			return rad / Math.PI * 180.0;            
		}
	}
}