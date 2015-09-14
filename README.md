## What's this?
A Ruby script to help you handle custom .ttf fonts in iOS.   

iOS doesn't support vectors natively in UILabels, UIImage, UIButton etc. forcing users to put all their icons as .png or .jpg, with different sizes for each device. I like to have all my app icons as vectors instead of .png files, so I can resize them as I want for each device, and change the color of the icon easily. 

FontAwesome is a great example (https://github.com/FortAwesome/Font-Awesome). You can import the font as .ttf in your iOS project and use this category to map the icons provided with an Enum value: https://github.com/alexdrone/ios-fontawesome.

## So what's the problem with custom .ttf fonts?
Well, if you want to create your own .ttf font a set of icons for your app you'll have to create your NSString Category to map each character with an Enum value. If you see the code of the fontAwesome one (https://github.com/alexdrone/ios-fontawesome), it would take some time. 

And even worst, every time you update your font with a new icon, you'll also have to update your enum.

## Ok, what's this script then doing?
You pass the script your .ttf font and it creates the NSString Category for you automatically. Every time you change your font, you can just import it into your project and run the script to generate the category again. You are done. 

## How do I use it?
Every Mac comes with a Ruby installed. All you have to do is call the ruby virtual machine to execute the script, passing it the path to your .ttf file as first parameter, and the path where the generated NSString Category will be saved. 

Sample: 

```ruby
ruby iosFontHelper/fontHelper.rb FontAwesome.ttf .
```




