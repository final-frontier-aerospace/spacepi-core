#ifndef SPACEPI_CORE_LOG_AUTOLOG_HPP
#define SPACEPI_CORE_LOG_AUTOLOG_HPP

#include <string>
#include <utility>
#include <spacepi/log/Logger.hpp>

namespace spacepi {
    namespace log {
        template <typename>
        class AutoLog {
        };

        template <char... tag>
        class AutoLog<std::integer_sequence<char, tag...>> {
            protected:
                AutoLog() noexcept : log(getTag()) {
                }

                Logger log;

            private:
                static constexpr std::string getTag() noexcept {
                    constexpr char str[sizeof...(tag)] = { tag... };
                    return std::string(str, sizeof...(tag));
                }
        };
    }
}

template <typename Char, Char... chars>
constexpr std::integer_sequence<Char, chars...> operator ""_autolog() noexcept {
    return {};
}

#endif
