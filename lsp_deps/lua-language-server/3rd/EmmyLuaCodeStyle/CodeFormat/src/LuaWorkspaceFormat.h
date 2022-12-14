#pragma once

#include <string>
#include <string_view>
#include <filesystem>
#include "LuaFormat.h"
#include "CodeService/LuaCodeStyleOptions.h"
#include "CodeService/LuaEditorConfig.h"

class LuaWorkspaceFormat
{
public:
	LuaWorkspaceFormat(std::string_view workspace);

	bool SetConfigPath(std::string_view config);

	void AddIgnoresByFile(std::string_view gitIgnoreFile);

	void AddIgnores(std::string_view pattern);

	void SetAutoDetectConfig(bool detect);

	void SetKeyValues(std::map<std::string, std::string, std::less<>>& keyValues);

	// void SetOutput(std::string_view out);

	void ReformatWorkspace();

	bool CheckWorkspace();
	
private:
	void CollectEditorconfig();
	std::shared_ptr<LuaCodeStyleOptions> GetOptions(std::string_view path);

	std::filesystem::path _workspace;
	bool _autoDetectConfig;
	std::vector<std::pair<std::string, std::shared_ptr<LuaEditorConfig>>> _editorConfigVector;
	std::shared_ptr<LuaCodeStyleOptions> _defaultOptions;
	std::vector<std::string> _ignorePattern;
	// std::string _output;
};
