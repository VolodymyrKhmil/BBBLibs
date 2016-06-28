#import <objc/runtime.h>

- (void*)getValueWithName:(const char*)varName forClass:(NSString*)className {
    unsigned int varCount;
    
    Class theClass = NSClassFromString(className);
    Ivar *vars = class_copyIvarList(theClass, &varCount);
    
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        
        const char* name = ivar_getName(var);
        if (strcmp(name, varName) == 0) {
            ptrdiff_t offset = ivar_getOffset(var);
            unsigned char* bytes = (unsigned char *)(__bridge void*)self;
            free(vars);
            return (bytes+offset);
        }
        
    }
    
    
    
    free(vars);
    return NULL;
}

//NSInteger integer = *(NSInteger*)[self getValueWithName:"integer" forClass:@"ClassName"];
//BOOL bool = *(BOOL*)[self getValueWithName:"boolean" forClass:@"ClassName"];
//NSString *string = *((__unsafe_unretained NSString **)([self getValueWithName:"string" forClass:@"ClassName"]));
