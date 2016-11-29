#Include Yunit\Yunit.ahk
#Include Yunit\Window.ahk
#Include ..\ConvertFuncs.ahk

Yunit.Use(YunitWindow).Test(ConvertTests, ToExpTests)


class ConvertTests
{
   Begin()
   {
   }

   AssignmentString()
   {
      input_script := "
         (Join`r`n %
                                 var = hello
                                 msg = %var% world
                                 MsgBox, %msg%
         )"

      expected := "
         (Join`r`n %
                                 var := "hello"
                                 msg := var . " world"
                                 MsgBox, %msg%
         )"
      ; that could alternatively be:    msg := "%var% world"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;Loop, Parse, %expected%, `n
         ;msgbox, % A_LoopField "`n" StrLen(A_LoopField)
      ;Loop, Parse, %converted%, `n
         ;msgbox, % A_LoopField "`n" StrLen(A_LoopField)
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      Yunit.assert(converted = expected)
   }

   AssignmentStringWithQuotes()
   {
      input_script := "
         (Join`r`n %
                                 msg = the man said, "hello"
                                 MsgBox, %msg%
         )"

      expected := "
         (Join`r`n %
                                 msg := "the man said, ``"hello``""
                                 MsgBox, %msg%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   AssignmentNumber()
   {
      input_script := "
         (Join`r`n %
                                 var = 2
                                 if (var = 2)
                                    MsgBox, true
         )"

      expected := "
         (Join`r`n %
                                 var := 2
                                 if (var = 2)
                                    MsgBox, true
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      Yunit.assert(converted = expected)
   }

   CommentBlock()
   {
      input_script := "
         (Join`r`n %
                                 /`*
                                 var = hello
                                 *`/
                                 var2 = hello2
                                 MsgBox, var=%var%``nvar2=%var2%
         )"

      expected := "
         (Join`r`n %
                                 /`*
                                 var = hello
                                 *`/
                                 var2 := "hello2"
                                 MsgBox, var=%var%``nvar2=%var2%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   CommentBlock_ContinuationInside()
   {
      input_script := "
         (Join`r`n %
                                 /`*
                                 var = 
                                 `(
                                 blah blah
                                 `)
                                 *`/
                                 var2 = hello2
         )"

      expected := "
         (Join`r`n %
                                 /`*
                                 var = 
                                 `(
                                 blah blah
                                 `)
                                 *`/
                                 var2 := "hello2"
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Continuation_Assignment()
   {
      input_script := "
         (Join`r`n %
                                 Sleep, 100
                                 var =
                                 `(
                                 line1
                                 line2
                                 `)
                                 MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 Sleep, 100
                                 var := "
                                 `(
                                 line1
                                 line2
                                 `)"
                                 MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Continuation_Assignment_indented()
   {
      input_script := "
         (Join`r`n %
                                 var =
                                    `(
                                    hello world
                                    `)
                                 MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 var := "
                                    `(
                                    hello world
                                    `)"
                                 MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;Loop, Parse, %expected%, `n
         ;msgbox, % A_LoopField "`n" StrLen(A_LoopField)
      ;Loop, Parse, %converted%, `n
         ;msgbox, % A_LoopField "`n" StrLen(A_LoopField)
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   /*
   Continuation_NewlinePreceding()
   {
      input_script := "
         (Join`r`n %
                                 var =

                                 `(
                                 hello
                                 `)
                                 MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 var := "

                                 `(
                                 hello
                                 `)"
                                 MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }
   */

   Continuation_CommandParam()
   {
      input_script := "
         (Join`r`n %
                                 var := 9
                                 MsgBox, 
                                 `(
                                 line1
                                 line2
                                 `)
         )"

      expected := "
         (Join`r`n %
                                 var := 9
                                 MsgBox, 
                                 `(
                                 line1
                                 line2
                                 `)
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Ternary_NotContinuation()
   {
      input_script := "
         (Join`r`n %
                                 var := true
                                 ( var ) ? x : y
                                 var2 = value2
         )"

      expected := "
         (Join`r`n %
                                 var := true
                                 ( var ) ? x : y
                                 var2 := "value2"
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_EqualsString()
   {
      input_script := "
         (Join`r`n %
                                 var := "helloworld"
                                 if var = helloworld
                                    MsgBox, equal
            )"

      expected := "
         (Join`r`n %
                                 var := "helloworld"
                                 if (var = "helloworld")
                                    MsgBox, equal
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_NotEqualsEmptyString()
   {
      input_script := "
         (Join`r`n %
                                 var = 3
                                 if var != 
                                    MsgBox, %var%
            )"

      expected := "
         (Join`r`n %
                                 var := 3
                                 if (var != "")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_EqualsInt()
   {
      input_script := "
         (Join`r`n %
                                 if var = 8
                                    MsgBox, %var%
            )"

      expected := "
         (Join`r`n %
                                 if (var = 8)
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_GreaterThanInt()
   {
      input_script := "
         (Join`r`n %
                                 if var > 8
                                    MsgBox, %var%
            )"

      expected := "
         (Join`r`n %
                                 if (var > 8)
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_EqualsVariable()
   {
      input_script := "
         (Join`r`n %
                                 if MyVar = %MyVar2%
                                     MsgBox The contents of MyVar and MyVar2 are identical.
            )"

      expected := "
         (Join`r`n %
                                 if (MyVar = MyVar2)
                                     MsgBox The contents of MyVar and MyVar2 are identical.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_Else()
   {
      input_script := "
         (Join`r`n %
                                 if MyVar = %MyVar2%
                                     MsgBox The contents of MyVar and MyVar2 are identical.
                                 else if MyVar =
                                     MsgBox, MyVar is empty/blank
         )"

      expected := "
         (Join`r`n %
                                 if (MyVar = MyVar2)
                                     MsgBox The contents of MyVar and MyVar2 are identical.
                                 else if (MyVar = "")
                                     MsgBox, MyVar is empty/blank
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Traditional_If_Else_NotEquals()
   {
      input_script := "
         (Join`r`n %
                                 if MyVar = %MyVar2%
                                     MsgBox The contents of MyVar and MyVar2 are identical.
                                 else if MyVar <>
                                     MsgBox, MyVar is not empty/blank
         )"

      expected := "
         (Join`r`n %
                                 if (MyVar = MyVar2)
                                     MsgBox The contents of MyVar and MyVar2 are identical.
                                 else if (MyVar <> "")
                                     MsgBox, MyVar is not empty/blank
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   Expression_If_Function()
   {
      input_script := "
         (Join`r`n %
                                 if MyFunc()
                                    MsgBox, %var%
            )"

      expected := "
         (Join`r`n %
                                 if MyFunc()
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected, "Dont mistake func call for a variable")
   }

   Expression_If_Not()
   {
      input_script := "
         (Join`r`n %
                                 var := ""
                                 if not var = 
                                    MsgBox, var is not empty
                                 else
                                    MsgBox, var is empty
            )"

      expected := "
         (Join`r`n %
                                 var := ""
                                 if not (var = "")
                                    MsgBox, var is not empty
                                 else
                                    MsgBox, var is empty
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected, "Handle 'if not var = value'")
   }

   IfEqual_CommandThenComma()
   {
      input_script := "
         (Join`r`n %
                                 IfEqual, var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var = "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_CommandThenSpace()
   {
      input_script := "
         (Join`r`n %
                                 IfEqual var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var = "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_CommandThenMultipleSpaces()
   {
      input_script := "
         (Join`r`n %
                                 IfEqual    var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var = "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_LeadingSpacesInParam()
   {
      input_script := "
         (Join`r`n %
                                 IfEqual, var,     value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var = "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_EscapedComma()
   {
      input_script := "
         (Join`r`n %
                                 var = ,
                                 IfEqual, var, `,
                                    MsgBox, var is a comma
         )"

      expected := "
         (Join`r`n %
                                 var := ","
                                 if (var = ",")
                                    MsgBox, var is a comma
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_EscapedCommaMidString()
   {
      input_script := "
         (Join`r`n %
                                 var = hello,world
                                 IfEqual, var, hello`,world
                                    MsgBox, var matches
         )"

      expected := "
         (Join`r`n %
                                 var := "hello,world"
                                 if (var = "hello,world")
                                    MsgBox, var matches
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_EscapedCommaNotNeededInLastParam()
   {
      ; "Commas that appear within the last parameter of a command do not need to be escaped because 
      ;  the program knows to treat them literally."
      ;
      ; from:   https://autohotkey.com/docs/commands/_EscapeChar.htm

      input_script := "
         (Join`r`n %
                                 var = ,
                                 IfEqual, var, ,
                                    MsgBox, var is a comma
         )"

      expected := "
         (Join`r`n %
                                 var := ","
                                 if (var = ",")
                                    MsgBox, var is a comma
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfEqual_EscapedCommaNotNeededMidString()
   {
      ; "Commas that appear within the last parameter of a command do not need to be escaped because 
      ;  the program knows to treat them literally."
      ;
      ; from:   https://autohotkey.com/docs/commands/_EscapeChar.htm

      input_script := "
         (Join`r`n %
                                 var = hello,world
                                 IfEqual, var, hello,world
                                    MsgBox, var matches
         )"

      expected := "
         (Join`r`n %
                                 var := "hello,world"
                                 if (var = "hello,world")
                                    MsgBox, var matches
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfNotEqual()
   {
      input_script := "
         (Join`r`n %
                                 IfNotEqual, var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var != "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfGreaterOrEqual()
   {
      input_script := "
         (Join`r`n %
                                 IfGreaterOrEqual, var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var >= "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfGreater()
   {
      input_script := "
         (Join`r`n %
                                 IfGreater, var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var > "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfLess()
   {
      input_script := "
         (Join`r`n %
                                 IfLess, var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var < "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   IfLessOrEqual()
   {
      input_script := "
         (Join`r`n %
                                 IfLessOrEqual, var, value
                                    MsgBox, %var%
         )"

      expected := "
         (Join`r`n %
                                 if (var <= "value")
                                    MsgBox, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   EnvMult()
   {
      input_script := "
         (Join`r`n %
                                 EnvMult, var, 5
         )"

      expected := "
         (Join`r`n %
                                 var *= 5
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      Yunit.assert(converted = expected)
   }

   EnvMult_ExpressionParam()
   {
      input_script := "
         (Join`r`n %
                                 var2 := 2
                                 EnvMult, var, var2
         )"

      expected := "
         (Join`r`n %
                                 var2 := 2
                                 var *= var2
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   EnvAdd()
   {
      input_script := "
         (Join`r`n %
                                 EnvAdd, var, 2
         )"

      expected := "
         (Join`r`n %
                                 var += 2
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   EnvAdd_var()
   {
      input_script := "
         (Join`r`n %
                                 EnvAdd, var, 2
         )"

      expected := "
         (Join`r`n %
                                 var += 2
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   EnvSub()
   {
      input_script := "
         (Join`r`n %
                                 EnvSub, var, 2
         )"

      expected := "
         (Join`r`n %
                                 var -= 2
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   EnvSub_ExpressionValue()
   {
      input_script := "
         (Join`r`n %
                                 EnvSub, var, value
         )"

      expected := "
         (Join`r`n %
                                 var -= value
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues()
   {
      input_script := "
         (Join`r`n %
                                 five := MyFunc()
                                 MyFunc(var=5) {
                                    return var
                                 }
         )"

      expected := "
         (Join`r`n %
                                 five := MyFunc()
                                 MyFunc(var:=5) {
                                    return var
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues_OTB()
   {
      input_script := "
         (Join`r`n %
                                 five := MyFunc()
                                 MyFunc(var=5) {
                                    return var
                                 }
         )"

      expected := "
         (Join`r`n %
                                 five := MyFunc()
                                 MyFunc(var:=5) {
                                    return var
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues_CommasInParamString()
   {
      input_script := "
         (Join`r`n %
                                 Concat(5)

                                 Concat(one, two="hello,world")
                                 {
                                    MsgBox, % one . two
                                 }
         )"

      expected := "
         (Join`r`n %
                                 Concat(5)

                                 Concat(one, two:="hello,world")
                                 {
                                    MsgBox, % one . two
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues_CommasInCallString()
   {
      input_script := "
         (Join`r`n %
                                 Concat("joe,says,")

                                 Concat(one, two="hello,world")
                                 {
                                    MsgBox, % one . two
                                 }
         )"

      expected := "
         (Join`r`n %
                                 Concat("joe,says,")

                                 Concat(one, two:="hello,world")
                                 {
                                    MsgBox, % one . two
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues_EqualSignInString()
   {
      input_script := "
         (Join`r`n %
                                 Concat(5)

                                 Concat(one, two="+5=10")
                                 {
                                    MsgBox, % one . two
                                 }
         )"

      expected := "
         (Join`r`n %
                                 Concat(5)

                                 Concat(one, two:="+5=10")
                                 {
                                    MsgBox, % one . two
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues_TernaryInCall()
   {
      ; dont replace the equal sign in the ternary during the function CALL
      input_script := "
         (Join`r`n %
                                 Concat((var=5) ? 5 : 0)

                                 Concat(one, two="2")
                                 {
                                    MsgBox, % one + two
                                 }
         )"

      expected := "
         (Join`r`n %
                                 Concat((var=5) ? 5 : 0)

                                 Concat(one, two:="2")
                                 {
                                    MsgBox, % one + two
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   FunctionDefaultParamValues_WholeShebang()
   {
      input_script := "
         (Join`r`n %
                                 var = 5
                                 Concat((var=5) ? 5 : 0)

                                 Concat(one, two="hello,world", three = 3, four = "does 2+2=4?")
                                 {
                                    MsgBox, % one . two . three . four
                                 }
         )"

      expected := "
         (Join`r`n %
                                 var := 5
                                 Concat((var=5) ? 5 : 0)

                                 Concat(one, two:="hello,world", three := 3, four := "does 2+2=4?")
                                 {
                                    MsgBox, % one . two . three . four
                                 }
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   NoEnv_Remove()
   {
      input_script := "
         (Join`r`n %
                                 #NoEnv
                                 msgbox, hi
         )"

      expected := "
         (Join`r`n %
                                 ; REMOVED: #NoEnv
                                 msgbox, hi
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   SetFormat_Remove()
   {
      input_script := "
         (Join`r`n %
                                 SetFormat, integerfast, H
                                 msgbox, hi
         )"

      expected := "
         (Join`r`n %
                                 ; REMOVED: SetFormat, integerfast, H
                                 msgbox, hi
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   DriveGetFreeSpace()
   {
      input_script := "
         (Join`r`n %
                                 DriveSpaceFree, FreeSpace, c:\
                                 MsgBox, %FreeSpace%
         )"

      expected := "
         (Join`r`n %
                                 DriveGet, FreeSpace, SpaceFree, c:\
                                 MsgBox, %FreeSpace%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringUpper()
   {
      input_script := "
         (Join`r`n %
                                 var = Chris Mallet
                                 StringUpper, newvar, var
         )"

      expected := "
         (Join`r`n %
                                 var := "Chris Mallet"
                                 StrUpper, newvar, %var%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringLower()
   {
      input_script := "
         (Join`r`n %
                                 var = chris mallet
                                 StringLower, newvar, var, T
                                 if (newvar == "Chris Mallet")
                                    MsgBox, it worked
         )"

      expected := "
         (Join`r`n %
                                 var := "chris mallet"
                                 StrLower, newvar, %var%, T
                                 if (newvar == "Chris Mallet")
                                    MsgBox, it worked
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringLen()
   {
      input_script := "
         (Join`r`n %
                                 InputVar := "The Quick Brown Fox Jumps Over the Lazy Dog"
                                 StringLen, length, InputVar
                                 MsgBox, The length of InputVar is %length%.
         )"

      expected := "
         (Join`r`n %
                                 InputVar := "The Quick Brown Fox Jumps Over the Lazy Dog"
                                 length := StrLen(InputVar)
                                 MsgBox, The length of InputVar is %length%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefghijklmnopqrs
                                 Needle = def
                                 StringGetPos, pos, Haystack, %Needle%
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefghijklmnopqrs"
                                 Needle := "def"
                                 pos := InStr(Haystack, Needle) - 1
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_SearchLeftOccurance()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = def
                                 StringGetPos, pos, Haystack, %Needle%, L2
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "def"
                                 pos := InStr(Haystack, Needle, false, (0)+1, 2) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   StringGetPos_SearchRight()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = bcd
                                 StringGetPos, pos, Haystack, %Needle%, R
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "bcd"
                                 pos := InStr(Haystack, Needle, false, -1*((0)+1), 1) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_SearchRightOccurance()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = cde
                                 StringGetPos, pos, Haystack, %Needle%, R2
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "cde"
                                 pos := InStr(Haystack, Needle, false, -1*((0)+1), 2) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetLeft()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = cde
                                 StringGetPos, pos, Haystack, %Needle%,, 4
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "cde"
                                 pos := InStr(Haystack, Needle, false, (4)+1, 1) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetLeftVariable()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = cde
                                 var = 2
                                 StringGetPos, pos, Haystack, %Needle%,, %var%
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "cde"
                                 var := 2
                                 pos := InStr(Haystack, Needle, false, (var)+1, 1) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetLeftExpressionVariable()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = cde
                                 var = 1
                                 StringGetPos, pos, Haystack, %Needle%,, var+2
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "cde"
                                 var := 1
                                 pos := InStr(Haystack, Needle, false, (var+2)+1, 1) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetRightExpressionVariableOccurences()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdefabcdef
                                 Needle = cde
                                 var = 0
                                 StringGetPos, pos, Haystack, %Needle%, R2, var+2
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdefabcdef"
                                 Needle := "cde"
                                 var := 0
                                 pos := InStr(Haystack, Needle, false, -1*((var+2)+1), 2) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetLeftOccurence()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdefabcdef
                                 Needle = cde
                                 StringGetPos, pos, Haystack, %Needle%, L2, 4
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdefabcdef"
                                 Needle := "cde"
                                 pos := InStr(Haystack, Needle, false, (4)+1, 2) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetRight()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdef
                                 Needle = cde
                                 StringGetPos, pos, Haystack, %Needle%, R, 4
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdef"
                                 Needle := "cde"
                                 pos := InStr(Haystack, Needle, false, -1*((4)+1), 1) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_OffsetRightOccurence()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = abcdefabcdefabcdef
                                 Needle = cde
                                 StringGetPos, pos, Haystack, %Needle%, r2, 4
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "abcdefabcdefabcdef"
                                 Needle := "cde"
                                 pos := InStr(Haystack, Needle, false, -1*((4)+1), 2) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringGetPos_Duplicates()
   {
      input_script := "
         (Join`r`n %
                                 Haystack = FFFF
                                 Needle = FF
                                 StringGetPos, pos, Haystack, %Needle%, L2
                                 if pos >= 0
                                     MsgBox, The string was found at position %pos%.
         )"

      expected := "
         (Join`r`n %
                                 Haystack := "FFFF"
                                 Needle := "FF"
                                 pos := InStr(Haystack, Needle, false, (0)+1, 2) - 1
                                 ; WARNING: if you use StringCaseSense in your script you may need to inspect the 3rd param 'false' above
                                 if (pos >= 0)
                                     MsgBox, The string was found at position %pos%.
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringLeft()
   {
      input_script := "
         (Join`r`n %
                                 String = This is a test.
                                 StringLeft, OutputVar, String, 4
                                 MsgBox, %OutputVar%
         )"

      expected := "
         (Join`r`n %
                                 String := "This is a test."
                                 OutputVar := SubStr(String, 1, 4)
                                 MsgBox, %OutputVar%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      Yunit.assert(converted = expected)
   }

   StringRight()
   {
      input_script := "
         (Join`r`n %
                                 String = This is a test.
                                 StringRight, OutputVar, String, 5
                                 MsgBox, %OutputVar%
         )"

      expected := "
         (Join`r`n %
                                 String := "This is a test."
                                 OutputVar := SubStr(String, -5)
                                 MsgBox, %OutputVar%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   StringTrimLeft()
   {
      input_script := "
         (Join`r`n %
                                 String = This is a test.
                                 StringTrimLeft, OutputVar, String, 5
                                 MsgBox, %OutputVar%
         )"

      expected := "
         (Join`r`n %
                                 String := "This is a test."
                                 OutputVar := SubStr(String, 5+1)
                                 MsgBox, %OutputVar%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;MsgBox, Click OK and the converted script will be run with AHK v2:`n`n%converted%
      ;ExecScript2(converted)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   StringTrimRight()
   {
      input_script := "
         (Join`r`n %
                                 String = This is a test.
                                 StringTrimRight, OutputVar, String, 6
                                 MsgBox, [%OutputVar%]
         )"

      expected := "
         (Join`r`n %
                                 String := "This is a test."
                                 OutputVar := SubStr(String, 1, -6)
                                 MsgBox, [%OutputVar%]
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;MsgBox, Click OK and the converted script will be run with AHK v2:`n`n%converted%
      ;ExecScript2(converted)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   Preserve_Indentation()
   {
      ; dont use LTrim and instead rely on AHK v2 default smart LTrim
      input_script := "
         (Join`r`n %
                                 if (1) {
                                    var = val
                                    if var = hello
                                 		MsgBox, this line starts with 2 tab characters
                                    else {
                                       ifequal, var, val
                                          StringGetPos, pos, var, al
                                    }
                                 }
                                 MsgBox, pos=%pos%
         )"

      expected := "
         (Join`r`n %
                                 if (1) {
                                    var := "val"
                                    if (var = "hello")
                                 		MsgBox, this line starts with 2 tab characters
                                    else {
                                       if (var = "val")
                                          pos := InStr(var, "al") - 1
                                    }
                                 }
                                 MsgBox, pos=%pos%
         )"

      ;MsgBox, Click OK and the following script will be run with AHK v1:`n`n%input_script%
      ;ExecScript1(input_script)
      ;MsgBox, Click OK and the following script will be run with AHK v2:`n`n%expected%
      ;ExecScript2(expected)
      converted := Convert(input_script)
      ;msgbox, expected:`n`n%expected%
      ;msgbox, converted:`n`n%converted%
      ;FileAppend, % expected, expected.txt
      ;FileAppend, % converted, converted.txt 
      ;Run, ..\diff\VisualDiff.exe ..\diff\VisualDiff.ahk "%A_ScriptDir%\expected.txt" "%A_ScriptDir%\converted.txt"
      Yunit.assert(converted = expected)
   }

   End()
   {
   }
}


class ToExpTests
{
   Begin()
   {
   }

   SurroundQuotes()
   {
      Yunit.assert(ToExp("") = "`"`"")
      Yunit.assert(ToExp("hello") = "`"hello`"")
      Yunit.assert(ToExp("hello world") = "`"hello world`"")
   }

   QuotesInsideString()
   {
      orig := "the man said, `"hello`""
      expected := "`"the man said, ```"hello```"`""
      converted := ToExp(orig)
      ;Msgbox, expected: %expected%`nconverted: %converted%
      Yunit.assert(converted = expected)
   }

   RemovePercents()
   {
      Yunit.assert(ToExp("`%hello`%") = "hello")
      Yunit.assert(ToExp("`%hello`%world") = "hello . `"world`"")
      Yunit.assert(ToExp("`%hello`% world") = "hello . `" world`"")
      Yunit.assert(ToExp("one `%two`% three") = "`"one `" . two . `" three`"")
   }

   PercentDerefsInsideStrings()
   {
      /*
         from:
         https://lexikos.github.io/v2/docs/Variables.htm#Operators

         Within a quoted string: Evaluates Expr and inserts the result at that position within the string. 
         For example, the following are equivalent:

         MsgBox("Hello, %A_UserName%!")
         MsgBox, Hello`, %A_Username%!
         MsgBox("Hello, " A_UserName "!")
      */

      ; decide whether to remove the percents and concatenate like above in RemovePercents()
      ; or to just wrap quotes around everything and leave the percents

      ; Yunit.assert(ToExp("`%hello`%world") = "`"`%hello`%world`"")
   }

   Numbers()
   {
      Yunit.assert(ToExp("10") = "10")
   }

   End()
   {
   }
}



; from the 'Run' help docs:
; ExecScript: Executes the given code as a new AutoHotkey process.
ExecScript1(Script, Wait:=true)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("..\diff\VisualDiff.exe /ErrorStdOut *")  ;// the VisualDiff.exe file is just a renamed AHK v1.1.24.01 exe
    exec.StdIn.Write(script)
    exec.StdIn.Close()
    if Wait
        return exec.StdOut.ReadAll()
}

ExecScript2(Script, Wait:=true)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("Tests.exe /ErrorStdOut *")  ;// the Tests.exe file is just a renamed AHK v2-a076 exe
    exec.StdIn.Write(script)
    exec.StdIn.Close()
    if Wait
        return exec.StdOut.ReadAll()
}

