#pragma once

#include <string>
#include "DiagnosisType.h"

class LuaDiagnosisPosition
{
public:
	LuaDiagnosisPosition(int line, int character)
		: Line(line),
		  Character(character)
	{
	}

	int Line = 0;
	int Character = 0;
};

class LuaDiagnosisRange
{
public:
	LuaDiagnosisRange(LuaDiagnosisPosition start, LuaDiagnosisPosition end)
		: Start(start),
		  End(end)
	{
	}

	LuaDiagnosisPosition Start;
	LuaDiagnosisPosition End;
};

class LuaDiagnosisInfo
{
public:
	std::string Message;
	LuaDiagnosisRange Range;
	DiagnosisType type;
	std::string Data;
};
