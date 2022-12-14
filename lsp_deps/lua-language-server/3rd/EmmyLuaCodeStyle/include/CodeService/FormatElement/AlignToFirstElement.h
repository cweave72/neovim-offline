﻿#pragma once

#include "FormatElement.h"

class AlignToFirstElement : public FormatElement
{
public:
	AlignToFirstElement();

	FormatElementType GetType() override;

	void Serialize(SerializeContext& ctx, ChildIterator selfIt, FormatElement& parent) override;
	void Diagnosis(DiagnosisContext& ctx, ChildIterator selfIt, FormatElement& parent) override;
private:
	void SerializeSubExpression(SerializeContext& ctx, FormatElement& parent);
};
