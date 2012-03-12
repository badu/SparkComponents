package org.apache.flex.spark.interfaces
{
	import spark.components.IItemRenderer;
	import spark.components.List;
	
	public interface IListItemRenderer extends IItemRenderer
	{		
		function set listOwner(value:List):void;
		function get listOwner():List;
	}
}