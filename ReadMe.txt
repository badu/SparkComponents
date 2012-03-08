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

