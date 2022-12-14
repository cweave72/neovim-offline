cmake_minimum_required(VERSION 3.11)

project(LuaParser)

add_library(LuaParser STATIC)

add_dependencies(LuaParser Util)

target_include_directories(LuaParser PUBLIC
	${LuaCodeStyle_SOURCE_DIR}/include
	src
)

target_sources(LuaParser PUBLIC
	#include
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaToken.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaTokenType.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaTokenParser.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaParser.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaFile.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaAstNode/LuaAstNode.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/LuaAstNode/LuaAstNodeType.h
	${LuaCodeStyle_SOURCE_DIR}/include/LuaParser/TextRange.h
	#src
	PRIVATE
	${LuaParser_SOURCE_DIR}/src/LuaParser.cpp	
	${LuaParser_SOURCE_DIR}/src/LuaTokenParser.cpp	
	${LuaParser_SOURCE_DIR}/src/LuaParseException.cpp
	${LuaParser_SOURCE_DIR}/src/LuaAstNode/LuaAstNode.cpp
	${LuaParser_SOURCE_DIR}/src/TextRange.cpp
	${LuaParser_SOURCE_DIR}/src/LuaAstVisitor.cpp
	${LuaParser_SOURCE_DIR}/src/LuaFile.cpp
	${LuaParser_SOURCE_DIR}/src/LuaIdentify.cpp
	${LuaParser_SOURCE_DIR}/src/LuaCustomParser.cpp
	${LuaParser_SOURCE_DIR}/src/LuaDocTokenParser.cpp
)

target_link_libraries(LuaParser Util)
