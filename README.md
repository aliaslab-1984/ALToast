# ALToast

![Toast Example Image](images/example.png)

ALToast is a simple swift package that helps you to display small toast messages on your application with minimum effort!

This is the simplest way of showing a toast:

``` swift

ALToast.info(with: "Logged in.", image: "checkmark", on: self)
```

Easy right!? It gets even easier. If you want to avoid where to show the toast message, you can simply force to show each toast message on top of your app's main window. To do that:
1. Jump into your `SceneDelegate` class;
2. On `sceneWillEnterForeground(_ scene: UIScene)` call this method:
 ``` swift
 
 // ..
 
 func sceneWillEnterForeground(_ scene: UIScene) {
     ALToast.rootPresentable = UIApplication.shared.windows.first
 }
 
 ```
And you're done! Now you can avoid to call on: self  on each of your view controllers.
