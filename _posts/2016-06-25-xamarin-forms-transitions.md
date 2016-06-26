---
layout: post
title: Xamarin custom page transitions
tags: [Xamarin, Xamarin.Forms, iOS, Android, Mobile, UI, Transitions, Animations]
---
### Transitions
You might have seen some applications with nice and smooth animations/transitions between pages, 
and in Xamarin.Forms you might want to change the page transitions to be something similar.
However this is poorly documented, and hard to get started with.

There are several examples on the samples [site](https://developer.xamarin.com/samples-all/), but those are not for Xamarin.Forms.

Xamarin Forms 2.3 is sadly not made to support custom transitions very well, 
and if this is important in your application, 
you will probably want to go for pure Xamarin Android and iOS instead.
The good part is that by poking around in the sourcecode, it seems like this is something that they will improve in the future.

### Navigation on iOS:
iOS is the easiest to make custom page transitions.

A good resource will be to look at this [forum post](https://forums.xamarin.com/discussion/18818/custom-page-transitions-with-xamarin-forms), and with the [example](https://gist.github.com/alexlau811/e12a8c126e6e082a5017) it was easily able to get this working nice and smooth.

### Navigation on Android AppCompat:
Navigation on AppCompat is a little harder, but by poking around in the [sourcecode](https://github.com/xamarin/Xamarin.Forms), 
I found that an override of the [SetupPageTransition](http://stackoverflow.com/questions/35593073/xamarin-appcompat-navigationpagerenderer-transitions) would make you able to add custom transitions between the pages.
There is however a little bug in this approach when navigation back in the navigationstack. The fragment actually is removed from the stack before the animation is finished.

```csharp
[assembly: ExportRenderer(typeof(NavigationPage), typeof(AnimationNavigationRenderer))]
namespace ProjectName.Droid
{
    public class AnimationNavigationRenderer : Xamarin.Forms.Platform.Android.AppCompat.NavigationPageRenderer
    {
        protected override void SetupPageTransition(Android.Support.V4.App.FragmentTransaction transaction, bool isPush)
        {
            if (isPush)
                transaction.SetCustomAnimations(Resource.Animation.abc_slide_in_top, 0, 0, Resource.Animation.abc_slide_out_top);
            else
                transaction.SetCustomAnimations(Resource.Animation.abc_slide_in_top, 0, 0, Resource.Animation.abc_slide_out_top);
        }
    }
}
```

### Navigation on Android 5+:

{% include warning.html message="This post is for Xamarin 2.3, and the code will need small changes to work on later versions." submessage="(It uses reflection on code already changed in latest branch)" %}

I tried several ways of achieving this, however the only solution I found without too many bugs in it, was to get Xamarin.Forms to skip some code, and do this manually.

It's not that hard to add custom animations:

```csharp
public override void AddView(Android.Views.View child)
{
    base.AddView(child);
    child.Visibility = ViewStates.Visible;

    var animation = AnimationUtils.LoadAnimation(Context, Resource.Animator.transition_from_left);
    animation.AnimationEnd += (sender, e) => child.Animation = null;
    child.Animation = animation;

    //Alternative logic (code):
    ////child.Alpha = 0;
    ////child.ScaleX = child.ScaleY = 0.8f;
    //child.TranslationX = Resources.DisplayMetrics.WidthPixels;
    //ViewPropertyAnimator animatior = child.Animate().TranslationX(0).SetDuration(200); //.ScaleX(1).ScaleY(1).Alpha(1)
}
```

Xamarin has hardcoded the default animation, so there is not much to do there. We therefor need to always send in <code>animated = false</code> when calling <code>base.OnPushAsync</code>, when using custom animations.
The hard part is that Xamarin hides the previus page before the animation is finished.
By setting the private field <code>_current = null</code>, Xamarin will however skip this part.
To do this we need to use some reflection magic (this code might change in later versions):

```csharp
private Page SwitchView(Page currentView)
{
    var field = this.GetType().BaseType.GetField("_current", BindingFlags.NonPublic | BindingFlags.Instance);
    var pastView = (Page)field.GetValue(this);
    field.SetValue(this, currentView);
    return pastView;
}
```

But then we will need to manually hide the previous page:

```csharp
var renderer = Platform.GetRenderer(pastView);
if (pastView != null && renderer != null && renderer.ViewGroup.Parent != null)
    SendDisappearing(pastView);
```

To call the SendDisappearing, we will need to use reflection.
In current branch on Github of Xamarin.Forms, they have however changed this.
In the future we probably can call this without reflection.

```csharp
private void SendDisappearing(Page page)
{
    var pageType = typeof(Xamarin.Forms.Page);
    var sendDisappearingMethod = pageType.GetMethod("SendDisappearing", BindingFlags.NonPublic | BindingFlags.Instance);
    sendDisappearingMethod.Invoke(page, new object[0]);
}
```

Whole code will then look like this:

```csharp
[assembly: ExportRenderer(typeof(NavigationPage), typeof(CustomNavigationAnimationRenderer))]
namespace ProjectName.Droid
{
    public class CustomNavigationAnimationRenderer : Xamarin.Forms.Platform.Android.NavigationRenderer
    {
        //Warning: Will break in a later release of Xamarin.Forms:
        private void SendDisappearing(Page page)
        {
            var pageType = typeof(Xamarin.Forms.Page);
            var sendDisappearingMethod = pageType.GetMethod("SendDisappearing", BindingFlags.NonPublic | BindingFlags.Instance);
            sendDisappearingMethod.Invoke(page, new object[0]);
        }

        //Warning: Uses reflection, might break in a later release:
        private Page SwitchView(Page currentView)
        {
            var field = this.GetType().BaseType.GetField("_current", BindingFlags.NonPublic | BindingFlags.Instance);
            var pastView = (Page)field.GetValue(this);
            field.SetValue(this, currentView);
            return pastView;
        }

        protected override async Task<bool> OnPushAsync(Page view, bool animated)
        {
            var pastView = SwitchView(null); //Removes the previous view from parent (NavigationRenderer).

            var result = await base.OnPushAsync(view, false); //Execute code.

            //Manually run parents code that was skipped:
            var renderer = Platform.GetRenderer(pastView);
            if (pastView != null && renderer != null && renderer.ViewGroup.Parent != null)
                SendDisappearing(pastView);

            return result;
        }

        public override void AddView(Android.Views.View child)
        {
            base.AddView(child);
            child.Visibility = ViewStates.Visible;

            var animation = AnimationUtils.LoadAnimation(Context, Resource.Animator.transition_from_left);
            animation.AnimationEnd += (sender, e) => child.Animation = null;
            child.Animation = animation;

            //Alternative logic (code):
            ////child.Alpha = 0;
            ////child.ScaleX = child.ScaleY = 0.8f;
            //child.TranslationX = Resources.DisplayMetrics.WidthPixels;
            //ViewPropertyAnimator animatior = child.Animate().TranslationX(0).SetDuration(200); //.ScaleX(1).ScaleY(1).Alpha(1)
        }
    }
}
```

There are two ways I found to make these transitions.

Either by using xml resources:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<set xmlns:android="http://schemas.android.com/apk/res/android" android:fillAfter="true" >
    <translate
        android:duration="250"
        android:fromXDelta="-100%"
        android:toXDelta="0" />
</set>
```

And the code:

```csharp
var animation = AnimationUtils.LoadAnimation(Context, Resource.Animator.transition_from_left);
animation.AnimationEnd += (sender, e) => child.Animation = null;
child.Animation = animation;
```

Or hard coded (like XF does):

```csharp
child.TranslationX = Resources.DisplayMetrics.WidthPixels;
ViewPropertyAnimator animatior = child.Animate().TranslationX(0).SetDuration(200);
```

Good luck. :)