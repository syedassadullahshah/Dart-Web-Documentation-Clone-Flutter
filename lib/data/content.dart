List content = [
  '''
# Dart Basics
The following code uses many of Dart’s most basic features:

       
        // Define a function.
        printInteger(int aNumber) {
          print('The number is \$aNumber.'); // Print to console.
        }

        // This is where the app starts executing.
        main() {
          var number = 42;            // Declare and initialize a variable.
          printInteger(number);       // Call a function.
        }
      


Here’s what this program uses that applies to all (or almost all) Dart apps: 
## // This is a comment.
A single-line comment. Dart also supports multi-line and document comments. For details, see Comments.
## int
A type. Some of the other built-in types are String, List, and bool.
## 42
A number literal. Number literals are a kind of compile-time constant.
## print()
A handy way to display output.
## '...' (or "...")
A string literal.
## \$variableName (or \${expression})
String interpolation: including a variable or expression’s string equivalent inside of a string literal. For more information, see Strings.
## main()
The special, required, top-level function where app execution starts. For more information, see The main() function.
## var
A way to declare a variable without specifying its type.
''',
  '''
# Built-in types
The Dart language has special support for the following types:

* numbers
* strings
* booleans
* lists (also known as arrays)
* sets
* maps
* runes (for expressing Unicode characters in a string)
* symbols

You can initialize an object of any of these special types using a literal. For example, 'this is a string' is a string literal, and true is a boolean literal.
Because every variable in Dart refers to an object—an instance of a class—you can usually use constructors to initialize variables. Some of the built-in types have their own constructors. For example, you can use the Map() constructor to create a map.
''',
  '''
# Functions
Dart is a true object-oriented language, so even functions are objects and have a type, Function. This means that functions can be assigned to variables or passed as arguments to other functions. You can also call an instance of a Dart class as if it were a function. For details, see Callable classes.
Here’s an example of implementing a function:

    bool isNoble(int atomicNumber) {
      return _nobleGases[atomicNumber] != null;
    }
Although Effective Dart recommends type annotations for public APIs, the function still works if you omit the types:

    isNoble(atomicNumber) {
      return _nobleGases[atomicNumber] != null;
    }
For functions that contain just one expression, you can use a shorthand syntax:

    bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
The => expr syntax is a shorthand for { return expr; }. The => notation is sometimes referred to as arrow syntax.
## Note: 
Only an expression—not a statement—can appear between the arrow (=>) and the semicolon (;). For example, you can’t put an if statement there, but you can use a conditional expression.
''',
  '''
# Control Flow Statements
You can control the flow of your Dart code using any of the following:

* if and else
* for loops
* while and do-while loops
* break and continue
* switch and case
* assert
You can also affect the control flow using try-catch and throw, as explained in Exceptions.
''',
  '''
# Classes
Dart is an object-oriented language with classes and mixin-based inheritance. Every object is an instance of a class, and all classes descend from Object. Mixin-based inheritance means that although every class (except for Object) has exactly one superclass, a class body can be reused in multiple class hierarchies. Extension methods are a way to add functionality to a class without changing the class or creating a subclass.
''',
  '''
# Extension Method
Extension methods, introduced in Dart 2.7, are a way to add functionality to existing libraries. You might use extension methods without even knowing it. For example, when you use code completion in an IDE, it suggests extension methods alongside regular methods.
## Using extension methods
Like all Dart code, extension methods are in libraries. You’ve already seen how to use an extension method — just import the library it’s in, and use it like an ordinary method:

    // Import a library that contains an extension on String.
    import 'string_apis.dart';
    // ···
    print('42'.padLeft(5)); // Use a String method.
    print('42'.parseInt()); // Use an extension method.
That’s all you usually need to know to use extension methods. As you write your code, you might also need to know how extension methods depend on static types (as opposed to dynamic) and how to resolve API conflicts.
''',
  '''
# NUll Safety
Null safety is the largest change we’ve made to Dart since we replaced the original unsound optional type system with a sound static type system in Dart 2.0. When Dart first launched, compile-time null safety was a rare feature needing a long introduction. Today, Kotlin, Swift, Rust, and other languages all have their own answers to what has become a very familiar problem. Here is an example:

    // Without null safety:
    bool isEmpty(String string) => string.length == 0;

    main() {
      isEmpty(null);
    }
If you run this Dart program without null safety, it throws a NoSuchMethodError exception on the call to .length. The null value is an instance of the Null class, and Null has no “length” getter. Runtime failures suck. This is especially true in a language like Dart that is designed to run on an end-user’s device. If a server application fails, you can often restart it before anyone notices. But when a Flutter app crashes on a user’s phone, they are not happy. When your users aren’t happy, you aren’t happy.

Developers like statically-typed languages like Dart because they enable the type checker to find mistakes in code at compile time, usually right in the IDE. The sooner you find a bug, the sooner you can fix it. When language designers talk about “fixing null reference errors”, they mean enriching the static type checker so that the language can detect mistakes like the above attempt to call .length on a value that might be null.

There is no one true solution to this problem. Rust and Kotlin both have their own approach that makes sense in the context of those languages. This doc walks through all the details of our answer for Dart. It includes changes to the static type system and a suite of other modifications and new language features to let you not only write null-safe code but hopefully to enjoy doing so.

This document is long. If you want something shorter that covers just what you need to know to get up and running, start with the overview. When you are ready for a deeper understanding and have the time, come back here so you can understand how the language handles null, why we designed it that way, and how to write idiomatic, modern, null-safe Dart. (Spoiler alert: it ends up surprisingly close to how you write Dart today.)

The various ways a language can tackle null reference errors each have their pros and cons. These principles guided the choices we made:

* Code should be safe by default. If you write new Dart code and don’t use any explicitly unsafe features, it never throws a null reference error at runtime. All possible null reference errors are caught statically. If you want to defer some of that checking to runtime to get greater flexibility, you can, but you have to choose that by using some feature that is textually visible in the code.

* In other words, we aren’t giving you a life jacket and leaving it up to you to remember to put it on every time you go out on the water. Instead, we give you a boat that doesn’t sink. You stay dry unless you jump overboard.

* Null safe code should be easy to write. Most existing Dart code is dynamically correct and does not throw null reference errors. You like your Dart program the way it looks now, and we want you to be able to keep writing code that way. Safety shouldn’t require sacrificing usability, paying penance to the type checker, or having to significantly change the way you think.

* The resulting null safe code should be fully sound. “Soundness” in the context of static checking means different things to different people. For us, in the context of null safety, that means that if an expression has a static type that does not permit null, then no possible execution of that expression can ever evaluate to null. The language provides this guarantee mostly through static checks, but there can be some runtime checks involved too. (Though, note the first principle: any place where those runtime checks happen will be your choice.)

* Soundness is important for user confidence. A boat that mostly stays afloat is not one you’re enthused to brave the open seas on. But it’s also important for our intrepid compiler hackers. When the language makes hard guarantees about semantic properties of a program, it means that the compiler can perform optimizations that assume those properties are true. When it comes to null, it means we can generate smaller code that eliminates unneeded null checks, and faster code that doesn’t need to verify a receiver is non-null before calling methods on it.

* One caveat: We only guarantee soundness in Dart programs that are fully null safe. Dart supports programs that contain a mixture of newer null safe code and older legacy code. In these “mixed-mode” programs, null reference errors may still occur. In a mixed-mode program, you get all of the static safety benefits in the portions that are null safe, but you don’t get full runtime soundness until the entire application is null safe.

Note that eliminating null is not a goal. There’s nothing wrong with null. On the contrary, it’s really useful to be able to represent the absence of a value. Building support for a special “absent” value directly into the language makes working with absence flexible and usable. It underpins optional parameters, the handy ?. null-aware operator, and default initialization. It is not null that is bad, it is having null go where you don’t expect it that causes problems.

Thus with null safety, our goal is to give you control and insight into where null can flow through your program and certainty that it can’t flow somewhere that would cause a crash
'''
];
