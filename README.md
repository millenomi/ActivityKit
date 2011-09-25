# Activity Kit

The Activity Kit adds a few tools to organize application behavior. By creating `ILActivity` subclasses, you can organize the code for long-running activities that may run independently from the rest of an application in their own classes, while providing an easy-to-use interface for the views and view controllers in your application to interface with the activities and monitor their state.

For an example, see how an activity can be written to simulate the multi-alert login process that App Store and the iTunes Music Store use in the included demo.

To create a new activity, subclass the `ILActivity` class and override its 
`-main` method to start the job you want the activity to do. Activity code invoked by this kit always executes on the main thread. Your subclass's code must invoke its own `-end` method when the activity finishes — either within `-main` or later, asynchronously.

To run an activity, create a new `ILActivitiesSet` and add it to the set. An activity starts as soon as it's added. You can also use the `-start` method on the activity itself — this will add the activity to the shared `ILActivitiesSet` instance. You can access the `ILActivitiesSet`'s properties to retrieve all running activities and even produce live queries you can monitor with KVO.

## Activities vs. `NSOperation`s

`ILActivity` is very similar to `NSOperation` both conceptually (both encapsulate code that performs an operation) and in actual use (eg. you create one, then add it to some kind of manager object — a `ILActivitiesSet` vs. a `NSOperationQueue` and use KVO to monitor it until it finishes). However, there are some important distinctions to make:

* `NSOperation`:
    * Encapsulates a *threading* paradigm
    * Is often executed on an *arbitrary thread*
    * Its lifecycle usually ends whenever its `-main` method returns (barring extensive subclass customization)
    * May be executed without relying on a queue
* `ILActivity`:
    * Encapsulates a *conceptual*, high-level paradigm that corresponds to what the user sees
    * Assumed to be running asynchronously even past the execution of its `-main` method (until `-end` is invoked).
    * All activity code invoked by the framework always executes on the main thread
    * Typically manages UI (alerts, multiple view controllers, etc.)
    * Integrates with the OS to extend the lifetime of the app until completion
    * May be the client of one or more `NSOperation` objects
    * Their status can easily be queried (via `id <ILActivityQuery>` objects)

To sum it up: operations are low-level, activities are high-level; operations correspond to algorithmic steps ("compute a filtered version of this image", or "spell-check this text", or "download this file") whereas activities typically correspond to higher-level UI constructs (a login process done with alerts, a registration process that may involve multiple view controllers, etc.).

