////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

Spark Components
-----------------------------
1. Alert (org.apache.flex.spark.components.alert.Alert)
2. ColorPicker (org.apache.flex.spark.components.colorpicker.ColorPicker)
3. HDividerGroup (org.apache.flex.spark.components.dividers.HDividerGroup)
4. VDividerGroup (org.apache.flex.spark.components.dividers.VDividerGroup)
5. Menu and MenuBar (org.apache.flex.spark.components.menu.Menu and org.apache.flex.spark.components.menu.MenuBar)
6. ProgressBar (org.apache.flex.spark.components.progressBar.ProgressBar)
-----------------------------

General notes
-----------------------------
1) All skinnable components are trying to cover the lack of CSS declarations (which will need altering SDK).
They assume the default skins in private static method 'setDefaultStyles'.

2) Locale used (like Alert class) have only the en_US bundle, leaving the developer add bundles as needed.

3) Implementation of this components aimed to achieve the goals using the simpliest possible route.
However, this components were part of an entreprise project for more than an year.

-----------------------------
Alert Component Info
-----------------------------

Alert class extends spark.components.Panel, thus making it a Spark component

Usage is the same as for MX, by calling the static method 'show' with the parameters. 

public static function show(
			message:String = "", 
			title:String = "",
			flags : uint = OK,
			parent:Sprite = null,
			closeHandler:Function = null,
			iconClass:Class = null,
			defaultButtonIndex:uint = 0 /* Alert.OK */,
			modal:Boolean = true,
			moduleFactory:IFlexModuleFactory = null
		):Alert
		
Note that buttons labels are localized and the locales has to be declared. Only en_US was declared so far.

Usage example (which - of course - is similar to MX usage):

Displaying Alert :

Alert.show("Hello alert", "Alert title", Alert.OK | Alert.CANCEL | Alert.YES | Alert.NO, this, onAlertClosed , imgCls, 2 );
			
where close handler looks like this :
			
protected function onAlertClosed(e:CloseEvent):void
{
	switch (e.detail)
	{
			case Alert.OK:
				trace("OK");
			break;
			case Alert.CANCEL:
				trace("CANCEL");
			break;
			case Alert.NO:
				trace("NO");
			break;
			case Alert.YES:
				trace("YES");
			break;					
		}
}

Default skinning is declared in private static method 'setDefaultStyles' and points out the package org.apache.flex.spark.skins.spark.AlertSkin
If you need to customize your Alert skin, use the following CSS declaration template :

@namespace alert "org.apache.flex.spark.components.alert.*";
alert|Alert
{
	skinClass : ClassReference('org.apache.flex.spark.skins.spark.AlertSkin');			
}

Customizing the buttons style :
@namespace alert "org.apache.flex.spark.components.alert.*";
alert|Alert
{
	buttonStyleName : "alertButton";
}
where "alertButton" declarations looks like :
.alertButton
{
	skinClass : ClassReference('org.apache.flex.tests.view.skins.CustomAlertButton');
}

Note that 'messageStyleName' is supported too, but you might find this useless, since the component is skinnable. 
Also, keep in mind that messageDisplay used in skinning is an instance of RichText, but it's not necessary
to use the same in your custom skin. The Alert's skinpart for messageDisplay is typed as TextBase;

-----------------------------
ColorPicker component
-----------------------------

ColorPicker is based on spark.components.ComboBox, it's skinnable and dispatches two events : 
org.apache.flex.spark.events.ColorChangeEvent.CHOOSE ( "choose" ) and
org.apache.flex.spark.events.ColorChangeEvent.HOVER ( "hover" )
The last one can be used in case of 'preview' usage (when you are processing a preview of a color before choosing it).

The default skin for ColorPicker is org.apache.flex.spark.skins.spark.ColorPickerSkin. You can use your own, by using
a style declaration. Note that the 'open' button has it's own skin org.apache.flex.spark.skins.spark.ColorPickerButtonSkin.

Usage example :
1) declare the namespace : xmlns:colorpicker="org.apache.flex.spark.components.colorpicker.*"
2) declare MXML tag : <colorpicker:ColorPicker choose="onColorChosen(event)" hover="onColorHovered(event)" />
3) handle events :
	protected function onColorHovered(event:ColorChangeEvent):void
	{
		trace("Color Hovered : "+ColorPickerUtil.uint2hex(event.color));				
	}			
		
	protected function onColorChosen(event:ColorChangeEvent):void
	{
		trace("Color Choosed : " +ColorPickerUtil.uint2hex(event.color));				
	}			 
	
ColorPickerUtil.uint2hex provides the hex representation of the uint color value. 

-----------------------------
Dividers components : HDividerGroup and VDividerGroup
-----------------------------
Both components are based on Spark's Group (extended by DividedGroup which both classes extend),
but using HorizontalLayout for HDividerGroup and VerticalLayout for VDividerGroup.

For those who are trying to understand how it works:
-----------------------------
DividedGroup has declared metatag [DefaultProperty("children")] which makes all the MXML tags
inside HDividerGroup/VDividerGroup tag to go into the setter getter of the children property.
Children property is an array of mx.core.IVisualElement, which will be processed inside the overriden
method 'createChildren' of DividedGroup class.
For each child, we're adding a divider, created with a class specified by each specie of dividers :
HDivider and VDivider (both extend Divider class). Divider holds instances of two neighbours - 'up and down'
or 'left and right'. There are handlers for mouse events over the dividers which sets width / height of 
those neighbours.
End 'how-it-works'
-----------------------------

So far, adding and removing children at runtime is not supported, but the code is written into place.
If you are curious if it works, just uncomment the overriden methods 'addElement' and 'removeElement' inside
DividedGroup class.

You can constrain the minimum sizes (after which resizing stops) using properties named
minElementWidth for HDividerGroup and minElementHeight for VDividerGroup

If you want to have fun, set showTooltipOnDividers="true" for any of the divider groups.

Usage example :
1) declare namespace : xmlns:dividers="org.apache.flex.spark.components.dividers.*"
2) write MXML :
<dividers:VDividerGroup width="100%" height="100%">
		<dividers:HDividerGroup width="100%" height="70%">
			<s:Group width="20%" height="100%">				
				<s:Rect width="100%" height="100%">
					<s:fill>
						<s:SolidColor alpha="1" color="0x0000FF" />
					</s:fill>
					<s:stroke>
						<s:SolidColorStroke color="0x000000" />
					</s:stroke>
				</s:Rect>
				<s:Label text="Left" color="0xFFFFFF" top="10" left="10" />
			</s:Group>
			<s:Group width="80%" height="100%">				
				<s:Rect width="100%" height="100%">
					<s:fill>
						<s:SolidColor alpha="1" color="0x00FF00" />
					</s:fill>
					<s:stroke>
						<s:SolidColorStroke color="0x000000" />
					</s:stroke>
				</s:Rect>
				<s:Label text="Right" top="10" left="10" />
			</s:Group>
		</dividers:HDividerGroup>
		<s:Group width="100%" height="30%">			
			<s:Rect width="100%" height="100%">
				<s:fill>
					<s:SolidColor alpha="1" color="0xFF0000" />
				</s:fill>
				<s:stroke>
					<s:SolidColorStroke color="0x000000" />
				</s:stroke>
			</s:Rect>
			<s:Label text="Down" color="0xFFFFFF" top="10" left="10" />
		</s:Group>
</dividers:VDividerGroup>

-----------------------------
Menu and MenuBar
-----------------------------

MenuCoreItemRenderer is the core item renderer that both are using by it's subclasses
named MenuBarItemRenderer (mxml) and MenuItemRenderer (mxml). The subclasses 
are customizable and you can alter them as you wish.

Both Menu and MenuBar extend List and have skins org.apache.flex.spark.skins.spark.MenuSkin and
org.apache.flex.spark.skins.spark.MenuBarSkin, where MenuBarItemRenderer and
MenuItemRenderer are declared as itemRenderers of DataGroup.
Menu and MenuBar dispatches the following events
	
	[Event(name="selected", type="org.apache.flex.spark.events.MenuEvent")]
	when a menu item gets selected
	[Event(name="checked", type="org.apache.flex.spark.events.MenuEvent")]
	when a menu item gets checked (menu won't close, to allow altering checks)
	
By altering skinning, you can use custom / different layout for Menu, however MenuCoreItemRenderer
will check for VerticalLayout and HorizontalLayout in the owner menu, in order to display
the popup to the right or below. If none of this are found, popup will be displayed to
the right by default.
	
MenuCoreItemRenderer properties :
isSeparator (bindable) - if the menu item is a separator (will not trigger selected)
isCheckable (bindable) - if the menu item is a check like (for options)
isChecked (bindable) - if the menu item is checked (changes graphics to show the user that it's checked)
hasIcon (bindable) - changes graphics to use icon
iconSource (bindable) - icon class (usually an [Embed])
dataProvider (bindable) - XMLListCollection that feeds the renderer / sub-menus

Usage example for MenuBar:
-----------------------------
1) namespace declaration xmlns:menu="org.apache.flex.spark.components.menu.*"			
			
2) MXML declaration (with listeners for selected and checked events)

	<menu:MenuBar 
		id="menuBarMAIN"
		selected="onMenuChanged(event)"
		checked="onMenuChecked(event)"
		dataProvider="{menuDP}"
		width="100%" height="25"
		labelField="@label">
		<menu:layout>
			<s:HorizontalLayout />
		</menu:layout>
	</menu:MenuBar>
			
			
3) dataProvider setting
			[Bindable]
			public var menuDP : XMLListCollection ;
			
			public const menudata : XML = <menuData>
					<menu label="Menu One" 											data="five">
						<menu label="SubMenu One">
							<menu label="SubSubMenu One" 						data="seven2">
								<menu label="SubSubSubMenu One" 			data="eight2" />
								<menu label="SubSubSubMenu Two" 			data="nine2" />
								<menu label="Checkable One" 						data="ten2" 			isCheckable="true" />
								<menu label="Checkable Two" 						data="eleven2" 		isCheckable="true" 		isChecked="true"/>
							</menu>
							<menu label="SubSubMenu Two"						data="twelve" />
						</menu>
						<menu separator="true" />
						<menu label="SubMenu Two">
							<menu label="SubSubMenu One" 						data="seven">
								<menu label="SubSubSubMenu One" 			data="eight" />
								<menu label="SubSubSubMenu Two" 			data="nine" />
								<menu label="Checkable One" 						data="ten" 			isCheckable="true" />
								<menu label="Checkable Two" 						data="eleven" 	isCheckable="true" 		isChecked="true"/>
							</menu>
							<menu label="SubSubMenu Two"						data="twelve" />
						</menu>
					</menu>			
					<menu label="Menu Two" 											data="five">
						<menu label="SubMenu One">
							<menu label="SubSubMenu One" 						data="seven2">
								<menu label="SubSubSubMenu One" 			data="eight2" />
								<menu label="SubSubSubMenu Two" 			data="nine2" />
								<menu label="Checkable One" 						data="ten2" 			isCheckable="true" />
								<menu label="Checkable Two" 						data="eleven2" 		isCheckable="true" 		isChecked="true"/>
							</menu>
							<menu label="SubSubMenu Two"						data="twelve" />
						</menu>
						<menu separator="true" />
						<menu label="SubMenu Two">
							<menu label="SubSubMenu One" 						data="seven">
								<menu label="SubSubSubMenu One" 			data="eight" />
								<menu label="SubSubSubMenu Two" 			data="nine" />
								<menu label="Checkable One" 						data="ten" 			isCheckable="true" />
								<menu label="Checkable Two" 						data="eleven" 	isCheckable="true" 		isChecked="true"/>
							</menu>
							<menu label="SubSubMenu Two"						data="twelve" />
						</menu>
					</menu>				
				</menuData>;
				
				menuDP = new XMLListCollection(menudata.menu);

4) Handlers of events :

			protected function onMenuChanged(event:MenuEvent):void
			{
				trace("======================================");
				trace("Selected : "+event.item.@label);				
				trace("======================================");
			}
			protected function onMenuChecked(event:MenuEvent):void
			{
				trace("======================================");
				trace("Item : "+event.item.@label+" is now "+event.item.@isChecked);
				trace("======================================");
			}

Menu usage example
-----------------------------
Works in the same way. You can test with a button which when pressed to make the menu visible.

-----------------------------
ProgressBar component info
-----------------------------

ProgressBar component is skinnable and very simple to use. By altering it's properties named totalProgress
and currentProgress , the progress bar will update the bar size to the percent calculated between
those too. In case you don't want to display label percentual, displayPercents (Boolean) property
has to be set to false. If this property is set to false, suffix property allows to customize the label
which will display the value of currentProgress, "/" character, totalProgress and the suffix.

The component supports labelFunction, just in case you want to handle what label displays.

The direction property is used inside the skin. If it's set to 'right' it will make the bar grow from
left to right (default), if set to 'left', the bar will grow from right to left.

To allow more flexibility, the ProgressBar component is not going to have a source property,
like the MX component had, allowing developer to do whatever it wants.

Basic usage example :
-----------------------------
(For testing all features)

1) Namespace xmlns:progressBar="org.apache.flex.spark.components.progressBar.*"

2) The progress bar's value will be set by a hslider (simpliest test possible)
			<progressBar:ProgressBar id="progress" 
									 width="300" height="20" top="30" 
									 totalProgress="100" 
									 labelFunction="progressFunction"
									 currentProgress="{slider.value}"
									 displayPercents="false"
									 suffix="bytes"
									 direction="right"
									 />
			<s:HSlider id="slider" minimum="0" maximum="100" top="60" showDataTip="false" />  

3) where labelFunction is :

			public function progressFunction():void
			{
				if (progress.percentDisplay)
				{
					progress.percentDisplay.text = progress.currentProgress +" out of "+ progress.totalProgress;
				}
			}
