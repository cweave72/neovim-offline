﻿#include "CodeService/Spell/CodeSpellChecker.h"
#include "LuaParser/LuaTokenTypeDetail.h"
#include "Util/format.h"
#include "CodeService/Spell/TextParser.h"

CodeSpellChecker::CodeSpellChecker()
	: _symSpell(std::make_shared<SymSpell>(SymSpell::Strategy::LazyLoaded))
{
}

void CodeSpellChecker::LoadDictionary(std::string_view path)
{
	_symSpell->LoadWordDictionary(std::string(path));
}

void CodeSpellChecker::LoadDictionaryFromBuffer(std::string_view buffer)
{
	_symSpell->LoadWordDictionaryFromBuffer(buffer);
}

void CodeSpellChecker::Analysis(DiagnosisContext& ctx, const CustomDictionary& customDict)
{
	auto parser = ctx.GetParser();
	auto tokenParser = parser->GetTokenParser();
	auto& tokens = tokenParser->GetTokens();

	for (auto& token : tokens)
	{
		if (token.TokenType == TK_NAME)
		{
			IdentifyAnalysis(ctx, token, customDict);
		}
		else if (token.TokenType == TK_STRING)
		{
			TextAnalysis(ctx, token, customDict);
		}
	}
}

std::vector<SuggestItem> CodeSpellChecker::GetSuggests(std::string word)
{
	enum class ParseState
	{
		Unknown,
		FirstUpper,
		AllUpper,
		Lower,
	} state = ParseState::Unknown;

	std::vector<SuggestItem> suggests;

	for (std::size_t i = 0; i != word.size(); i++)
	{
		char& c = word[i];
		if (c < 0 || !std::isalpha(c))
		{
			return suggests;
		}

		switch (state)
		{
		case ParseState::Unknown:
			{
				if (std::isupper(c))
				{
					state = ParseState::AllUpper;
					c = static_cast<char>(std::tolower(c));
				}
				else // lower
				{
					state = ParseState::Lower;
				}

				break;
			}
		case ParseState::AllUpper:
			{
				if (std::islower(c))
				{
					if (i == 1)
					{
						state = ParseState::FirstUpper;
					}
					else
					{
						return suggests;
					}
				}
				c = static_cast<char>(std::tolower(c));
				break;
			}
		case ParseState::FirstUpper:
			{
				if (!std::islower(c))
				{
					return suggests;
				}
				break;
			}
		case ParseState::Lower:
			{
				if (std::isupper(c))
				{
					return suggests;
				}
				break;
			}
		}
	}

	if (state == ParseState::Unknown)
	{
		return suggests;
	}

	suggests = _symSpell->LookUp(word);

	switch (state)
	{
	case ParseState::FirstUpper:
		{
			for (auto& suggest : suggests)
			{
				if (!suggest.Term.empty())
				{
					suggest.Term[0] = std::toupper(suggest.Term[0]);
				}
			}
			break;
		}
	case ParseState::AllUpper:
		{
			for (auto& suggest : suggests)
			{
				if (!suggest.Term.empty())
				{
					for (auto& ch : suggest.Term)
					{
						ch = std::toupper(ch);
					}
				}
			}
			break;
		}
	default:
		{
			break;
		}
	}

	return suggests;
}

void CodeSpellChecker::IdentifyAnalysis(DiagnosisContext& ctx, LuaToken& token, const CustomDictionary& customDict)
{
	std::shared_ptr<spell::IdentifyParser> parser = nullptr;
	std::string text(token.Text);

	if (customDict.count(text) != 0)
	{
		return;
	}

	auto it = _caches.find(text);
	if (it != _caches.end())
	{
		parser = it->second;
	}
	else
	{
		parser = std::make_shared<spell::IdentifyParser>(token.Text);
		parser->Parse();
		_caches.insert({text, parser});
	}

	auto& words = parser->GetWords();
	if (words.empty())
	{
		return;
	}

	for (auto& word : words)
	{
		if (!word.Item.empty() && !_symSpell->IsCorrectWord(word.Item) && customDict.count(word.Item) == 0)
		{
			auto range = TextRange(token.Range.StartOffset + word.Range.Start,
			                       token.Range.StartOffset + word.Range.Start + word.Range.Count - 1
			);
			std::string originText(token.Text.substr(word.Range.Start, word.Range.Count));
			ctx.PushDiagnosis(Util::format("Typo in identifier '{}'", originText), range, DiagnosisType::Spell,
			                  originText);
		}
	}
}

void CodeSpellChecker::TextAnalysis(DiagnosisContext& ctx, LuaToken& token, const CustomDictionary& customDict)
{
	std::shared_ptr<spell::TextParser> parser = std::make_shared<spell::TextParser>(token.Text);
	parser->Parse();
	auto& identifiers = parser->GetIdentifiers();
	if (identifiers.empty())
	{
		return;
	}

	for (auto& identifier : identifiers)
	{
		auto& text = identifier.Item;

		if (customDict.count(text) != 0)
		{
			continue;
		}
		std::shared_ptr<spell::IdentifyParser> identifierParser = nullptr;

		auto it = _caches.find(text);
		if (it != _caches.end())
		{
			identifierParser = it->second;
		}
		else
		{
			identifierParser = std::make_shared<spell::IdentifyParser>(text);
			identifierParser->Parse();
			_caches.insert({text, identifierParser});
		}

		auto& words = identifierParser->GetWords();
		if (words.empty())
		{
			continue;
		}

		for (auto& word : words)
		{
			if (!word.Item.empty() && !_symSpell->IsCorrectWord(word.Item) && customDict.count(word.Item) == 0)
			{
				auto range = TextRange(token.Range.StartOffset + identifier.Range.Start + word.Range.Start,
				                       token.Range.StartOffset + identifier.Range.Start + word.Range.Start + word.Range.
				                       Count - 1
				);
				std::string originText(token.Text.substr(identifier.Range.Start + word.Range.Start, word.Range.Count));
				ctx.PushDiagnosis(Util::format("Typo in string '{}'", originText), range, DiagnosisType::Spell,
				                  originText);
			}
		}
	}
}
