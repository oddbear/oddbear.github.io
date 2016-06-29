---
layout: post
title: Custom buttons in Xamarin Forms
tags: [Xamarin, Xamarin.Forms, iOS, Android, Mobile, UI, SVG]
---

I also Wrote part of this as a [post](http://forums.xamarin.com/discussion/68240/buttons-and-effects-on-ios) on the forum.

### Creating a custom button

There are several ways of achieving this (often with TapGestureRecognizer), but after Xamarin.Forms 2.3 they introduced effects. I wanted to try this out to make a custom Xamarin.Forms button, and I think it worked out quite well.

I created a normal state, and a clicked state as a svg file:

```xml
<svg viewBox="0 0 100 100" width="100px" height="100px" xmlns="http://www.w3.org/2000/svg">
  <!-- http://www.w3schools.com/svg/svg_feoffset.asp -->
  <defs>
    <filter id="filter1" x="-10%" y="-10%" width="140%" height="140%">
      <feOffset result="offOut" in="SourceGraphic" dx="2" dy="2" />
      <feColorMatrix result="matrixOut" in="offOut" type="matrix" values="0.2 0.0 0.0 0.0 0.0 0.0 0.2 0.0 0.0 0.0 0.0 0.0 0.2 0.0 0.0 0.0 0.0 0.0 1.0 0.0" />
      <feGaussianBlur result="blurOut" in="matrixOut" stdDeviation="3" />
      <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
    </filter>
  </defs>
  <path d="M50 15 L90 85 L10 85 Z" stroke-linejoin="round" stroke-width="6" stroke="black" fill="yellow" filter="url(#filter1)" />
  <circle cx="50" cy="72" r="5" />
  <path d="M45 42 L55 42 L50 60 Z" stroke-linejoin="round" stroke-width="5" stroke="black" fill="black" />
  <!-- <g transform="scale(0.9) translate(5, 5)"> #Copy paths over in here for pressed effect(can also adjust shadow before rendering)# </g> -->
</svg>
```

Result:
<svg viewBox="0 0 100 100" width="100px" height="100px" xmlns="http://www.w3.org/2000/svg">
    <!-- http://www.w3schools.com/svg/svg_feoffset.asp -->
    <defs>
        <filter id="filter1" x="-10%" y="-10%" width="140%" height="140%">
          <feOffset result="offOut" in="SourceGraphic" dx="2" dy="2" />
          <feColorMatrix result="matrixOut" in="offOut" type="matrix"
          values="0.2 0.0 0.0 0.0 0.0
                  0.0 0.2 0.0 0.0 0.0
                  0.0 0.0 0.2 0.0 0.0
                  0.0 0.0 0.0 1.0 0.0" />
          <feGaussianBlur result="blurOut" in="matrixOut" stdDeviation="3" />
          <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
        </filter>
    </defs>
    
    <path d="M50 15 L90 85 L10 85 Z" stroke-linejoin="round" stroke-width="6" stroke="black" fill="yellow" filter="url(#filter1)" />
    <circle cx="50" cy="72" r="5" />
    <path d="M45 42 L55 42 L50 60 Z" stroke-linejoin="round" stroke-width="5" stroke="black" fill="black" />
</svg>
<svg viewBox="0 0 100 100" width="100px" height="100px" xmlns="http://www.w3.org/2000/svg">
    <!-- http://www.w3schools.com/svg/svg_feoffset.asp -->
    <defs>
        <filter id="filter1" x="-10%" y="-10%" width="140%" height="140%">
          <feOffset result="offOut" in="SourceGraphic" dx="2" dy="2" />
          <feColorMatrix result="matrixOut" in="offOut" type="matrix"
          values="0.2 0.0 0.0 0.0 0.0
                  0.0 0.2 0.0 0.0 0.0
                  0.0 0.0 0.2 0.0 0.0
                  0.0 0.0 0.0 1.0 0.0" />
          <feGaussianBlur result="blurOut" in="matrixOut" stdDeviation="3" />
          <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
        </filter>
    </defs>
    <g transform="scale(0.9) translate(5, 5)">
        <path d="M50 15 L90 85 L10 85 Z" stroke-linejoin="round" stroke-width="6" stroke="black" fill="yellow" filter="url(#filter1)" />
        <circle cx="50" cy="72" r="5" />
        <path d="M45 42 L55 42 L50 60 Z" stroke-linejoin="round" stroke-width="5" stroke="black" fill="black" />
    </g>
</svg>

To get the SVG's in the project, I use [SvgExport](https://github.com/shakiba/svgexport), and a [python script](https://gist.github.com/oddbear/9d03aaa1a5a780a198764f8ee4953149).

To get started, I needed to create two classes in the Xamarin Forms PCL:

```csharp
public class CustomButton : Button { }

public class ButtonEffect : RoutingEffect {
    public ButtonEffect() : base("Effects.ButtonEffect") { }
}
```

And the button i Xaml like this:

```xml
<local:CustomButton
    HeightRequest="80"
    WidthRequest="80"
    HorizontalOptions="Center">
    <local:CustomButton.Effects>
        <local:ButtonEffect />
    </local:CustomButton.Effects>
</local:CustomButton>
```

The reason for having a custom button type, is a issue in iOS (more on that later).

### Android
Create a effect in the Android project like this:

```csharp
[assembly: ResolutionGroupName("Effects")]
[assembly: ExportEffect(typeof(ButtonEffect), "ButtonEffect")]
namespace ProjectName.Droid
{
    public class ButtonEffect : PlatformEffect
    {
        protected override void OnAttached()
        {
            var button = (Android.Support.V7.Widget.AppCompatButton)Control;
            button.SetBackgroundResource(Resource.Layout.buttonEffect);
        }

        protected override void OnDetached()
        {
            // Use this method if you wish to reset the control to original state
        }
    }
}
```

And the xml like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
  <item android:state_selected="true" >
    <bitmap android:gravity="fill" android:src="@drawable/buttonPressed" />
  </item>
  <item android:state_pressed="true">
    <bitmap android:gravity="fill" android:src="@drawable/buttonPressed" />
  </item>
  <item>
    <bitmap android:gravity="fill" android:src="@drawable/buttonNormal" />
  </item>
</selector>
```

And that should work. :)

### iOS

To get the button to work in Xamarin iOS, add this effect:

```csharp
[assembly: Xamarin.Forms.ResolutionGroupName("Effects")]
[assembly: Xamarin.Forms.ExportEffect(typeof(ButtonEffect), "ButtonEffect")]
namespace ProjectName.iOS
{
    public class ButtonEffect : Xamarin.Forms.Platform.iOS.PlatformEffect
    {
        protected override void OnAttached()
        {
            var button = (UIButton)Control;
            //var element = (Xamarin.Forms.Button)Element;
            //var container = (Xamarin.Forms.Platform.iOS.ButtonRenderer)Container;

            button.SetBackgroundImage(UIImage.FromFile("buttonNormal.png"), UIControlState.Normal);
            button.SetBackgroundImage(UIImage.FromFile("buttonPressed.png"), UIControlState.Highlighted);
        }

        protected override void OnDetached()
        {
            // Use this method if you wish to reset the control to original state
        }
    }
}
```

The problem then is that you get a highlight effect you cannot remove.

What you then get:

<img src="/images/2016-06-26-button_normal.png" alt="button with default renderer" />

What you might want:

<img src="/images/2016-06-26-button_custom.png" alt="button with custom renderer" />

By poking around in the Xamarin Forms sourcecode, I found out that they use code like this:
<code>SetNativeControl(new UIButton(UIButtonType.RoundedRect));</code>

The problem here is that the UIButton is constructed of type RoundedRect, and this is not changeable after the construction.

It was then easy to figure out that I could make some code like this to fix it:

```csharp
[assembly: ExportRenderer(typeof(CustomButton), typeof(CustomButtonRenderer))]
namespace ProjectName.iOS
{
    public class CustomButtonRenderer : ButtonRenderer
    {
        protected override void OnElementChanged(ElementChangedEventArgs<Button> e)
        {
            SetNativeControl(new UIButton(UIButtonType.Custom));
            Control.TouchUpInside += (sender, ev) => Element?.Command?.Execute(null);
            if (Element.TextColor == Color.Default) //#00000000
                Element.TextColor = Control.TitleColor(UIControlState.Normal).ToColor(); //#FFFFFFFF

            base.OnElementChanged(e);
        }
    }
}
```

What you need to do, is to run the <code>SetNativeControl</code> method to create the button before calling the base.
However, XF will then skip some code, so you will need to copy your click event or command to the button.

There is also a Xamarin fix for default colors that you can run manually.

After this, just call the base method.

{% include disqus.html %}
