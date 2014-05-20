#import "Rating.h"

#import "iRate.h"


void DCRatingExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &DCRatingContextInitializer;
    *ctxFinalizerToSet = &DCRatingContextFinalizer;
}

void DCRatingExtFinalizer(void* extData)
{
    //    NSLog(@"Entering RateExtFinalizer()");
    // Nothing to clean up.
    //    NSLog(@"Exiting RateExtFinalizer()");
//    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void DCRatingContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] =
    {
//        MAP_FUNCTION(isSupported, NULL),
        MAP_FUNCTION(shouldPromptForRating, NULL),
        MAP_FUNCTION(applicationLaunched, NULL),
        MAP_FUNCTION(logEvent, NULL),
        MAP_FUNCTION(promptForRating, NULL),
        MAP_FUNCTION(promptIfNetworkAvailable, NULL),
        MAP_FUNCTION(openRatingsPageInAppStore, NULL),
        
        // Properties
        MAP_FUNCTION(setPropertyBool, NULL),
        MAP_FUNCTION(getPropertyBool, NULL),
        MAP_FUNCTION(setPropertyNumber, NULL),
        MAP_FUNCTION(getPropertyNumber, NULL),
        MAP_FUNCTION(setPropertyString, NULL),
        MAP_FUNCTION(getPropertyString, NULL)
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void DCRatingContextFinalizer(FREContext ctx)
{
    //    NSLog(@"Entering ContextFinalizer()");
    
    // Nothing to clean up.
    //    NSLog(@"Exiting ContextFinalizer()");
//    return;
}

//ANE_FUNCTION(isSupported)
//{
//    FREObject fo;
//    
//    FREResult aResult = FRENewObjectFromBool(YES, &fo);
//    if (aResult == FRE_OK)
//    {
//        //things are fine
//        NSLog(@"Result = %d", aResult);
//    }
//    else
//    {
//        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
//        NSLog(@"Result = %d", aResult);
//    }
//    return fo;
//}


ANE_FUNCTION(shouldPromptForRating)
{
    FREObject fo;
    FREResult aResult = FRENewObjectFromBool([[iRate sharedInstance] shouldPromptForRating], &fo);
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
	return fo;
}

ANE_FUNCTION(applicationLaunched)
{
    if ([[iRate sharedInstance] shouldPromptForRating])
    {
        [[iRate sharedInstance] promptIfNetworkAvailable];
    }
	return nil;
}

ANE_FUNCTION(logEvent)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    
    [[iRate sharedInstance] logEvent:(value>0)];
    
	return nil;
}

ANE_FUNCTION(promptForRating)
{
    [[iRate sharedInstance] promptForRating];
	return nil;
}

ANE_FUNCTION(promptIfNetworkAvailable)
{
    [[iRate sharedInstance] promptIfNetworkAvailable];
	return nil;
}

ANE_FUNCTION(openRatingsPageInAppStore)
{
    [[iRate sharedInstance] openRatingsPageInAppStore];
	return nil;
}

// Get property name marco
#define GET_PROPERTY_NAME() \
uint32_t length = 0;\
const uint8_t *property = NULL;\
FREGetObjectAsUTF8( argv[0], &length, &property);\
NSString *propertyName=[NSString stringWithUTF8String:(char *)property];


// Properties

ANE_FUNCTION(setPropertyNumber)
{
    GET_PROPERTY_NAME()
    
    // Check if property exisit
    
    // Set the value
    int32_t numberValue;
    FREGetObjectAsInt32(argv[1], &numberValue);
    [[iRate sharedInstance] setValue:[NSNumber numberWithFloat:numberValue] forKey:propertyName];
    
	return nil;
}

ANE_FUNCTION(setPropertyString)
{
    GET_PROPERTY_NAME()
    // Set the value
    const uint8_t *stringValue = NULL;
    FREGetObjectAsUTF8(argv[1], &length, &stringValue);
    [[iRate sharedInstance] setValue:[NSString stringWithUTF8String:(char *)stringValue] forKey:propertyName];
    
	return nil;
}

ANE_FUNCTION(setPropertyBool)
{
    GET_PROPERTY_NAME()
    // Set the value
    uint32_t boolValue=0;
    FREGetObjectAsBool(argv[1], &boolValue);
    [[iRate sharedInstance] setValue:[NSNumber numberWithFloat:boolValue] forKey:propertyName];
    
	return nil;
}

ANE_FUNCTION(getPropertyNumber)
{
    
    // Get property name
    GET_PROPERTY_NAME()
    // Set the value
    FREObject fo;
    NSNumber *number=[[iRate sharedInstance] valueForKey:propertyName];
    FRENewObjectFromDouble([number doubleValue], &fo);
    
	return fo;
}

ANE_FUNCTION(getPropertyString)
{
    
    // Get property name
    GET_PROPERTY_NAME()
    // Set the value
    if([propertyName isEqualToString:@"packageName"]) return nil;
    
    FREObject fo;
    NSString *str=[[iRate sharedInstance] valueForKey:propertyName];
    FRENewObjectFromUTF8((uint32_t)str.length, (uint8_t *)[str UTF8String], &fo);
	return fo;
}

ANE_FUNCTION(getPropertyBool)
{
    
    // Get property name
    GET_PROPERTY_NAME()
    // Set the value
    FREObject fo;
    NSNumber *number=[[iRate sharedInstance] valueForKey:propertyName];
    FRENewObjectFromBool([number unsignedIntValue], &fo);
	return fo;
}
