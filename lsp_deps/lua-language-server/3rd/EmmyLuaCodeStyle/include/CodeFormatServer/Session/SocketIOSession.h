#pragma once

#include "IOSession.h"
#include <asio.hpp>

class SocketIOSession : public IOSession
{
public:
	explicit SocketIOSession(asio::ip::tcp::socket&& socket);

	int Run(asio::io_context& ioc) override;
	void Send(std::string_view content) override;
private:
	asio::ip::tcp::socket _socket;
};
