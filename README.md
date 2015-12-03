## What's this?
A Ruby script to help you handle custom .ttf fonts in iOS. It autogenerates all the code to map your .ttf characters into an Enum either in Swift or Objective-C code. 

It's great because with this you can use any icon of the many available .ttf fonts out there in your app (like https://fortawesome.github.io/Font-Awesome/). You just have to import the .ttf file in your iOS project and this script will do the hard job mapping them into actual code.

It can be even more powerful if you put all your app icons in a font.ttf and use the script to map it in code. You will then have all your icons vectorized!. You can put them in UILabels, UIButtons etc.. not having to worry about the device size at all. They scale nicely for every device. You can also change the textColor and see how the icons look without having to get a new .png

## How do I use it?
<b>You need to have homebrew installed</b>

Then, call the ruby script from the terminal passing it the path to your .ttf file as first parameter, and the path where the generated code will be saved. (If the script does not detect the package lcd-typetools installed, it will try to do it via homebrew).

Sample:

Let's say you download FontAwesome.ttf from https://fortawesome.github.io/Font-Awesome/ and you want to use it in your app. You import it in your project and:

to generate Objective-C code: 



```ruby
ruby iOSFontHelper-master/fontHelper-objectivec.rb FontAwesome.ttf .
```

to generate Swift code: 

```ruby
ruby iOSFontHelper-master/fontHelper-swift.rb FontAwesome.ttf .
```
This generates a NSString category at the specified path:

```
FontName = FontAwesome 

Created header file: 
./NSString+FontAwesome.h


Created implementation file:
./NSString+FontAwesome.m
```

You can now drag the generated files into your project and start using them like:

Objective-C:
```
label.font = [UIFont fontWithName:@"FontAwesome" size:20.f];
label.text = [NSString FontAwesomeCharacterStringForEnum:FontAwesome_apple];
```

Swift:
```
label.font = UIFont(name: "FontAwesome", size: 20.0)
label.text = String.FontAwesomeIconStringForEnum(String.FontAwesome.FontAwesome_facebook_sign)
```

That's it. Note that the font name we use with UIFont is the specified by the script ```FontName = FontAwesome```.

## I've never imported a custom font in iOS. How do I do it?
&bull; Drag the .ttf file into your project. Make sure 'Copy Items if needed' and the target box of your app are both clicked.

&bull; Open your Info.plist and add "Fonts provided by application" key into your plist and in Item 0 copy the exact filename of the font you copied to your Supporting files WITH extension. For example: "myIconsFont.ttf".

&bull; When loading fonts in iOS, use the font name that the script printed:

```FontName = FontAwesome``` 


If you have troubles importing the font: http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/
