Rem
	Copyright (c) 2010 Noel R. Cower

	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required.

	2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software.

	3. This notice may not be removed or altered from any source
	distribution.
EndRem

SuperStrict

Module Cower.BMXLexer
ModuleInfo "Name: BlitzMax Lexer"
ModuleInfo "Description: Wrapped lexer for BlitzMax source code"
ModuleInfo "Author: Noel Cower"
ModuleInfo "License: Public Domain"

?Debug
ModuleInfo "CC_OPTS: -g"
?

Import "lexer.c"

Private

Extern "C"
	Function lexer_new@Ptr(source_begin@Ptr, source_end@Ptr)
	Function lexer_destroy(lexer@Ptr)
	Function lexer_run:Int(lexer@Ptr)
	Function lexer_get_error$z(lexer@Ptr)
	Function lexer_get_num_tokens:Int(lexer@Ptr)
	Function lexer_get_token:Int(lexer@Ptr, index%, token@Ptr)
'	 Function lexer_copy_tokens@Ptr(lexer@Ptr, num_tokens%Ptr)'unused
	Function token_to_string@Ptr(tok@Ptr)
	Function free(b@Ptr)
End Extern

Public

Type TToken
	Field kind%				' token_kind_t
	Field _from:Byte Ptr	 ' const char *
	Field _to_:Byte Ptr		  ' const char *
	Field line%				' int
	Field column%			' int
	
	Field _cachedStr$=Null
	
	Method _cacheTokenString()
		If _cachedStr = Null Then
			Local cstr@Ptr = token_to_string(Self)
			_cachedStr = String.FromCString(cstr)
			free(cstr)
		EndIf
	End Method
	
	Method PositionString$()
		Return "["+line+":"+column+"]"
	End Method
	
	Method ToString$()
		Return _cachedStr
	End Method
	
	Method DistanceFrom:Int(other:TToken)
		Return Abs(Int(_from)-Int(other._to_))
	End Method
	
	'#region token_kind_t
	Const TOK_INVALID% = 0
	Const TOK_ID% = 1
	Const TOK_END_KW% = 2
	Const TOK_FUNCTION_KW% = 3
	Const TOK_ENDFUNCTION_KW% = 4
	Const TOK_METHOD_KW% = 5
	Const TOK_ENDMETHOD_KW% = 6
	Const TOK_TYPE_KW% = 7
	Const TOK_EXTENDS_KW% = 8
	Const TOK_ABSTRACT_KW% = 9
	Const TOK_FINAL_KW% = 10
	Const TOK_NODEBUG_KW% = 11
	Const TOK_ENDTYPE_KW% = 12
	Const TOK_EXTERN_KW% = 13
	Const TOK_ENDEXTERN_KW% = 14
	Const TOK_REM_KW% = 15
	Const TOK_ENDREM_KW% = 16
	Const TOK_FLOAT_KW% = 17
	Const TOK_DOUBLE_KW% = 18
	Const TOK_BYTE_KW% = 19
	Const TOK_SHORT_KW% = 20
	Const TOK_INT_KW% = 21
	Const TOK_LONG_KW% = 22
	Const TOK_STRING_KW% = 23
	Const TOK_OBJECT_KW% = 24
	Const TOK_LOCAL_KW% = 25
	Const TOK_GLOBAL_KW% = 26
	Const TOK_CONST_KW% = 27
	Const TOK_VARPTR_KW% = 28
	Const TOK_PTR_KW% = 29
	Const TOK_VAR_KW% = 30
	Const TOK_NULL_KW% = 31
	Const TOK_STRICT_KW% = 32
	Const TOK_SUPERSTRICT_KW% = 33
	Const TOK_FRAMEWORK_KW% = 34
	Const TOK_MODULE_KW% = 35
	Const TOK_MODULEINFO_KW% = 36
	Const TOK_IMPORT_KW% = 37
	Const TOK_INCLUDE_KW% = 38
	Const TOK_PRIVATE_KW% = 39
	Const TOK_PUBLIC_KW% = 40
	Const TOK_OR_KW% = 41
	Const TOK_AND_KW% = 42
	Const TOK_SHR_KW% = 43
	Const TOK_SHL_KW% = 44
	Const TOK_SAR_KW% = 45
	Const TOK_MOD_KW% = 46
	Const TOK_NOT_KW% = 47
	Const TOK_WHILE_KW% = 48
	Const TOK_WEND_KW% = 49
	Const TOK_ENDWHILE_KW% = 50
	Const TOK_FOR_KW% = 51
	Const TOK_NEXT_KW% = 52
	Const TOK_UNTIL_KW% = 53
	Const TOK_TO_KW% = 54
	Const TOK_EACHIN_KW% = 55
	Const TOK_REPEAT_KW% = 56
	Const TOK_FOREVER_KW% = 57
	Const TOK_IF_KW% = 58
	Const TOK_ENDIF_KW% = 59
	Const TOK_ELSE_KW% = 60
	Const TOK_ELSEIF_KW% = 61
	Const TOK_THEN_KW% = 62
	Const TOK_SELECT_KW% = 63
	Const TOK_CASE_KW% = 64
	Const TOK_DEFAULT_KW% = 65
	Const TOK_ENDSELECT_KW% = 66
	Const TOK_SELF_KW% = 67
	Const TOK_SUPER_KW% = 68
	Const TOK_PI_KW% = 69
	Const TOK_NEW_KW% = 70
	Const TOK_PROTOCOL_KW% = 71
	Const TOK_ENDPROTOCOL_KW% = 72
	Const TOK_AUTO_KW% = 73
	Const TOK_IMPLEMENTS_KW% = 74
	Const TOK_COLON% = 75
	Const TOK_QUESTION% = 76
	Const TOK_BANG% = 77
	Const TOK_HASH% = 78
	Const TOK_DOT% = 79
	Const TOK_DOUBLEDOT% = 80
	Const TOK_TRIPLEDOT% = 81
	Const TOK_AT% = 82
	Const TOK_DOUBLEAT% = 83
	Const TOK_DOLLAR% = 84
	Const TOK_PERCENT% = 85
	Const TOK_SINGLEQUOTE% = 86
	Const TOK_OPENPAREN% = 87
	Const TOK_CLOSEPAREN% = 88
	Const TOK_OPENBRACKET% = 89
	Const TOK_CLOSEBRACKET% = 90
	Const TOK_OPENCURL% = 91
	Const TOK_CLOSECURL% = 92
	Const TOK_GREATERTHAN% = 93
	Const TOK_LESSTHAN% = 94
	Const TOK_EQUALS% = 95
	Const TOK_MINUS% = 96
	Const TOK_PLUS% = 97
	Const TOK_ASTERISK% = 98
	Const TOK_CARET% = 99
	Const TOK_TILDE% = 100
	Const TOK_GRAVE% = 101
	Const TOK_BACKSLASH% = 102
	Const TOK_SLASH% = 103
	Const TOK_COMMA% = 104
	Const TOK_SEMICOLON% = 105
	Const TOK_PIPE% = 106
	Const TOK_AMPERSAND% = 107
	Const TOK_NEWLINE% = 108
	Const TOK_ASSIGN_ADD% = 109
	Const TOK_ASSIGN_SUBTRACT% = 110
	Const TOK_ASSIGN_DIVIDE% = 111
	Const TOK_ASSIGN_MULTIPLY% = 112
	Const TOK_ASSIGN_POWER% = 113
	Const TOK_ASSIGN_SHL% = 114
	Const TOK_ASSIGN_SHR% = 115
	Const TOK_ASSIGN_SAR% = 116
	Const TOK_ASSIGN_MOD% = 117
	Const TOK_ASSIGN_XOR% = 118
	Const TOK_ASSIGN_AND% = 119
	Const TOK_ASSIGN_OR% = 120
	Const TOK_ASSIGN_AUTO% = 121
	Const TOK_DOUBLEMINUS% = 122
	Const TOK_DOUBLEPLUS% = 123
	Const TOK_NUMBER_LIT% = 124
	Const TOK_HEX_LIT% = 125
	Const TOK_BIN_LIT% = 126
	Const TOK_STRING_LIT% = 127
	Const TOK_LINE_COMMENT% = 128
	Const TOK_BLOCK_COMMENT% = 129
	Const TOK_EOF% = 130
	Const TOK_TRUE_KW% = 131
	Const TOK_FALSE_KW% = 132
	Const TOK_TRY_KW% = 133
	Const TOK_CATCH_KW% = 134
	Const TOK_FINALLY_KW% = 135
	Const TOK_ENDTRY_KW% = 136
	
	Const TOK_LAST%=TOK_EOF
	Const TOK_COUNT%=TOK_LAST+1
	'#endregion
	
	Method Compare:Int(other:Object)
		Local tok:TToken = TToken(other)
		If tok Then
			Return ToString().Compare(other.ToString())
		Else
			Return Super.Compare(other)
		EndIf
	End Method
End Type

Type TLexer
	Field _lexer@Ptr	' lexer_t
	Field _run:Int = False
	Field _cstr_source@Ptr
	Field _length%
	Field _tokens:TToken[]
	Field _error:String = Null
	
	Method InitWithSource:TLexer(source$)
		Assert _cstr_source=Null Else "Lexer already initialized"
		
		_cstr_source = source.ToCString()
		_length = source.Length
		_lexer = lexer_new(_cstr_source, _cstr_source+_length)
		
		Return Self
	End Method
	
	Method Delete()
		If _lexer Then
			lexer_destroy(_lexer)
		EndIf
		If _cstr_source Then
			MemFree(_cstr_source)
		EndIf
	End Method
	
	Method Run:Int()
		Assert _run = False Else "Lexer has already run"
		_run = True
		Local r% = lexer_run(_lexer)
		If r <> 0 Then
			_error = lexer_get_error(_lexer)
		EndIf
		Return (r=0)
	End Method
	
	Method _cacheTokens()
		If _tokens = Null Then
			_tokens = New TToken[lexer_get_num_tokens(_lexer)]
			For Local init_idx:Int = 0 Until _tokens.Length
				_tokens[init_idx] = New TToken
				lexer_get_token(_lexer, init_idx, _tokens[init_idx])
				_tokens[init_idx]._cacheTokenString()
			Next
		EndIf
	End Method
	
	Method GetToken:TToken(index%)
		_cacheTokens()
		Return _tokens[index]
	End Method
	
	Method GetTokens:TToken[]()
		_cacheTokens()
		Return _tokens[..]
	End Method
	
	Method NumTokens:Int()
		If _tokens Then
			Return _tokens.Length
		EndIf
		Return lexer_get_num_tokens(_lexer)
	End Method
	
	Method GetError$()
		Return _error
	End Method
End Type
