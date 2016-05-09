/**
 * NResponder class
 * 
 * @version NResponder v1.0
 * @author Diney Bomfim
 */
package appkit.responders 
{
	import flash.utils.getTimer;
	
	import appkit.utils.NIdentifier;
	
	/**
	 * A new way to work with events in ActionScript 3.0 instead tradicional
	 * EventDispatcher and IEventDispatcher.
	 * 
	 * <p/>
	 * 
	 * <code>NResponder</code> was originally created as an integrant part of <b>AppKit</b> in the
	 * <b>Nineveh Framework</b>. <code>NResponder</code> is a Self Concrete class, this means that it can
	 * work outside <b>Nineveh Framework</b> without penalties or losses.
	 * 
	 * <p/>
	 * 
	 * By default, <code>NResponder</code> is garbage collection friendly. This means that it will use
	 * the minimum memory as possible, removing all itens in the NResponder Chain that will not
	 * be used any more.
	 * 
	 * <p/>
	 * 
	 * <code>NResponder</code> grown based on idea of Objective-C Event Flow.
	 * For this reason the name is NResponder, like NResponders in Objective-C.
	 * <code>NResponder</code> have features to work with events in an advanced way.
	 * This is very helpfull to do complex applications, like games and rich interactives applications.
	 * <code>NResponder</code> is a Singleton class capable to control all events in an application,
	 * either in diferents SWF! You can dispatch listeners across applications and Domains.
	 * 
	 * <p/>
	 * 
	 * <b>FEATURES</b>
	 * <ul>
	 * <li>Work in static or instantiated mode;</li>
	 * <li>Can specify the number of arguments to dispatch;</li>
	 * <li>Can change these arguments "on the fly" (in Run-Time);</li>
	 * <li>Can remove all NResponders;</li>
	 * <li>Can specify the number of replies;</li>
	 * <li>Can ordinate the replies;</li>
	 * <li>Can associate each listener with one target;</li>
	 * <li>Can have a delay to the next dispatch;</li>
	 * <li>Can pause or resume the replies;</li>
	 * <li>Can change all this attributes "on the fly" (in Run-Time);</li>
	 * <li>Can join to native Event API of Adobe® Flash® and continue to use all this features;</li>
	 * <li>Can instantiate and control each NResponder without change the others.</li>
	 * </ul>
	 * 
	 * <p/>
	 * 
	 * One of the most intrest behaviors of <code>NResponder</code> is that it is capable to extend
	 * all its features to native Event API. The reason for this behavior is to use <code>NResponder</code>
	 * in all kind of events. Whether is MouseEvents like MouseOver or Click, or KeyboardEvents, or TimerEvents
	 * or Events of a 3D engine or any other kind of event.
	 * 
	 * <p/>
	 * 
	 * For example, imagine a button to a shot game. In this game you want to create a "shot button".
	 * In this enviroment of shot game, the shot button need to wait 1 second to be pressed again
	 * to simulate the time required to trigger a new bullet. And this same shot button can be pressed
	 * just 6 times, because after 6 shots the gun will ahve no bullets and will need to be recharged.
	 * <br/>
	 * Try figure out how much code, and booleans, and numbers and conditionals that you will need
	 * to create this mechanism.
	 * 
	 * <p/>
	 * 
	 * Using the <code>NResponder</code> to create this mechanism takes less time than you spent to imagine
	 * the situation of the shooter. All that you need to create a behavior like the shoot button using
	 * <code>NResponder</code> is:
	 * 
	 * <listing version="3.0">
	 * NResponder.addNative(shootButton, MouseEvent.CLICK, shootFunction, 6, 1);
	 * </listing>
	 * 
	 * Just with this line of code your shootFunction will react to mouse clicks only in intervals
	 * of 1 second and just for 6 times, nothing more.
	 * 
	 * <p/>
	 * 
	 * Today AS3 has some ways to work with Events. The following table compare the 2 most popular ways
	 * with <code>NResponder</code>. The native Event API created by Adobe® Flash®, the Signals created by
	 * Robert Penner and NResponder created by Diney Bomfim.
	 * 
	 * <p/>
	 * 
	 * <table class="innertable">
	 * <tr><th width="300">Feature</th><th width="150">Event API <br/> (Adobe® Flash®)</th><th width="150">Signals <br/> (Robert Penner)</th><th width="150">NResponder <br/> (Diney Bomfim)</th></tr>
	 * <tr><td><b>Used without instance</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Used with instance</b></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Specify number of dispatch arguments</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Dynamic dispatch arguments</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Change dispatch arguments in Run-Time</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Remove all</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td>limited to instance</td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Specify a delay time</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Set the number of replies</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td>Just 1</td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Ordenate</b></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Can associate with a target</b></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td>only NativeSignal</td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Can pause without remove</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Can stop propagation</b></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Change attributes in Run-Time</b></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * <tr><td><b>Garbage Collect</b></td><td>only weak references</td><td><img src="http://db-in.com/imgs/no.gif" title="No" alt="No"></img></td><td><img src="http://db-in.com/imgs/yes.gif" title="Yes" alt="Yes"></img></td></tr>
	 * </table>
	 * 
	 * <p/>
	 * 
	 * Now, the following table compare these 3 APIs looking to the technical aspects.
	 * These test are done based on SWF compiled final size, in the <code>flash.sampler</code> package and
	 * in the Grant Skinner's <code>PerformanceTest</code> class. For more informations on this class visit:
	 * <a href="http://www.gskinner.com/blog/archives/2010/02/performancetest.html">http://www.gskinner.com/blog/archives/2010/02/performancetest.html</a>
	 * <br/>
	 * The methodology for this comparisons was to test equivalent behavior and features in this 3 APIs.
	 * <br/>
	 * The native Event API need the <code>EventDispatcher</code> and an Event to work. So, the sizes and
	 * times took into account these two classes.
	 * <br/>
	 * The Signals have 3 subclasses: Signal, DeluxeSignal and NativeSignal. To achieve a similar behavior to
	 * comparisons is necessary to use NativeSignal and DeluxeSignal together. For this reason, in the table the
	 * Signal's column has 2 values: NativeSignal and DeluxeSignal, respectively. The Signal class was left out.
	 * <br/>
	 * This test try to use all features of these APIs in the most expensive way, to reach the most critical results.
	 * 
	 * <p/>
	 * 
	 * <table class="innertable">
	 * <tr><th width="200">Test Area</th><th width="150">Event API <br/> ﻿(Adobe® Flash®)</th><th width="150">Signals <br/> (Robert Penner)</th><th width="150">NResponder <br/> (Diney Bomfim)</th></tr>
	 * <tr><td><b>Size Added to SWF</b></td><td>350 bytes</td><td>2.4 KB + 3.3 KB</td><td>3.4 KB</td></tr>
	 * <tr><td><b>Memory of Class</b></td><td>4.5 KB</td><td>2.7 KB + 3.3 KB</td><td>3.2 KB</td></tr>
	 * <tr><td><b>Memory of Each Instance</b></td><td>88 bytes</td><td>28 bytes + 24 bytes</td><td>52 bytes</td></tr>
	 * <tr><td><b>Performance to Add(1)</b></td><td>1.9 sec.</td><td>2.2 sec. | 2.6 sec.</td><td>3.7 sec.</td></tr>
	 * <tr><td><b>Performance to Dispatch(2)</b></td><td>2.4 sec.</td><td>2.7 sec. | 4.8 sec.</td><td>1.8 sec.</td></tr>
	 * <tr><td><b>Performance to Remove(3)</b></td><td>0 sec.</td><td>0 sec. | 0 sec.</td><td>0 sec.</td></tr>
	 * </table>
	 * <ol>
	 * <li>Add methods in an exaustive mode 10 different listeners added for 1.000.000 times. A real world application never will do this exaustive work.</li>
	 * <li>Dispatch methods in an exaustive mode 10 different listeners dispatched for 1.000.000 times. A real world application never will do this exaustive work.</li>
	 * <li>Remove methods for 10 different listeners 1.000.000 times. This method never will be exaustive
	 * in any of 3 APIs because in the first loop all the added listeners of the test was be removed.</li>
	 * </ol>
	 * 
	 * <p/>
	 * 
	 * As you can see, the native Event API is the most fast to create listeners. But it don't has so many features.
	 * Still it consume more memory. Imagine the cost of large applications with this API.
	 * <br/>
	 * The Signals has its work divided with 2 classes with independent engines. The Signals let the add process do
	 * a little part of work, whereas the dispatch process do a lot of work. The DeluxeSignal do more than double of work
	 * during the dispatch process. How many times an Application add events? And how many times it dispatch events, 
	 * counting with all mouse events, resize events, keyboard events, the adds and removes from stage?
	 * <br/>
	 * The NResponder keep the memory low and do almost all necessary work during the add process, to let dispatch process
	 * do what it need to do in the most cheap and fast way.
	 * 
	 * <p/>
	 * 
	 * The usage is very simple and is similar with native Event API to don't make confusion in the time to write.
	 * 
	 * @example To use this example just compile the following code as a <code>NResponderExample.as</code>.
	 * 
	 * <listing version="3.0" >
	 * package
	 * {
	 * 	import flash.display.MovieClip;
	 * 	import flash.events.MouseEvent;
	 * 
	 * 	import appkit.responders.NResponder;
	 * 
	 * 	public class NResponderExample extends MovieClip
	 * 	{
	 * 		public function NResponderExample():void
	 * 		{
	 * 			// Very simple set, without worry with weak references, parameters, or memory control.
	 * 			// As you can see, actionListener expect a parameter, but I don't need to set it here,
	 * 			// because the NResponder can change the parameter in Run-Time if I want.
	 * 			NResponder.add('theAction', actionListener);
	 * 
	 * 			// You can dispatch a NResponder of anywhere in your application,
	 * 			// may even be of another SWF file.
	 * 			// The following dispatch will result on a trace inside actionListener();
	 * 			NResponder.dispatch('theAction');			
	 * 
	 * 			// To add natives events of Flash, instead this:
	 * 			//this.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
	 * 
	 * 			// Do this:
	 * 			NResponder.addNative(this.stage, MouseEvent.MOUSE_DOWN, downHandler);
	 * 		}
	 * 		
	 * 		private function actionListener(aString:String = null):void
	 * 		{
	 * 			trace('OK, actionListener is catched with parameter', aString);
	 * 		}
	 * 
	 * 		private function downHandler(e:MouseEvent):void
	 * 		{
	 * 			trace('OK, MouseDown');
	 * 			
	 * 			// Now the following dispatch will occurs every time the mouse down on stage.
	 * 			// This will dispatch the previous 'theAction' NResponder's Action with a parameter.
	 * 			NResponder.dispatch('theAction', [e.toString()]);
	 * 
	 * 			// Inside this dispatch I can catch some parameters of NResponder.
	 * 			// I didn't set before, but I can change now the number of delay to this NResponder.
	 * 			// All that I need is call the "currentNResponder" that will return the reference to this
	 * 			// NResponder instance, and with this instance change the value of delay.
	 * 			// After this, you could try to continuously to click on the stage and you will see that 
	 * 			// the interval between two differents dispatches will increase in each dispatch.
	 * 			NResponder.currentNResponder.delay += 1;
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	public final class NResponder
	{
		
	//**************************************************
	//  Constants
	//**************************************************
		
		/**
		 * The instance to the singleton NResponderCore.
		 * 
		 * @private
		 */
		private static const CORE:NResponderCore = new NResponderCore();
		
	//**************************************************
	//  Public Properties
	//**************************************************
		
		/**
		 * The number of times that this item will respond.
		 * Default is 0 that means infinity times.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public var replies:uint;
		
		/**
		 * Indicates if this NResponder is running (active) or sleeping (inactive).
		 * Default is false, that means this NResponder is not paused.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public var paused:Boolean;
		
		/**
		 * The time in seconds between two dispatches of this NResponder.
		 * For example, you can specify this delay to create a time between
		 * the clicks in a button.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public var delay:Number;
		
	//**************************************************
	//  Protected / Private Properties
	//**************************************************
		
		/**
		 * The NResponder Action associated with this NResponder.
		 * 
		 * @private
		 */
		private var $action:String;
		
		/**
		 * The order of this item in the NResponder Chain.
		 * An order of <code>n</code> order is dispatched first
		 * than an order of <code>n+1</code>.
		 * If two or more listeners share the same priority,
		 * they are dispatched in the order in which they were added.
		 * The default is 0. 
		 */
		private var $order:uint;
		
		/**
		 * The closure method that this item was associated.
		 * 
		 * @private
		 */
		private var $listener:Function;
		
		/**
		 * An Object that can be associated with this item.
		 * This is optional.
		 * 
		 * @private
		 */
		private var $target:Object;
		
		/**
		 * The next time that this NResponder will be abble
		 * to perform the listener.
		 * 
		 * @private
		 */
		private var $lastDelay:Number;
		
		/**
		 * Indicate if this NResponder work with native
		 * Event API of Adobe® Flash®.
		 * 
		 * @private
		 */
		private var $isNative:Boolean;
		
		/**
		 * An unique hash based on Action, Listener and Target to help the
		 * searchs performance.
		 * 
		 * @private
		 */
		private var $hash:uint;
		
	//**************************************************
	//  Initialization
	//**************************************************
		
		/**
		 * The Constructor create an instance of NResponder.
		 * 
		 * <p/>
		 * 
		 * NResponder can use its new event system or interact with native Event API of Adobe® Flash®.
		 * The simplest way is use NResponder like an static class with <code>add()</code> and
		 * <code>addNative()</code> methods. If you want to use one instance, simply catch the return
		 * of these methods.
		 * 
		 * <p/>
		 * 
		 * However if you want to use the new parameter to create a NResponder, you can do it directly with
		 * this contructor. The name of parameters and order of it are similar in the static methods
		 * <code>add()</code> and <code>addNative()</code>.
		 * 
		 * @param	action		The identifier of the Action. This action will be used to dispatch the Action.
		 * It is advisable to define a constant for each action of action.
		 * So when you will dispatch the NResponder Action you can use the constant instead of writing
		 * the name of action.
		 * 						
		 * @param	listener	A listener to respond to a NResponder Action.
		 * 
		 * @param	replies		How many times the listener will perform with NResponder Action.
		 * How any listener can't be added to respond 0 times. So the 0 represent the infinity replies.
		 * 
		 * @param	delay		The delay time, in seconds, between two consecutive dispatches.
		 * During the delay time the NResponder Action will not activate the listener.
		 * <br/>
		 * For example, if the delay time set for the mouse click on a button is of 2 seconds and
		 * this button is clicked, the listener only will respond to a new click after 2 seconds.
		 * 
		 * @param	order		The order in which the listener will be dispatched. 
		 * The order is designated by a unsigned 32-bit integer. It work exactly in the
		 * opposite way of <code>priority</code>. Firsts orders are dispatched first.
		 * <br/>
		 * For example an order of <code>n</code> is dispatched first than an order of <code>n+1</code>.
		 * If two or more listeners share the same priority, they are dispatched in the order in which
		 * they were added. The default is 0. 
		 * 
		 * @param	useTarget	An object to associate with this listener and access it during execution.
		 * This object can be of any kind inherited from <code>Object Class</code>.
		 * <br/>
		 * You can access it during the execution of the listener by calling the property
		 * <code>currentTarget</code> of the <code>NResponder Class</code>.
		 * 
		 * @param	isNative	This parameter indicate if the NResponder will work with native Event API
		 * or if will use the NResponder system. This parameter is the diference bettwen
		 * <code>add()</code> and <code>addNative()</code> methods.
		 * 
		 * @see add()
		 * @see addNative()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
        public function NResponder(action:String, listener:Function, replies:uint = 0, delay:Number = 0,
								  order:uint = 0, useTarget:Object = null, isNative:Boolean = false):void 
        {
			// Treat the error of null native targets.
			if (isNative && !useTarget)
			{
				trace('Target can`t be null to native NResponders.');
				return;
			}
			
			// Setting the parameters.
			$action = action;
			$listener = listener;
			this.replies = replies;
			this.delay = delay;
			$order = order;
			$target = useTarget;
			$isNative = isNative;
			$lastDelay = int.MIN_VALUE;
			$hash = NIdentifier.from($action) << 0x08 | NIdentifier.from($target);
			
			// Register the NResponder instance.
			CORE.register(this);
        }
		
	//**********************************************************************************************************
	//
	//  Public Methods
	//
	//**********************************************************************************************************
		
		/**
		 * Create a new NResponder based on an action and a listener.
		 * The action that dispatch this NResponder are not associated with any class or object an can be
		 * dispatch anywhere in the application. In every dispatch you can specify any arguments you want,
		 * these arguments are directly delivered to the listeners for the specified action.
		 * 
		 * <p/>
		 * 
		 * @param	action		The identifier of the Action. This action will be used to dispatch the Action.
		 * It is advisable to define a constant for each action of action.
		 * So when you will dispatch the NResponder Action you can use the constant instead of writing
		 * the name of action.
		 * 						
		 * @param	listener	A listener to respond to a NResponder Action.
		 * 
		 * @param	replies		How many times the listener will perform with NResponder Action.
		 * How any listener can't be added to respond 0 times. So the 0 represent the infinity replies.
		 * 
		 * @param	delay		The delay time, in seconds, between two consecutive dispatches.
		 * During the delay time the NResponder Action will not activate the listener.
		 * <br/>
		 * For example, if the delay time set for the mouse click on a button is of 2 seconds and
		 * this button is clicked, the listener only will respond to a new click after 2 seconds.
		 * 
		 * @param	order		The order in which the listener will be dispatched. 
		 * The order is designated by a unsigned 32-bit integer. It work exactly in the
		 * opposite way of <code>priority</code>. Firsts orders are dispatched first.
		 * <br/>
		 * For example an order of <code>n</code> is dispatched first than an order of <code>n+1</code>.
		 * If two or more listeners share the same priority, they are dispatched in the order in which
		 * they were added. The default is 0. 
		 * 
		 * @param	useTarget	An object to associate with this listener and access it during execution.
		 * This object can be of any kind inherited from <code>Object Class</code>.
		 * <br/>
		 * You can access it during the execution of the listener by calling the property
		 * <code>currentTarget</code> of the <code>NResponder Class</code>.
		 * 
		 * @return				A new instance of NResponder. You can store this instance to future consults
		 * or changes in its properties.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function add(action:String, listener:Function, replies:uint = 0, delay:Number = 0,
								   order:uint = 0, useTarget:Object = null):NResponder
		{
			return new NResponder(action, listener, replies, delay, order, useTarget, false);
		}
		
		/**
		 * Create a new NResponder based on a target, a type and a listener. This method use native Event API
		 * of Adobe® Flash®.
		 * 
		 * <p/>
		 * 
		 * @param	target		A target that conforms with two methods of IEventDispatcher interface.
		 * The methods are addEventListener() and removeEventListener(). Not is necessary to this
		 * target to explicit implements de IEventDispatcher. This target will be used to perform the
		 * native Event API of Adobe® Flash®.
		 * 
		 * @param	action		The identifier of the Action. This action will be used to dispatch the Action.
		 * It is advisable to define a constant for each action of action.
		 * So when you will dispatch the NResponder Action you can use the constant instead of writing
		 * the name of action.
		 * 						
		 * @param	listener	A listener to respond to a NResponder Action.
		 * 
		 * @param	replies		How many times the listener will perform with NResponder Action.
		 * How any listener can't be added to respond 0 times. So the 0 represent the infinity replies.
		 * 
		 * @param	delay		The delay time, in seconds, between two consecutive dispatches.
		 * During the delay time the NResponder Action will not activate the listener.
		 * <br/>
		 * For example, if the delay time set for the mouse click on a button is of 2 seconds and
		 * this button is clicked, the listener only will respond to a new click after 2 seconds.
		 * 
		 * @param	order		The order in which the listener will be dispatched. 
		 * The order is designated by a unsigned 32-bit integer. It work exactly in the
		 * opposite way of <code>priority</code>. Firsts orders are dispatched first.
		 * <br/>
		 * For example an order of <code>n</code> is dispatched first than an order of <code>n+1</code>.
		 * If two or more listeners share the same priority, they are dispatched in the order in which
		 * they were added. The default is 0. 
		 * 
		 * @return				A new instance of NResponder. You can store this instance to future consults
		 * or changes in its properties.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function addNative(target:Object, action:String, listener:Function,
										 replies:uint = 0, delay:Number = 0, order:uint = 0):NResponder
		{
			return new NResponder(action, listener, replies, delay, order, target, true);
		}
		
		/**
		 * Remove a NResponder or NResponder Action from NResponder Chain.
		 * 
		 * <p/>
		 * 
		 * The <code>remove()</code> can be used combining the three parameters.
		 * To ignore a parameter, just set it to <code>null</code>. With this behavior you can
		 * find all NResponders to a specific Action, or all NResponders to a specific Target,
		 * or all NResponder with a specific Listener and Target.
		 * Altogether, you have 7 possibilities to combine these 3 parameter and perform an exclusion
		 * of NResponders.
		 * Some possibilities are:
		 * 
		 * <ul>
		 * 
		 * <li>Remove a NResponder based on an Action and a Listener.
		 * To do this, you specify the two first parameters.
		 * For example: <code>NResponder.remove('anAction', someFunction);</code></li>
		 * 
		 * <li>Remove all NResponders with a specific Action.
		 * To do this way, just specify the action and no other parameters.
		 * For example: <code>NResponder.remove('anAction');</code></li>
		 * 
		 * <li>Remove all NResponders to a target, like a button.
		 * To do this way, just call the method just with target parameter.
		 * For example: <code>NResponder.remove(null, null, myButton);</code></li>
		 * 
		 * </ul>
		 * 
		 * <p/>
		 * 
		 * If you try to pass all parameter with null, nothing will happens. This is a lock, because following
		 * the behavior of this method, nulling all parameter means that you want to exclude all NResponders.
		 * And exclude all NResponders of an Application running is not a good approach.
		 * 
		 * @param	action		The identifier of the Action.
		 * 
		 * @param	listener	The listener to be removed.
		 * 
		 * @param	toTarget	A target specified in add(). Just perform the remove() in this target.
		 * 
		 * @return				A Boolean that indicates: true = success, false = don't exist.
		 * 
		 * @example To use this example just compile the following code as a <code>NResponderRemoveExample.as</code>.
		 * This example is very dense and works with a lot of features of NResponder, combining remove modes.
		 * When you test it, click a lot of times on the stage and analyse the traces line by line.
		 * 
		 * <listing version="3.0" >
		 * package
		 * {
		 * 	import flash.display.MovieClip;
		 * 	import flash.events.MouseEvent;
		 * 
		 * 	import appkit.responders.NResponder;
		 * 
		 * 	public class NResponderRemoveExample extends MovieClip
		 * 	{
		 * 		private var clickResponder:NResponder;
		 * 		
		 * 		public function NResponderRemoveExample():void
		 * 		{
		 * 			// First let's add a series of different NResponders.
		 * 			NResponder.add('theAction', actionListener);
		 * 			NResponder.add('anotherAction', actionListener);
		 * 			NResponder.add('anActionWithTarget', anotherListener, 0, 0, 0, this);
		 * 			NResponder.addNative(this.stage, MouseEvent.MOUSE_DOWN, downHandler);
		 * 			clickResponder = new NResponder(MouseEvent.MOUSE_DOWN, clickListener, 0, 0, 0, this.stage, true);
		 * 		}
		 * 		
		 * 		private function actionListener(aString:String = null):void
		 * 		{
		 * 			trace('OK, actionListener is catched with parameter', aString);
		 * 		}
		 * 		
		 * 		private function anotherListener():void
		 * 		{
		 * 			trace('OK, anotherListener is catched with set target', NResponder.currentTarget);
		 * 			
		 * 			// Here let's dispatch another NResponder with the action "anotherAction".
		 * 			NResponder.dispatch('anotherAction', ['aString']);
		 * 			
		 * 			// Now the Action "theAction" will be removed.
		 * 			NResponder.remove('theAction');
		 * 			
		 * 			// If I try to dispatch "theAction", nothing will happens.
		 * 			NResponder.dispatch('theAction', ['you will don`t see this message!!!']);
		 * 			
		 * 			// At last, let's remove this listener, "anotherListener".
		 * 			// Independent of the Actions, this will remove all NResponder that perform
		 * 			// "anotherListener" function.
		 * 			// Doing this, "anotherListener" will not be performed any more.
		 * 			NResponder.remove(null, anotherListener);
		 * 		}
		 * 		
		 * 		private function downHandler(e:MouseEvent):void
		 * 		{
		 * 			trace('OK, MouseDown --- Originally was set as first to MOUSE_DOWN');
		 * 			
		 * 			// This NResponder was added first.
		 * 			// so it execute first than my instance of "clickResponder".
		 * 			// But now, I will change the order of this NResponder and will set it be a greater than 
		 * 			// my instance of "clickResponder".
		 * 			// Obviously this change will take effect just in the next dispatch.
		 * 			NResponder.currentNResponder.order = clickResponder.order + 2;
		 * 			
		 * 			// So if the currentNResponder's order is greater than my clickResponder's order,
		 * 			// The action "anActionWithTarget" will be dispatched.
		 * 			if(NResponder.currentNResponder.order > clickResponder.order)
		 * 			{
		 * 				NResponder.dispatch('anActionWithTarget');
		 * 				
		 * 				// Now let's increase the "clickResponder" order. This will affect the
		 * 				// currentNResponder's order above. So when this currentNResponder's order comes to 5,
		 * 				// let's remove the NResponders with "MouseEvent.MOUSE_DOWN" Action to "this.stage".
		 * 				// This means that independent of the the Listener, all NResponder with
		 * 				// "MouseEvent.MOUSE_DOWN" and with target "this.stage" will be removed.
		 * 				clickResponder.order += 1;
		 * 				if(NResponder.currentNResponder.order === 5)
		 * 				{
		 * 					NResponder.remove(MouseEvent.MOUSE_DOWN, null, this.stage);
		 * 				}
		 * 			}
		 * 		}
		 * 		
		 * 		private function clickListener(e:MouseEvent):void
		 * 		{
		 * 			trace('OK, ClickListener  --- Originally was set as last to MOUSE_DOWN');
		 * 		}
		 * 	}
		 * }
		 * </listing>
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function remove(action:String = null, listener:Function = null, toTarget:Object = null):Boolean
		{
			return CORE.remove(action, listener, toTarget);
		}
		
		/**
		 * Check if an action and/or listener is in NResponder Chain.
		 * 
		 * <p/>
		 * 
		 * Just like <code>remove()</code>, the <code>has()</code> method can be used combining the parameters.
		 * To ignore a parameter, just set it to <code>null</code>. With this behavior you can
		 * find all NResponders to a specific Action, or all NResponders to a specific Target,
		 * or all NResponder with a specific Listener and Target.
		 * Altogether, you have 7 possibilities to combine these 3 parameter and perform an exclusion
		 * of NResponders.
		 * Some possibilities are:
		 * 
		 * <ul>
		 * 
		 * <li>Check a NResponder based on an Action and a Listener.
		 * To do this, you specify the two first parameters.
		 * For example: <code>NResponder.has('anAction', someFunction);</code></li>
		 * 
		 * <li>Check if exist at least one NResponder with a specific Action.
		 * To do this way, just specify the action and no other parameters.
		 * For example: <code>NResponder.has('anAction');</code></li>
		 * 
		 * <li>Check if exist at least one NResponder to a target, like a button.
		 * To do this way, just call the method just with target parameter.
		 * For example: <code>NResponder.has(null, null, myButton);</code></li>
		 * 
		 * </ul>
		 * 
		 * <p/>
		 * 
		 * If you try to pass all parameter with null, nothing will happens. This is a lock, because following
		 * the behavior of this method, nulling all parameter means that you want to know if at least one
		 * NResponder exist, in other words, you want to check if NResponder is activated.
		 * But the simple fact of call this check will activate the NResponder class.
		 * So, check if NResponder is running is not a good approach.
		 * 
		 * @param	action		The identifier of the Action.
		 * 
		 * @param	listener	The listener to be checked.
		 * 
		 * @param	toTarget	A target specified when add a listener. Just perform the has() in this target.
		 * 
		 * @return				A Boolean that indicates: true = check exist, false = check don't exist.
		 * 
		 * @example To use this example just compile the following code as a <code>NResponderHasExample.as</code>.
		 * This example is similar to the structure of <code>remove()</code> example, but just with traces to
		 * check the <code>has()</code> method.
		 * 
		 * <listing version="3.0" >
		 * package
		 * {
		 * 	import flash.display.MovieClip;
		 * 	import flash.events.MouseEvent;
		 * 
		 * 	import appkit.responders.NResponder;
		 * 
		 * 	public class NResponderHasExample extends MovieClip
		 * 	{
		 * 		private var clickResponder:NResponder;
		 * 		
		 * 		public function NResponderHasExample():void
		 * 		{
		 * 			// First let's add a series of different NResponders.
		 * 			NResponder.add('theAction', actionListener);
		 * 			NResponder.add('anotherAction', actionListener);
		 * 			NResponder.add('anActionWithTarget', anotherListener, 0, 0, 0, this);
		 * 			NResponder.addNative(this.stage, MouseEvent.MOUSE_DOWN, downHandler);
		 * 			clickResponder = new NResponder(MouseEvent.MOUSE_DOWN, clickListener, 0, 0, 0, this.stage, true);
		 * 			
		 * 			// Observe behavior of the traces and see the differents combinations of parameters.
		 * 			trace(NResponder.has(MouseEvent.MOUSE_DOWN));					// true
		 * 			trace(NResponder.has(MouseEvent.MOUSE_DOWN, null, this.stage));	// true
		 * 			trace(NResponder.has(MouseEvent.MOUSE_DOWN, null, this));		// false
		 * 			trace(NResponder.has(null, null, this.stage));					// true
		 * 			trace(NResponder.has(null, null, this));						// true
		 * 			trace(NResponder.has('anActionWithTarget', null, this));		// true
		 * 			trace(NResponder.has('anActionWithTarget', null, this.stage));	// false
		 * 			trace(NResponder.has(null, downHandler, this.stage));			// true
		 * 			trace(NResponder.has(null, actionListener, this.stage));		// false
		 * 		}
		 * 		
		 * 		private function actionListener(aString:String = null):void { }
		 * 		
		 * 		private function anotherListener():void { }
		 * 		
		 * 		private function downHandler(e:MouseEvent):void { }
		 * 		
		 * 		private function clickListener(e:MouseEvent):void { }
		 * 	}
		 * }
		 * </listing>
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function has(action:String = null, listener:Function = null, toTarget:Object = null):Boolean
		{
			return CORE.has(action, listener, toTarget);
		}
		
		/**
		 * Dispatch a NResponder Action. The parameters passed here will be delivered directly
		 * to each listener of this NResponder Action.
		 * 
		 * Just like <code>remove()</code>, and <code>has()</code> methods, <code>dispatch()</code> method
		 * can be used combining the three parameters.
		 * To ignore a parameter, just set it to <code>null</code>. With this behavior you can
		 * dispatch all NResponders to a specific Action, or all NResponders to a specific Target.
		 * Obviously you can't just set the second parameter(<code>params</code>) that will be the scope
		 * to your dispatch.
		 * Some possibilities are:
		 * 
		 * <ul>
		 * 
		 * <li>Dispatch all NResponders with a specific Action.
		 * To do this way, just specify the action and no other parameters.
		 * For example: <code>NResponder.dispatch('anAction');</code></li>
		 * 
		 * <li>Dispatch all NResponders with a specific Action passing some parameter to the listener.
		 * To do this way, specify the action and an Array of parameters.
		 * For example: <code>NResponder.dispatch('anAction', [true, 0, 'aString']);</code></li>
		 * 
		 * <li>Dispatch all NResponders to a target, like a button.
		 * To do this way, just call the method just with target parameter.
		 * For example: <code>NResponder.dispatch(null, null, myButton);</code></li>
		 * 
		 * </ul>
		 * 
		 * <p/>
		 * 
		 * If you try to pass all parameter with null, nothing will happens. This is a lock, because following
		 * the behavior of this method, nulling all parameter means that you want to execute all NResponders
		 * at the same time.
		 * And perform all NResponders of an Application together is not a good approach.
		 * 
		 * 
		 * @param	action		The identifier of the Action.
		 * 
		 * @param	params		An Array with parameters that will be delivered directly to each listener.
		 * 
		 * @param	toTarget	If specified, dispatch the Action just to this target.
		 * 
		 * @example To use this example just compile the following code as a
		 * <code>NResponderDispatchExample.as</code>. This example is similar to the structure of
		 * <code>remove()</code> example, but just with dispatches.
		 * 
		 * <listing version="3.0" >
		 * package
		 * {
		 * 	import flash.display.MovieClip;
		 * 	import flash.events.MouseEvent;
		 * 
		 * 	import appkit.responders.NResponder;
		 * 
		 * 	public class NResponderDispatchExample extends MovieClip
		 * 	{
		 * 		private var clickResponder:NResponder;
		 * 		
		 * 		public function NResponderDispatchExample():void
		 * 		{
		 * 			// First let's add a series of different NResponders.
		 * 			NResponder.add('theAction', actionListener);
		 * 			NResponder.add('anotherAction', actionListener);
		 * 			NResponder.add('anActionWithTarget', anotherListener, 0, 0, 0, this);
		 * 			NResponder.addNative(this.stage, MouseEvent.MOUSE_DOWN, downHandler);
		 * 			clickResponder = new NResponder(MouseEvent.MOUSE_DOWN, clickListener, 0, 0, 0, this.stage, true);
		 * 			
		 * 			// Observe behavior of the traces and see the differents combinations of parameters.
		 * 			// You will see that you can force a dispatch of native events too. just remember that
		 * 			// natives events of flash expect just one parameter, a Event Object.
		 * 			NResponder.dispatch('theAction');
		 * 			NResponder.dispatch('theAction', ['a custom string parameter']);
		 * 			NResponder.dispatch(MouseEvent.MOUSE_DOWN, [null]);
		 * 			NResponder.dispatch(MouseEvent.MOUSE_DOWN, [null], this.stage);
		 * 			NResponder.dispatch(null, [null], this.stage);
		 * 			NResponder.dispatch(null, null, this);
		 * 			
		 * 			// Now let's create a new native NResponder to object "this" with
		 * 			// MouseEvent.MOUSE_DOWN action. In reality, this NResponder just will work if I put some
		 * 			// visual thing inside "this" and click it.
		 * 			// But, what I will do is dispatch a MouseEvent.MOUSE_DOWN with one null parameter.
		 * 			// This means that ALL NResponder with the action MouseEvent.MOUSE_DOWN will perform.
		 * 			// As all orders is 0, they will be performed in the order that they are added.
		 * 			// Note that "this" and "this.stage" are different objects, but it doesn't matter
		 * 			// because I haven't established target for this dispatch.
		 * 			NResponder.addNative(this, MouseEvent.MOUSE_DOWN, uncatchableListener);
		 * 			NResponder.dispatch(MouseEvent.MOUSE_DOWN, [null]);
		 * 			
		 * 			
		 * 			// Just remember, that native Flash Events expect only one parameter.
		 * 			// So if you try send a different number of parameter, an exception will thrown.
		 * 			//NResponder.dispatch(MouseEvent.MOUSE_DOWN, null, this);
		 * 			//NResponder.dispatch(MouseEvent.MOUSE_DOWN, [null, 0, true], this);
		 * 			
		 * 			// And if you click on the stage, two NResponder will be dispatched.
		 * 		}
		 * 		
		 * 		private function actionListener(aString:String = null):void
		 * 		{
		 * 			trace('OK, actionListener is catched with parameter', aString);
		 * 		}
		 * 		
		 * 		private function anotherListener():void
		 * 		{
		 * 			trace('OK, anotherListener is catched with set target', NResponder.currentTarget);
		 * 		}
		 * 		
		 * 		private function downHandler(e:MouseEvent):void
		 * 		{
		 * 			trace('OK, MouseDown --- Originally was set as first to MOUSE_DOWN');
		 * 		}
		 * 		
		 * 		private function clickListener(e:MouseEvent):void
		 * 		{
		 * 			trace('OK, ClickListener  --- Originally was set as last to MOUSE_DOWN');
		 * 		}
		 * 		
		 * 		private function uncatchableListener(e:MouseEvent):void
		 * 		{
		 * 			trace('This listener can`t be catched by a real click, because this object is empty on stage');
		 * 		}
		 * 	}
		 * }
		 * </listing>
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function dispatch(action:String = null, params:Array = null, toTarget:Object = null):void
		{
			CORE.dispatch(action, params, toTarget);
		}
		
		/**
		 * Immediately stop the propagation of an Action.
		 * Just can be used during the dispatch process of a NResponder Action.
		 * 
		 * When you stop the propagation of an Action any attributes of the following stoped NResponders take
		 * no effects, like replies or delays.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function stopPropagate():void
		{
			CORE.stopPropagate = true;
		}
		
		/**
		 * This method force to perform only this NResponder without dispatch the corresponding
		 * NResponder Action.
		 * Using this method directly, the number of replies to this NResponder will not be changed.
		 * 
		 * <p/>
		 * 
		 * You can obey to delay if you want. This means that if you want obey to delay, the <code>perform</code>
		 * method only will perform the listener if delay time was passed until the last <code>dispath</code>
		 * or <code>perform</code>.
		 * 
		 * @param	withParams	An Array with parameter to directly pass to the listener.
		 * 
		 * @param	waitDelay	You can follow the delay instructions defined to this NResponder.
		 * 
		 * @return				If the listener is performed return <code>true</code>, otherwise if this
		 * NResponder are in the delay time return <code>false</code>.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function perform(withParams:Array = null, waitDelay:Boolean = false):Boolean 
		{
			if (waitDelay && paused || (delay * 1000) + $lastDelay > getTimer())
			{
				return false;
			}
			
			// Call a listener in this NResponder Chain.
			$listener.apply(null, withParams);
			
			// Register the time of this perform.
			$lastDelay = getTimer();
			
			return true;
		}
		
	//**********************************************************************************************************
	//
	//  Getters / Setters
	//
	//**********************************************************************************************************
		
		/**
		 * The order of this NResponder
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function get order():uint { return $order; }
		
		public function set order(index:uint):void
		{
			$order = index;
		}
		
		/**
		 * Return the Object associated with current called listener of a NResponder Action.
		 * 
		 * <p/>
		 * 
		 * This method just return an Object if the called listener are in execution and if an Object was
		 * previously associated with it. Otherwise, will return <code>null</code>.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function get currentTarget():Object { return CORE.currentTarget; }
		
		/**
		 * Return the Action that is under execution in this moment.
		 * 
		 * <p/>
		 * 
		 * This method just return an Action if some Action is in execution.
		 * Otherwise, will return <code>null</code>.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function get currentAction():String { return CORE.currentAction; }
		
		/**
		 * Return the current NResponder that is under execution in this moment.
		 * 
		 * <p/>
		 * 
		 * This method just return a NResponder if some is in execution.
		 * Otherwise, will return <code>null</code>.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function get currentNResponder():NResponder { return CORE.currentNResponder; }
		
		/**
		 * [read-only] The NResponder Action associated with this NResponder.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function get action():String { return $action; }
		
		/**
		 * [read-only] The target defined to this NResponder. Return null if no target was defined.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function get target():Object { return $target; }
		
		/**
		 * [read-only] The listener defined to this NResponder.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function get listener():Function { return $listener; }
		
		/**
		 * [read-only] Indicate if this NResponder perform a native event API of Adobe® Flash®.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function get isNative():Boolean { return $isNative; }
		
		/**
		 * [read-only] [internal use] Unique identification for this instance based on its attributes.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function get hash():uint { return $hash; }
		
	}
}