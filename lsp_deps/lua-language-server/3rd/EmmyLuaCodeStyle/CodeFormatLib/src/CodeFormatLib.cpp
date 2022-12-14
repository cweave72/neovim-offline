﻿#include "lua.hpp"
#include "LuaCodeFormat.h"

#ifdef _MSC_VER
#define EXPORT    __declspec(dllexport)
#else
#define EXPORT   
#endif

std::string luaToString(lua_State* L, int idx)
{
	if (lua_isstring(L, idx))
	{
		return lua_tostring(L, idx);
	}
	else if (lua_isinteger(L, idx))
	{
		return std::to_string(lua_tointeger(L, idx));
	}
	else if (lua_isnumber(L, idx))
	{
		return std::to_string(lua_tonumber(L, idx));
	}
	else if (lua_isboolean(L, idx))
	{
		return lua_toboolean(L, idx) ? "true" : "false";
	}
	else
	{
		return "nil";
	}
}

std::string GetDiagnosisString(DiagnosisType type)
{
	switch (type)
	{
	case DiagnosisType::MaxLineWidth: return "MaxLineWidth";
	case DiagnosisType::Indent: return "Indent";
	case DiagnosisType::Align: return "Align";
	case DiagnosisType::Blank: return "Blank";
	case DiagnosisType::EndWithNewLine: return "EndWithNewLine";
	case DiagnosisType::NameStyle: return "NameStyle";
	case DiagnosisType::StatementLineSpace: return "StatementLineSpace";
	case DiagnosisType::Spell: return "Spell";
	}
	return "";
}

int format(lua_State* L)
{
	int top = lua_gettop(L);

	if (top < 2)
	{
		return 0;
	}

	if (lua_isstring(L, 1) && lua_isstring(L, 2))
	{
		try
		{
			std::string filename = lua_tostring(L, 1);
			std::string text = lua_tostring(L, 2);
			LuaCodeFormat::ConfigMap configMap;

			if (top == 3 && lua_istable(L, 3))
			{
				lua_pushnil(L);
				while (lua_next(L, -2) != 0)
				{
					auto key = luaToString(L, -2);
					auto value = luaToString(L, -1);

					if (key != "nil")
					{
						configMap.insert({key, value});
					}

					lua_pop(L, 1);
				}
			}

			auto formattedText = LuaCodeFormat::GetInstance().Reformat(filename, std::move(text), configMap);
			if (formattedText.empty())
			{
				lua_pushboolean(L, false);
				return 1;
			}
			lua_pushboolean(L, true);
			lua_pushlstring(L, formattedText.c_str(), formattedText.size());
			return 2;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}
	return 0;
}

enum class UpdateType
{
	Created = 1,
	Changed = 2,
	Deleted = 3
};

int range_format(lua_State* L)
{
	int top = lua_gettop(L);

	if (top < 4)
	{
		return 0;
	}

	if (lua_isstring(L, 1) && lua_isstring(L, 2) && lua_isinteger(L, 3) && lua_isinteger(L, 4))
	{
		try
		{
			std::string filename = lua_tostring(L, 1);
			std::string text = lua_tostring(L, 2);
			int startLine = lua_tointeger(L, 3);
			int endLine = lua_tointeger(L, 4);
			LuaCodeFormat::ConfigMap configMap;

			if (top == 5 && lua_istable(L, 5))
			{
				lua_pushnil(L);
				while (lua_next(L, -2) != 0)
				{
					auto key = luaToString(L, -2);
					auto value = luaToString(L, -1);

					if (key != "nil")
					{
						configMap.insert({key, value});
					}

					lua_pop(L, 1);
				}
			}

			LuaFormatRange range(startLine, endLine);
			auto formattedText = LuaCodeFormat::GetInstance().RangeFormat(filename, range, std::move(text), configMap);
			if (formattedText.empty())
			{
				lua_pushboolean(L, false);
				return 1;
			}
			lua_pushboolean(L, true);
			lua_pushlstring(L, formattedText.c_str(), formattedText.size());
			lua_pushinteger(L, range.StartLine);
			lua_pushinteger(L, range.EndLine);

			return 4;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}
	return 0;
}


int type_format(lua_State* L)
{
	int top = lua_gettop(L);

	if (top < 4)
	{
		return 0;
	}

	if (lua_isstring(L, 1) && lua_isstring(L, 2) && lua_isinteger(L, 3) && lua_isinteger(L, 4))
	{
		try
		{
			std::string filename = lua_tostring(L, 1);
			std::string text = lua_tostring(L, 2);
			int line = lua_tointeger(L, 3);
			int character = lua_tointeger(L, 4);

			LuaCodeFormat::ConfigMap configMap;

			if (top == 5 && lua_istable(L, 5))
			{
				lua_pushnil(L);
				while (lua_next(L, -2) != 0)
				{
					auto key = luaToString(L, -2);
					auto value = luaToString(L, -1);

					if (key != "nil")
					{
						configMap.insert({key, value});
					}

					lua_pop(L, 1);
				}
			}

			LuaCodeFormat::ConfigMap stringTypeOptions;
			if (top == 6 && lua_istable(L, 6))
			{
				lua_pushnil(L);
				while (lua_next(L, -2) != 0)
				{
					auto key = luaToString(L, -2);
					auto value = luaToString(L, -1);

					if (key != "nil")
					{
						stringTypeOptions.insert({ key, value });
					}

					lua_pop(L, 1);
				}
			}
			auto typeFormat = LuaCodeFormat::GetInstance().TypeFormat(filename, line, character, std::move(text),
			                                                          configMap, stringTypeOptions);

			if (!typeFormat.HasFormatResult())
			{
				lua_pushboolean(L, false);
				return 1;
			}
			else
			{
				lua_pushboolean(L, true);
				auto& results = typeFormat.GetResult();
				if (!results.empty())
				{
					auto& result = results.front();
					// 结果
					lua_newtable(L);

					//message
					{
						lua_pushstring(L, "newText");
						lua_pushlstring(L, result.Text.c_str(), result.Text.size());
						lua_rawset(L, -3);
					}

					// range
					{
						lua_pushstring(L, "range");
						//range table
						lua_newtable(L);

						lua_pushstring(L, "start");
						// start table
						lua_newtable(L);
						lua_pushstring(L, "line");
						lua_pushinteger(L, result.Range.StartLine);
						lua_rawset(L, -3);

						lua_pushstring(L, "character");
						lua_pushinteger(L, result.Range.StartCharacter);
						lua_rawset(L, -3);

						lua_rawset(L, -3); // set start = {}

						lua_pushstring(L, "end");
						// end table
						lua_newtable(L);
						lua_pushstring(L, "line");
						lua_pushinteger(L, result.Range.EndLine);
						lua_rawset(L, -3);

						lua_pushstring(L, "character");
						lua_pushinteger(L, result.Range.EndCharacter);
						lua_rawset(L, -3);

						lua_rawset(L, -3); // set end = {}

						lua_rawset(L, -3); // set range = {}
					}
				}
				return 2;
			}
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}
	return 0;
}


int update_config(lua_State* L)
{
	int top = lua_gettop(L);

	if (top < 3)
	{
		return 0;
	}

	if (lua_isinteger(L, 1) && lua_isstring(L, 2) && lua_isstring(L, 3))
	{
		try
		{
			auto type = static_cast<UpdateType>(lua_tointeger(L, 1));
			std::string workspaceUri = lua_tostring(L, 2);
			std::string configPath = lua_tostring(L, 3);
			switch (type)
			{
			case UpdateType::Created:
			case UpdateType::Changed:
				{
					LuaCodeFormat::GetInstance().UpdateCodeStyle(workspaceUri, configPath);
					break;
				}
			case UpdateType::Deleted:
				{
					LuaCodeFormat::GetInstance().RemoveCodeStyle(workspaceUri);
					break;
				}
			}

			lua_pushboolean(L, true);
			return 1;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}

	return 0;
}

int diagnose_file(lua_State* L)
{
	int top = lua_gettop(L);

	if (top < 2)
	{
		return 0;
	}

	if (lua_isstring(L, 1) && lua_isstring(L, 2))
	{
		try
		{
			std::string filename = lua_tostring(L, 1);
			std::string text = lua_tostring(L, 2);
			auto result = LuaCodeFormat::GetInstance().Diagnose(filename, std::move(text));
			if (!result.first)
			{
				lua_pushboolean(L, false);
				return 1;
			}
			auto& diagnosticInfos = result.second;

			lua_pushboolean(L, true);
			int count = 1;
			lua_newtable(L);
			for (auto& diagnosticInfo : diagnosticInfos)
			{
				// 诊断信息表
				lua_newtable(L);

				//message
				{
					lua_pushstring(L, "message");
					lua_pushlstring(L, diagnosticInfo.Message.c_str(), diagnosticInfo.Message.size());
					lua_rawset(L, -3);

					lua_pushstring(L, "type");
					lua_pushstring(L, GetDiagnosisString(diagnosticInfo.type).c_str());
					lua_rawset(L, -3);
				}

				// range
				{
					lua_pushstring(L, "range");
					//range table
					lua_newtable(L);

					lua_pushstring(L, "start");
					// start table
					lua_newtable(L);
					lua_pushstring(L, "line");
					lua_pushinteger(L, diagnosticInfo.Range.Start.Line);
					lua_rawset(L, -3);

					lua_pushstring(L, "character");
					lua_pushinteger(L, diagnosticInfo.Range.Start.Character);
					lua_rawset(L, -3);

					lua_rawset(L, -3); // set start = {}

					lua_pushstring(L, "end");
					// end table
					lua_newtable(L);
					lua_pushstring(L, "line");
					lua_pushinteger(L, diagnosticInfo.Range.End.Line);
					lua_rawset(L, -3);

					lua_pushstring(L, "character");
					lua_pushinteger(L, diagnosticInfo.Range.End.Character);
					lua_rawset(L, -3);

					lua_rawset(L, -3); // set end = {}

					lua_rawset(L, -3); // set range = {}
				}

				// 不确认lua会不会把他改成宏，所以不要在这里用++count
				lua_rawseti(L, -2, count);
				count++;
			}

			return 2;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}
	return 0;
}

int set_default_config(lua_State* L)
{
	int top = lua_gettop(L);

	if (top != 1)
	{
		return 0;
	}

	if (lua_istable(L, 1))
	{
		try
		{
			LuaCodeFormat::ConfigMap configMap;

			lua_pushnil(L);
			while (lua_next(L, - 2) != 0)
			{
				auto key = luaToString(L, -2);
				auto value = luaToString(L, -1);

				if (key != "nil")
				{
					configMap.insert({key, value});
				}

				lua_pop(L, 1);
			}

			LuaCodeFormat::GetInstance().SetDefaultCodeStyle(configMap);
			lua_pushboolean(L, true);
			return 1;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}

	return 0;
}

int set_nonstandard_symbol(lua_State* L)
{
	int top = lua_gettop(L);

	if (top != 2)
	{
		return 0;
	}

	if (lua_isstring(L, 1) && lua_istable(L, 2))
	{
		try
		{
			std::string type = lua_tostring(L, 1);
			std::vector<std::string> tokens;
			lua_pushnil(L);
			while (lua_next(L, -2) != 0)
			{
				auto value = luaToString(L, -1);
				tokens.push_back(value);
				lua_pop(L, 1);
			}
			lua_settop(L, top);

			LuaCodeFormat::GetInstance().SetSupportNonStandardSymbol(type, tokens);
			lua_pushboolean(L, true);
			return 1;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}

	return 0;
}

int spell_load_dictionary_from_path(lua_State* L)
{
	int top = lua_gettop(L);

	if (top != 1)
	{
		return 0;
	}

	if (lua_isstring(L, 1))
	{
		try
		{
			auto path = lua_tostring(L, 1);
			LuaCodeFormat::GetInstance().LoadSpellDictionary(path);

			lua_pushboolean(L, true);
			return 1;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}

	return 0;
}


int spell_load_dictionary_from_buffer(lua_State* L)
{
	int top = lua_gettop(L);

	if (top != 1)
	{
		return 0;
	}

	if (lua_isstring(L, 1))
	{
		try
		{
			auto dictionary = lua_tostring(L, 1);
			LuaCodeFormat::GetInstance().LoadSpellDictionaryFromBuffer(dictionary);

			lua_pushboolean(L, true);
			return 1;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}

	return 0;
}

int spell_analysis(lua_State* L)
{
	int top = lua_gettop(L);

	if (top < 2)
	{
		return 0;
	}

	if (lua_isstring(L, 1) && lua_isstring(L, 2))
	{
		try
		{
			std::string filename = lua_tostring(L, 1);
			std::string text = lua_tostring(L, 2);

			CodeSpellChecker::CustomDictionary tempDict;

			if (top == 3 && lua_istable(L, 3))
			{
				lua_pushnil(L);
				while (lua_next(L, -2) != 0)
				{
					auto value = luaToString(L, -1);
					tempDict.insert(value);
					lua_pop(L, 1);
				}
			}

			auto diagnosticInfos = LuaCodeFormat::GetInstance().SpellCheck(filename, std::move(text), tempDict);

			lua_pushboolean(L, true);
			int count = 1;
			lua_newtable(L);
			for (auto& diagnosticInfo : diagnosticInfos)
			{
				// 诊断信息表
				lua_newtable(L);

				//message
				{
					lua_pushstring(L, "message");
					lua_pushlstring(L, diagnosticInfo.Message.c_str(), diagnosticInfo.Message.size());
					lua_rawset(L, -3);

					lua_pushstring(L, "type");
					lua_pushstring(L, GetDiagnosisString(diagnosticInfo.type).c_str());
					lua_rawset(L, -3);

					lua_pushstring(L, "data");
					lua_pushstring(L, diagnosticInfo.Data.c_str());
					lua_rawset(L, -3);
				}

				// range
				{
					lua_pushstring(L, "range");
					//range table
					lua_newtable(L);

					lua_pushstring(L, "start");
					// start table
					lua_newtable(L);
					lua_pushstring(L, "line");
					lua_pushinteger(L, diagnosticInfo.Range.Start.Line);
					lua_rawset(L, -3);

					lua_pushstring(L, "character");
					lua_pushinteger(L, diagnosticInfo.Range.Start.Character);
					lua_rawset(L, -3);

					lua_rawset(L, -3); // set start = {}

					lua_pushstring(L, "end");
					// end table
					lua_newtable(L);
					lua_pushstring(L, "line");
					lua_pushinteger(L, diagnosticInfo.Range.End.Line);
					lua_rawset(L, -3);

					lua_pushstring(L, "character");
					lua_pushinteger(L, diagnosticInfo.Range.End.Character);
					lua_rawset(L, -3);

					lua_rawset(L, -3); // set end = {}

					lua_rawset(L, -3); // set range = {}
				}

				// 不确认lua会不会把他改成宏，所以不要在这里用++count
				lua_rawseti(L, -2, count);
				count++;
			}

			return 2;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}
	return 0;
}

int spell_suggest(lua_State* L)
{
	int top = lua_gettop(L);

	if (top != 1)
	{
		return 0;
	}

	if (lua_isstring(L, 1))
	{
		try
		{
			std::string word = lua_tostring(L, 1);
			auto suggests = LuaCodeFormat::GetInstance().SpellCorrect(word);
			int count = 1;
			lua_newtable(L);
			for (auto& suggest : suggests)
			{
				if (!suggest.Term.empty())
				{
					lua_pushstring(L, suggest.Term.c_str());
					lua_rawseti(L, -2, count);
					count++;
				}
				// 15个已经可以了
				if (count == 15)
				{
					break;
				}
			}

			return 2;
		}
		catch (std::exception& e)
		{
			std::string err = e.what();
			lua_settop(L, top);
			lua_pushboolean(L, false);
			lua_pushlstring(L, err.c_str(), err.size());
			return 2;
		}
	}
	return 0;
}

static const luaL_Reg lib[] = {
	{"format", format},
	{"range_format", range_format},
	{"type_format", type_format},
	{"update_config", update_config},
	{"diagnose_file", diagnose_file},
	{"set_default_config", set_default_config},
	{"spell_load_dictionary_from_path", spell_load_dictionary_from_path},
	{"spell_load_dictionary_from_buffer", spell_load_dictionary_from_buffer},
	{"spell_analysis", spell_analysis},
	{"spell_suggest", spell_suggest},
	{"set_nonstandard_symbol", set_nonstandard_symbol},
	{nullptr, nullptr}
};

extern "C"
EXPORT int luaopen_code_format(lua_State* L)
{
	luaL_newlibtable(L, lib);
	luaL_setfuncs(L, lib, 0);
	return 1;
}
