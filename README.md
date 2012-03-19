#Introduction#

##Selfhub iOS application##

ABOUT THE APPLICATION

SelfHub - opensource modular application for IOS, designed for the collection, storage and analysis of various health data from sensors, manual monitring and interacting with cloud serices. The ultimate goal is to create a diagnosis application with a number of indicators which can at the right time inform user about the need to seek medical help. 


#About modular architecture#

To simplify the development process and the independence, the application uses a modular architecture. Each module performs the collection and processing of certain information from a medical area. For example, a module of weight control, blood pressure control module, the module controls the blood sugar, etc. In addition to the control module is necessary to develop analysis modules that use these modules, control and perform some diagnostic functions.

#Design pattern#
The general concept of an application - NavigationBar. The main form (call it server side applications, or simply server) displays a list of all modules and allows you to switch between them. The server accepts the protocol ServerProtocol and is a delegate for each module. Any exchange of data between modules is done using the methods the protocol ServerProtocol:

<code>
- (BOOL) isModuleAvailableWithID: (NSString *);
</code>

Return true if the module is loaded with the specified identifier

<code>
- (Id) getValueForName: (NSString *) fromModuleWithID: (NSString *);
</code>

Get the value of the parameter with the given name (from the Exchange-list) from the module with the specified ID

<code>
- (BOOL) setValue: (id) forName: (NSString *) forModuleWithID: (NSString *);
</code>


Set the value with the given name (from the Exchange-list) in the module with the specified identifier (parameter should NOT be marked as read-only)

To ensure the exchange of data in each module should be formed by Exchange-list. Its structure is described in paragraph 1.4.

### List of loaded modules ###

At boot time, the main view, is read from the file AllModules.plist list of all modules. It contains an array of NSDictionary, which consist of the following keys:

* Interface - a module class name (String)
* ID - ID of a text module, for example selfhub.module_name (String)
* ExchangeFile - the name of the file containing the Exchange-list (String)
* Type - type of unit, reserved for future use (Integer)

Identifiers of different modules must be different. List of modules loaded once when the application starts. You can also appeal to this file when using auxiliary testing functions.

### Requirements applicable to the module ###

* There are currently modules are implemented as open source in the main project. The use of modules in the form of loadable libraries will be introduced as needed.
* The project unit is located in the folder Modules\module_name\
* Module class inherits from UIViewController.
* The transition between representations within a module and return to the main view is a Navigation Bar.
* The module accepts and implements the protocol ModuleProtocol in itself all of its required function (item 1.3).
* Basic language - English. Localization of the module is done using a macro NSLocalizedString. Do not use other localized resources, such as pictures, *. Nib files, etc. - this complicates the process of localization to other languages. All text fields in the interface module must be initialized by software in the method of using a macro viewDidLoad NSLocalizedString (@ "My_string", @ ""). Localized strings should be added to the project file \Localizations\Localizable.strings in a separate section of the module (separated by comments from other lines).
* The module stores its data in a subdirectory named after the ID of the module (eg, ~\Documents\selfhub.module_name\).
* The module should be implemented all the functions to allocate and free memory (viewDidUnload, dealloc), because when you receive a message about the lack of memory of the unused modules can be unloaded from the memory of the server.
* Any resource file must begin with the name or identifier of the module (eg, module_name.mainframe.png). All modules are collected in a single Bundle, which can cause conflicts with the naming of resources.
* The module must meet all the requirements of Apple's software development at IOS, as well as the requirements of the iPhone HIG (Human Interface Guidelines).
* The work unit should be independent of the server-side applications. It is assumed that if you insert a module into a new project - it will work well.
* The module must independently read and write the necessary data to it (it is advisable to do so in the methods and viewWillAppear viewDidDisappear respectively). In case of necessity (at least when loading all modules), server-side application can initiate a self-loading or saving data through the protocol module ModuleProtocol.
* The attributes described in the Exchange-list, shall meet the requirements of the KVC (Key-Value Coding)

### Call Protocol ModuleProtocol ###
#### The methods required to implement ####

<code>
- (Id) initModuleWithDelegate: (id <ServerProtocol>) serverDelegate;
</code>

The function to call when initializing the server module. The parameter passed to the delegate server.

<code>
- (NSString *) getModuleName;
</code>
	
Returns the localized name of the module (shown in the table of the main presentation).

<code>
- (NSString *) getModuleDescription;
</code>

Returns a localized description of the module (shown in the table the main presentation).

<code>
- (NSString *) getModuleMessage;
</code>

Localized message module (shown in the table the main presentation). The report is addressed to the user and the short form notifies him of the operation of the module (for example, a reminder of the need to conduct regular measurements of weight).

<code>
- (UIImage *) getModuleIcon;
</code>


Icon of the module to be displayed in the main table view. The size of icons: 120x120. Format - PNG

<code>
- (BOOL) isInterfaceIdiomSupportedByModule: (UIUserInterfaceIdiom) idiom;
</code>

Returns true if the support of the transferred model interface (iphone\ipad). IPhone model should be supported in any way.

<code>
- (Void) loadModuleData;
</code>

Loading data module. The method is called by the module when the need to download the stored data, as well as part of the application server to initialize the module.

<code>
- (Void) saveModuleData;
</code>

Data storage module. The method is called by the module when the need to maintain operational data, as well as server side application when the module is unloaded from memory.

#### Optional methods ####

<code>
- (Float) getModuleVersion;
</code>

Returns the version of the module (1.0 by default)

### Format of the list of Exchange-list #

List of Exchange-list stored in the plist-file (for example, module_name.export.plist). The main element of the list - an array named items. Each array element is an object NSDictionary with the following keys:

* name (type String) - name of the exchange-mandatory parameter that is used by other modules when requesting a server-side parameter of this module. Uniquely in the current module;
* keypath (type String) - Key binding module that is passed to the method of [ModuleViewController valueForKeyPath:] when prompted for the parameter with the name of the module name;
* type (type String) - type of the parameter (NSString, NSNumber, NSDictionary, NSData, etc). In the process of obtaining the parameters is not involved. Carries the meaning of information to other developers about the type Gets or sets the parameter;
* readonly (type BOOL) - if set to YES, the parameter can not be installed outside the module. By default (if this field is absent) option is available for reading and writing;
* description (type String) - description of the parameter. An optional field that carries information purposes for other developers.
In forming the Exchange-list, to verify the correctness of the description of the parameters you can use the testExchangeListForModuleWithID: from the helper class ModuleHelper:
<code>
[[ModuleHelper sharedHelper] testExchangeListForModuleWithID: @ "selfhub.moduleID"];
</code>
The method attempts to read and write parameters for a given module, according to the list of Exchange-list and displays diagnostic messages to the console. In the case of a critical error happens to crash the application.

### Class ModuleHelper ###

The class contains helper methods used in the design of the module. Access methods are as follows:

<code>
[[ModuleHelper sharedHelper] selector];
</code>


###ROADMAP###

Modules

* Weight Control
* Dropbox integration
* Withings Body Scale integration

