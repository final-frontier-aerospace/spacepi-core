#include <memory>
#include <utility>
#include <vector>
#include <boost/asio.hpp>
#include <spacepi/log/LogLevel.hpp>
#include <spacepi/router/Router.hpp>
#include <spacepi/router/RouterEndpoint.hpp>
#include <spacepi/router/StreamClient.hpp>
#include <spacepi/router/StreamServer.hpp>
#include <spacepi/util/Command.hpp>
#include <spacepi/util/CommandConfigurable.hpp>

using namespace std;
using namespace boost::asio::ip;
using namespace boost::asio::local;
using namespace spacepi::log;
using namespace spacepi::router;
using namespace spacepi::util;

Router::Router(Command &cmd) noexcept : CommandConfigurable("Router Options", cmd) {
    fromCommand(routerEndpoints, vector<RouterEndpoint>(), "endpoint", "A list of endpoints to listen on for local connections");
}

void Router::runCommand() {
    if (routerEndpoints.empty()) {
        routerEndpoints.push_back(RouterEndpoint::defaultEndpoint);
    }
    for (vector<RouterEndpoint>::const_iterator it = routerEndpoints.begin(); it != routerEndpoints.end(); ++it) {
        bool valid = true;
        switch (it->getType()) {
            case RouterEndpoint::TCP:
                servers.push_back(move(shared_ptr<StreamClientCallback>(new StreamServer<tcp>(pubsub, tcp::endpoint(tcp::v4(), it->getPort())))));
                break;
            case RouterEndpoint::UNIX:
            servers.push_back(move(shared_ptr<StreamClientCallback>(new StreamServer<stream_protocol>(pubsub, stream_protocol::endpoint(it->getPath())))));
                break;
            default:
                log(LogLevel::Warning) << "Skipping unknown endpoint '" << *it << "'";
                valid = false;
                break;
        }
        if (valid) {
            log(LogLevel::Info) << "Listening on " << *it << "...";
        }
    }
}
