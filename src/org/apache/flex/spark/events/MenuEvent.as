package org.apache.flex.spark.events
{
    import flash.events.Event;
    
    import org.apache.flex.spark.components.menu.Menu;
    
    import spark.components.List;
    import spark.events.IndexChangeEvent;
    
    public class MenuEvent extends IndexChangeEvent
    {		
		public static const SELECTED:String = "selected";
		public static const CHECKED:String = "checked";
		
		public var menu:List;
		public var item:Object;
		
        public function MenuEvent(type:String, 
                                       bubbles:Boolean=false, 
                                       cancelable:Boolean = false,
                                       owner:List = null, 
                                       selectedItem:Object = null)
        {
            super(type, bubbles, cancelable);
            menu = owner;
            item = selectedItem;
        }
        
        override public function clone():Event
        {
            return new MenuEvent(type, bubbles, cancelable, menu, item);
        }
        
        public static function convert(event:IndexChangeEvent, menu:Menu, item:Object):Event
        {
            return new MenuEvent(event.type, event.bubbles, event.cancelable, menu, item);
        }
    }
}
