---
layout: post
title:  "Java Basic  Part 1"
author: haran
categories: [java,javabasic]
image: post_img/2022/java_basic/1/java.gif
beforetoc: "Java intro , Classes , Methods , Keywords and Expressions ,variable init ,Reading user Input , References vs Objects vs Instances vs Class , Statements whitespaces and Indention , Operators and Operators procedence , Parsing Values from String"
toc: true
---

Java intro , Classes , Methods , Keywords and Expressions ,variable init ,Reading user Input , References vs Objects vs Instances vs Class , Statements whitespaces and Indention , Operators and Operators procedence , Parsing Values from String


``` java

java -version

```

[[4-variable_init]]

## Classes
### Packages in Java
>- Class is an blueprint for the object that we are creating 
>- we can create some variables part of this class  

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/1.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/2.png)

>- Public other classes that we are created access to this class without being restricted

>- Local variables are variables which belongs to that method.
>- Most of the methods in classes are private 
>- To enhance encapsulation which hide fields and methods from access publically.
>- Internal definition hidden from view outside the object's definition .
>- Internal newly created object only can access the methods and fields
>-  These variables are state component from a class.

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/3.png)

>- State of the car we define as fields.


![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/4.png)

>- Car class inherited some functionalities from the JavaObject  class. 

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/5.png)

>- Dont allow other classes to access these  internal fields 

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/6.png)

---
---

## Part 2 

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/7.png) 	

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/8.png) 	

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/9.png)

>- You created an object porshe but it could not initialized ,So null point exception.

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/10.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/11.png)

>- Null is an internal state default for class as well as String.

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/12.png)

[[Constructors]]

## Keywords and Expressions

> _ Underscore

Added in Java 9, the underscore has become a keyword and cannot be used as a variable name anymore.

> abstract

A method with no definition must be declared as abstract and the class containing it must be declared as abstract. Abstract classes cannot be instantiated. Abstract methods must be implemented in the sub classes. The abstract keyword cannot be used with variables or constructors. Note that an abstract class isn't required to have an abstract method at all.

>assert

Assert describes a predicate (a true–false statement) placed in a Java program to indicate that the developer thinks that the predicate is always true at that place. If an assertion evaluates to false at run-time, an assertion failure results, which typically causes execution to abort. Optionally enable by ClassLoader method.

>boolean

Defines a boolean variable for the values "true" or "false" only. By default, the value of boolean primitive type is false. This keyword is also used to declare that a method returns a value of the primitive type 

>break

Used to end the execution in the current loop body.

>byte

The `byte` keyword is used to declare a field that can hold an 8-bit signed two's complement integer.

This keyword is also used to declare that a method returns a value of the primitive type `byte`.

>case

block can be labeled with one or more or  statement evaluates its expression, then executes all statements that follow the matching 


>catch

Used in conjunction with a `try` block and an optional `finally` block. The statements in the `catch` block specify what to do if a specific type of exception is thrown by the `try` block.

>char

Defines a character variable capable of holding any character of the java source file's character set.

>class

A type that defines the implementation of a particular kind of object. A class definition defines of the class.

If the superclass is not explicitly specified, the superclass is implicitly .

The class keyword can also be used in the form Class**.class** to get a Class object without needing an instance of that class. For example, **String.class** can be used instead of doing **new String().getClass()**.

>const

Unused but reserved.

>continue

Used to resume program execution at the end of the current loop body. If followed by a label, `continue` resumes execution at the end of the enclosing labeled loop body.

>default

The `default` keyword can optionally be used in a to label a block of statements to be executed if no `case` matches the specified value; see 

>switch

Alternatively, the `default` keyword can also be used to declare default values in a [Java annotation](https://en.wikipedia.org/wiki/Java_annotation "Java annotation"). From Java 8 onwards, the `default` keyword can be used to allow an interface to provide an implementation of a method.

>do

The `do` keyword is used in conjunction with 

while(to create a [do-while loop](https://en.wikipedia.org/wiki/Do-while_loop "Do-while loop"), which executes a block of statements associated with the loop and then tests a boolean expression associated with the `while`. If the expression evaluates to `true`, the block is executed again; this continues until the expression evaluates to `false`.[\[11\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-do-while-11)[\[12\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200548-49-12)

>double

The `double` keyword is used to declare a variable that can hold a 64-bit [double precision](https://en.wikipedia.org/wiki/Double_precision "Double precision") [IEEE 754](https://en.wikipedia.org/wiki/IEEE_754 "IEEE 754") [floating-point number](https://en.wikipedia.org/wiki/Floating-point_number "Floating-point number").[\[5\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-primitive-5)[\[6\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200522-6) This keyword is also used to declare that a method returns a value of the primitive type `double`.[\[7\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-return-7)[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>else

The `else` keyword is used in conjunction with `[if](https://en.wikipedia.org/wiki/List_of_Java_keywords#if)` to create an [if-else statement](https://en.wikipedia.org/wiki/Conditional_(programming) "Conditional (programming)"), which tests a [boolean expression](https://en.wikipedia.org/wiki/Boolean_expression "Boolean expression"); if the expression evaluates to `true`, the block of statements associated with the `if` are evaluated; if it evaluates to `false`, the block of statements associated with the `else` are evaluated.[\[13\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-if-else-13)[\[14\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200544-46-14)

>enum

A Java keyword used to declare an [enumerated type](https://en.wikipedia.org/wiki/Enumerated_type "Enumerated type"). Enumerations extend the base class `[Enum](https://docs.oracle.com/javase/10/docs/api/java/lang/Enum.html)`.

>extends

Used in a class declaration to specify the superclass; used in an interface declaration to specify one or more superinterfaces. Class X extends class Y to add functionality, either by adding fields or methods to class Y, or by overriding methods of class Y. An interface Z extends one or more interfaces by adding methods. Class X is said to be a subclass of class Y; Interface Z is said to be a subinterface of the interfaces it extends.

Also used to specify an upper bound on a type parameter in Generics.

>final

Define an entity once that cannot be changed nor derived from later. More specifically: a final class cannot be subclassed, a final method cannot be overridden, and a final variable can occur at most once as a left-hand expression on an executed command. All methods in a final class are implicitly.

>final

Used to define a block of statements for a block defined previously by the `try` keyword. The `finally` block is executed after execution exits the `try` block and any associated `catch` clauses regardless of whether an exception was thrown or caught, or execution left method in the middle of the `try` or `catch` blocks using the `return` keyword.

>float

The `float` keyword is used to declare a variable that can hold a 32-bit [single precision](https://en.wikipedia.org/wiki/Single_precision "Single precision") IEEE 754 floating-point number.[\[5\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-primitive-5)[\[6\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200522-6) This keyword is also used to declare that a method returns a value of the primitive type `float`.[\[7\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-return-7)[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>for

The `for` keyword is used to create a [for loop](https://en.wikipedia.org/wiki/For_loop "For loop"), which specifies a variable initialization, a [boolean expression](https://en.wikipedia.org/wiki/Boolean_expression "Boolean expression"), and an incrementation. The variable initialization is performed first, and then the boolean expression is evaluated. If the expression evaluates to `true`, the block of statements associated with the loop are executed, and then the incrementation is performed. The boolean expression is then evaluated again; this continues until the expression evaluates to `false`.[\[15\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-for-15)

As of [J2SE 5.0](https://en.wikipedia.org/wiki/J2SE_5.0 "J2SE 5.0"), the `for` keyword can also be used to create a so-called "[enhanced for loop](https://en.wikipedia.org/wiki/Foreach "Foreach")",[\[16\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200550-54-16) which specifies an [array](https://en.wikipedia.org/wiki/Array_data_type "Array data type") or `[Iterable](https://docs.oracle.com/javase/10/docs/api/java/lang/Iterable.html)` object; each iteration of the loop executes the associated block of statements using a different element in the array or `Iterable`.[\[15\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-for-15)

>goto

Unused

>if

The `if` keyword is used to create an [if statement](https://en.wikipedia.org/wiki/If_statement "If statement"), which tests a [boolean expression](https://en.wikipedia.org/wiki/Boolean_expression "Boolean expression"); if the expression evaluates to `true`, the block of statements associated with the if statement is executed. This keyword can also be used to create an [if-else statement](https://en.wikipedia.org/wiki/Conditional_(programming) "Conditional (programming)"); see _`[else](https://en.wikipedia.org/wiki/List_of_Java_keywords#else)`_.[\[13\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-if-else-13)[\[14\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200544-46-14)

>implements

Included in a class declaration to specify one or more [interfaces](https://en.wikipedia.org/wiki/Interface_(Java) "Interface (Java)") that are implemented by the current class. A class inherits the types and abstract methods declared by the interfaces.

>import

Used at the beginning of a [source file](https://en.wikipedia.org/wiki/Source_file "Source file") to specify classes or entire [Java packages](https://en.wikipedia.org/wiki/Java_package "Java package") to be referred to later without including their package names in the reference. Since J2SE 5.0, `import` statements can import `static` members of a class.

>instanceof

A [binary operator](https://en.wikipedia.org/wiki/Operator_(programming) "Operator (programming)") that takes an object reference as its first operand and a class or interface as its second operand and produces a boolean result. The `instanceof` operator evaluates to true if and only if the runtime type of the object is assignment compatible with the class or interface.

>int

The `int` keyword is used to declare a variable that can hold a 32-bit signed two's complement integer.[\[5\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-primitive-5)[\[6\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200522-6) This keyword is also used to declare that a method returns a value of the primitive type `int`.[\[7\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-return-7)[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>interface

Used to declare a special type of class that only contains abstract or default methods, constant (`static final`) fields and `static` interfaces. It can later be implemented by classes that declare the interface with the `implements` keyword. As multiple inheritance is not allowed in Java, interfaces are used to circumvent it. An interface can be defined within another interface.

>long

The `long` keyword is used to declare a variable that can hold a 64-bit signed two's complement integer.[\[5\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-primitive-5)[\[6\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200522-6) This keyword is also used to declare that a method returns a value of the primitive type `long`.[\[7\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-return-7)[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>native

Used in method declarations to specify that the method is not implemented in the same Java source file, but rather in another language.[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>new

Used to create an instance of a class or array object. Using keyword for this end is not completely necessary (as exemplified by [Scala](https://en.wikipedia.org/wiki/Scala_(programming_language) "Scala (programming language)")), though it serves two purposes: it enables the existence of different namespace for methods and class names, it defines statically and locally that a fresh object is indeed created, and of what runtime type it is (arguably introducing dependency into the code).

>non-sealed

Used to declare that a class or interface which extends a sealed class can be extended by unknown classes.[\[17\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-17)

>package

Java package is a group of similar classes and interfaces. Packages are declared with the `package` keyword.

>private

The `private` keyword is used in the declaration of a method, field, or inner class; private members can only be accessed by other members of their own class.[\[18\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-access-18)

>protected

The `protected` keyword is used in the declaration of a method, field, or inner class; protected members can only be accessed by members of their own class, that class's [subclasses](https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming) "Inheritance (object-oriented programming)") or classes from the same [package](https://en.wikipedia.org/wiki/Java_package "Java package").[\[18\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-access-18)

>public

The `public` keyword is used in the declaration of a class, method, or field; public classes, methods, and fields can be accessed by the members of any class.[\[18\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-access-18)

>return
Used to finish the execution of a method. It can be followed by a value required by the method definition that is returned to the caller.

>short

The `short` keyword is used to declare a field that can hold a 16-bit signed two's complement integer.[\[5\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-primitive-5)[\[6\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200522-6) This keyword is also used to declare that a method returns a value of the primitive type `short`.[\[7\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-return-7)[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>static

Used to declare a field, method, or inner class as a class field. Classes maintain one copy of class fields regardless of how many instances exist of that class. `static` also is used to define a method as a class method. Class methods are [bound](https://en.wikipedia.org/wiki/Name_binding "Name binding") to the class instead of to a specific instance, and can only operate on class fields. (Classes and interfaces declared as `static` members of another class or interface are actually top-level classes and are _not_ inner classes.)

>strictfp

A Java keyword used to restrict the precision and rounding of floating point calculations to ensure portability.[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8)

>super

Inheritance basically used to achieve dynamic binding or run-time polymorphism in java. Used to access members of a class inherited by the class in which it appears. Allows a subclass to access [overridden](https://en.wikipedia.org/wiki/Method_overriding_(programming) "Method overriding (programming)") methods and hidden members of its superclass. The `super` keyword is also used to forward a call from a constructor to a constructor in the superclass.

Also used to specify a lower bound on a type parameter in Generics.

>switch

The `switch` keyword is used in conjunction with `[case](https://en.wikipedia.org/wiki/List_of_Java_keywords#case)` and `[default](https://en.wikipedia.org/wiki/List_of_Java_keywords#default)` to create a [switch statement](https://en.wikipedia.org/wiki/Switch_statement "Switch statement"), which evaluates a variable, matches its value to a specific `case`, and executes the block of statements associated with that `case`. If no `case` matches the value, the optional block labelled by `default` is executed, if included.[\[9\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-switch-9)[\[10\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200546-48-10)

>synchronized

Used in the declaration of a method or code block to acquire the [mutex](https://en.wikipedia.org/wiki/Mutex "Mutex") lock for an object while the current [thread](https://en.wikipedia.org/wiki/Thread_(computer_science) "Thread (computer science)") executes the code.[\[8\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200566-67-8) For static methods, the object locked is the class's `Class`. Guarantees that at most one thread at a time operating on the same object executes that code. The mutex lock is automatically released when execution exits the synchronized code. Fields, classes and interfaces cannot be declared as _synchronized_.

>this

Used to represent an instance of the class in which it appears. `this` can be used to access class members and as a reference to the current instance. The `this` keyword is also used to forward a call from one constructor in a class to another constructor in the same class.

>throw

Causes the declared exception instance to be thrown. This causes execution to continue with the first enclosing exception handler declared by the `catch` keyword to handle an assignment compatible exception type. If no such exception handler is found in the current method, then the method returns and the process is repeated in the calling method. If no exception handler is found in any method call on the stack, then the exception is passed to the thread's uncaught exception handler.

>throws

Used in method declarations to specify which exceptions are not handled within the method but rather passed to the next higher level of the program. All uncaught exceptions in a method that are not instances of `RuntimeException` must be declared using the `throws` keyword.

>transient

Declares that an instance field is not part of the default [serialized](https://en.wikipedia.org/wiki/Serialization "Serialization") form of an object. When an object is serialized, only the values of its non-transient instance fields are included in the default serial representation. When an object is deserialized, transient fields are initialized only to their default value. If the default form is not used, e.g. when a _serialPersistentFields_ table is declared in the class hierarchy, all `transient` keywords are ignored.[\[19\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-serialSpec-19)[\[20\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-transient1-20)

>try

Defines a block of statements that have exception handling. If an exception is thrown inside the `try` block, an optional `catch` block can handle declared exception types. Also, an optional `finally` block can be declared that will be executed when execution exits the `try` block and `catch` clauses, regardless of whether an exception is thrown or not. A `try` block must have at least one `catch` clause or a `finally` block.

>void
The `void` keyword is used to declare that a method does not return any value.[\[7\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-return-7)

>volatile

Used in field declarations to guarantee visibility of changes to variables across threads. Every read of a volatile variable will be read from main memory, and not from the CPU cache, and that every write to a volatile variable will be written to main memory, and not just to the CPU cache.[\[21\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-Java_Volatile_Keyword-21) Methods, classes and interfaces thus cannot be declared _volatile_, nor can local variables or parameters.

>while

The `while` keyword is used to create a [while loop](https://en.wikipedia.org/wiki/While_loop "While loop"), which tests a [boolean expression](https://en.wikipedia.org/wiki/Boolean_expression "Boolean expression") and executes the block of statements associated with the loop if the expression evaluates to `true`; this continues until the expression evaluates to `false`. This keyword can also be used to create a [do-while loop](https://en.wikipedia.org/wiki/Do-while_loop "Do-while loop"); see _`[do](https://en.wikipedia.org/wiki/List_of_Java_keywords#do)`_.[\[11\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-do-while-11)[\[12\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-FOOTNOTEFlanagan200548-49-12)

## Reserved Identifiers\[[edit](https://en.wikipedia.org/w/index.php?title=List_of_Java_keywords&action=edit&section=2 "Edit section: Reserved Identifiers")\]

The following identifiers are not keywords, however they are restricted in some contexts:

>permits

The permits clause specifies the classes that are permitted to extend a sealed class.[\[22\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-22)

>record

>sealed

A sealed class or interface can only be extended or implemented only by classes and interfaces permitted to do so.[\[23\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-23)

>var

A special identifier that cannot be used as a type name (since Java 10).[\[24\]](https://en.wikipedia.org/wiki/List_of_Java_keywords#cite_note-24)

>yield

Used to set a value for a switch expression

[[6-Stataements whitespaces and indentation]]


## Vaiable initialization

- Varibale is a block in memory which used to save a value
  Mostly saved in stack memory.

``` java

public class Hello {

public static void main(String[] args){
    int firstNumber = 5 ;
    
    System.out.println(firstNumber) ;

    }
}
```

---

## Primitive Datatypes
> **Primitive data types** are those supported directly by the language and are not composed of any other **data types**. Kind of like they are atomic that way. The language has support for operations on those **data types** already. **Abstract data types** are created by users, and in libraries.

- Datatypes that are build in to the language.

- int 
- short
- byte
- Long

``` java

public class Hello {

public static void main(String[] args){
    int myMinValue = -2_147_483_648 ;
	
	byte myByte = -128
	
    short = 32767
	
	Long = 9_223-372_036_854_775_007L
	

    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/13.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/14.png)

### Type casting
- change one datatype in to another datatype

``` java

public class Hello {

public static void main(String[] args){
    
	byte myByte = -128
	
	byte newByteValue = (byte)(myByte/2)
	
    }
}
```

## Primitive Data Types 2

``` java

public class Hello {

public static void main(String[] args){
    
	float myFloat = 5f ;
	
	double newDouble = 5d ; //(5.6)
	
    }
}
```

- float 7 precision
- double 17 precision

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/15.png)

### character , boolean

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/16.png)

``` java

public class Hello {

public static void main(String[] args){
    
	char mychar = 'F' ;
	char uniCode = '\u00A9'
	
	boolean newBoolean = True ; 
	
    }
}
```


### String
``` java

public class Hello {

public static void main(String[] args){
    
	String myString = "This is myString" ;
	int myInt =  25
	
	String Full = myString + myInt ;
	// int converted in to string 
	
    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/17.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/18.png)


## Vaiable initialization
- Varibale is a block in memory which used to save a value
  Mostly saved in stack memory.

``` java

public class Hello {

public static void main(String[] args){
    int firstNumber = 5 ;
    
    System.out.println(firstNumber) ;

    }
}
```

---

## Primitive Datatypes
> **Primitive data types** are those supported directly by the language and are not composed of any other **data types**. Kind of like they are atomic that way. The language has support for operations on those **data types** already. **Abstract data types** are created by users, and in libraries.

- Datatypes that are build in to the language.

- int 
- short
- byte
- Long

``` java

public class Hello {

public static void main(String[] args){
    int myMinValue = -2_147_483_648 ;
	
	byte myByte = -128
	
    short = 32767
	
	Long = 9_223-372_036_854_775_007L
	

    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/19.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/20.png)

### Type casting
- change one datatype in to another datatype

``` java

public class Hello {

public static void main(String[] args){
    
	byte myByte = -128
	
	byte newByteValue = (byte)(myByte/2)
	
    }
}
```

## Primitive Data Types 2

``` java

public class Hello {

public static void main(String[] args){
    
	float myFloat = 5f ;
	
	double newDouble = 5d ; //(5.6)
	
    }
}
```

- float 7 precision
- double 17 precision

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/21.png)

### character , boolean

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/22.png)

``` java

public class Hello {

public static void main(String[] args){
    
	char mychar = 'F' ;
	char uniCode = '\u00A9'
	
	boolean newBoolean = True ; 
	
    }
}
```


### String
``` java

public class Hello {

public static void main(String[] args){
    
	String myString = "This is myString" ;
	int myInt =  25
	
	String Full = myString + myInt ;
	// int converted in to string 
	
    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/23.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/24.png)


## Vaiable initialization
- Varibale is a block in memory which used to save a value
  Mostly saved in stack memory.

``` java

public class Hello {

public static void main(String[] args){
    int firstNumber = 5 ;
    
    System.out.println(firstNumber) ;

    }
}
```

---

## Primitive Datatypes
> **Primitive data types** are those supported directly by the language and are not composed of any other **data types**. Kind of like they are atomic that way. The language has support for operations on those **data types** already. **Abstract data types** are created by users, and in libraries.

- Datatypes that are build in to the language.

- int 
- short
- byte
- Long

``` java

public class Hello {

public static void main(String[] args){
    int myMinValue = -2_147_483_648 ;
	
	byte myByte = -128
	
    short = 32767
	
	Long = 9_223-372_036_854_775_007L
	

    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/25.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/26.png)

### Type casting
- change one datatype in to another datatype

``` java

public class Hello {

public static void main(String[] args){
    
	byte myByte = -128
	
	byte newByteValue = (byte)(myByte/2)
	
    }
}
```

## Primitive Data Types 2

``` java

public class Hello {

public static void main(String[] args){
    
	float myFloat = 5f ;
	
	double newDouble = 5d ; //(5.6)
	
    }
}
```

- float 7 precision
- double 17 precision

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/27.png)

### character , boolean

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/28.png)

``` java

public class Hello {

public static void main(String[] args){
    
	char mychar = 'F' ;
	char uniCode = '\u00A9'
	
	boolean newBoolean = True ; 
	
    }
}
```


### String
``` java

public class Hello {

public static void main(String[] args){
    
	String myString = "This is myString" ;
	int myInt =  25
	
	String Full = myString + myInt ;
	// int converted in to string 
	
    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/29.png)

[[7-Operators and Operators procedence]]


## Vaiable initialization
- Varibale is a block in memory which used to save a value
  Mostly saved in stack memory.

``` java

public class Hello {

public static void main(String[] args){
    int firstNumber = 5 ;
    
    System.out.println(firstNumber) ;

    }
}
```

---

## Primitive Datatypes
> **Primitive data types** are those supported directly by the language and are not composed of any other **data types**. Kind of like they are atomic that way. The language has support for operations on those **data types** already. **Abstract data types** are created by users, and in libraries.

- Datatypes that are build in to the language.

- int 
- short
- byte
- Long

``` java

public class Hello {

public static void main(String[] args){
    int myMinValue = -2_147_483_648 ;
	
	byte myByte = -128
	
    short = 32767
	
	Long = 9_223-372_036_854_775_007L
	

    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/30.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/31.png)

### Type casting
- change one datatype in to another datatype

``` java

public class Hello {

public static void main(String[] args){
    
	byte myByte = -128
	
	byte newByteValue = (byte)(myByte/2)
	
    }
}
```

## Primitive Data Types 2

``` java

public class Hello {

public static void main(String[] args){
    
	float myFloat = 5f ;
	
	double newDouble = 5d ; //(5.6)
	
    }
}
```

- float 7 precision
- double 17 precision

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/32.png)

### character , boolean

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/33.png)

``` java

public class Hello {

public static void main(String[] args){
    
	char mychar = 'F' ;
	char uniCode = '\u00A9'
	
	boolean newBoolean = True ; 
	
    }
}
```


### String
``` java

public class Hello {

public static void main(String[] args){
    
	String myString = "This is myString" ;
	int myInt =  25
	
	String Full = myString + myInt ;
	// int converted in to string 
	
    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/34.png)

[[7-Operators and Operators procedence]]


## Vaiable initialization
- Varibale is a block in memory which used to save a value
  Mostly saved in stack memory.

``` java

public class Hello {

public static void main(String[] args){
    int firstNumber = 5 ;
    
    System.out.println(firstNumber) ;

    }
}
```

---

## Primitive Datatypes
> **Primitive data types** are those supported directly by the language and are not composed of any other **data types**. Kind of like they are atomic that way. The language has support for operations on those **data types** already. **Abstract data types** are created by users, and in libraries.

- Datatypes that are build in to the language.

- int 
- short
- byte
- Long

``` java

public class Hello {

public static void main(String[] args){
    int myMinValue = -2_147_483_648 ;
	
	byte myByte = -128
	
    short = 32767
	
	Long = 9_223-372_036_854_775_007L
	

    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/35.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/36.png)

### Type casting
- change one datatype in to another datatype

``` java

public class Hello {

public static void main(String[] args){
    
	byte myByte = -128
	
	byte newByteValue = (byte)(myByte/2)
	
    }
}
```

## Primitive Data Types 2

``` java

public class Hello {

public static void main(String[] args){
    
	float myFloat = 5f ;
	
	double newDouble = 5d ; //(5.6)
	
    }
}
```

- float 7 precision
- double 17 precision

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/37.png)

### character , boolean

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/38.png)

``` java

public class Hello {

public static void main(String[] args){
    
	char mychar = 'F' ;
	char uniCode = '\u00A9'
	
	boolean newBoolean = True ; 
	
    }
}
```


### String
``` java

public class Hello {

public static void main(String[] args){
    
	String myString = "This is myString" ;
	int myInt =  25
	
	String Full = myString + myInt ;
	// int converted in to string 
	
    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/39.png)

[[7-Operators and Operators procedence]]


## Vaiable initialization
- Varibale is a block in memory which used to save a value
  Mostly saved in stack memory.

``` java

public class Hello {

public static void main(String[] args){
    int firstNumber = 5 ;
    
    System.out.println(firstNumber) ;

    }
}
```

---

## Primitive Datatypes
> **Primitive data types** are those supported directly by the language and are not composed of any other **data types**. Kind of like they are atomic that way. The language has support for operations on those **data types** already. **Abstract data types** are created by users, and in libraries.

- Datatypes that are build in to the language.

- int 
- short
- byte
- Long

``` java

public class Hello {

public static void main(String[] args){
    int myMinValue = -2_147_483_648 ;
	
	byte myByte = -128
	
    short = 32767
	
	Long = 9_223-372_036_854_775_007L
	

    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/40.png)

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/41.png)

### Type casting
- change one datatype in to another datatype

``` java

public class Hello {

public static void main(String[] args){
    
	byte myByte = -128
	
	byte newByteValue = (byte)(myByte/2)
	
    }
}
```

## Primitive Data Types 2

``` java

public class Hello {

public static void main(String[] args){
    
	float myFloat = 5f ;
	
	double newDouble = 5d ; //(5.6)
	
    }
}
```

- float 7 precision
- double 17 precision

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/42.png)

### character , boolean

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/43.png)

``` java

public class Hello {

public static void main(String[] args){
    
	char mychar = 'F' ;
	char uniCode = '\u00A9'
	
	boolean newBoolean = True ; 
	
    }
}
```


### String
``` java

public class Hello {

public static void main(String[] args){
    
	String myString = "This is myString" ;
	int myInt =  25
	
	String Full = myString + myInt ;
	// int converted in to string 
	
    }
}
```

![dockerengine]({{ site.baseurl }}/post_img/2022/java_basic/1/44.png)

[[7-Operators and Operators procedence]]