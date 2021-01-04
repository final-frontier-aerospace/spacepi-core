#ifndef SPACEPI_MESSAGING_NETWORK_NETWORKTHREAD_HPP
#define SPACEPI_MESSAGING_NETWORK_NETWORKTHREAD_HPP

#include <condition_variable>
#include <mutex>
#include <thread>
#include <boost/asio.hpp>
#include <spacepi/log/AutoLog.hpp>

namespace spacepi {
    namespace messaging {
        namespace network {
            /**
             * \brief Singleton class which manages a helper thread to perform networking operations
             */
            class NetworkThread : private spacepi::log::AutoLog<decltype("core:messaging"_autolog)> {
                public:
                    /**
                     * \brief Global instance of the NetworkThread singleton
                     */
                    static NetworkThread instance;

                    NetworkThread(const NetworkThread &) = delete;
                    NetworkThread &operator =(const NetworkThread &) = delete;

                    /**
                     * \brief Get the \c boost::asio::io_context which can be used to schedule work on the NetworkThread
                     * 
                     * \return The \c boost::asio::io_context
                     */
                    boost::asio::io_context &getContext() noexcept;

                    /**
                     * \brief Start the NetworkThread
                     * 
                     * There must be work scheduled on the \c io_context from getContext(), otherwise the thread will
                     * exit immediately.
                     */
                    void start();

                    /**
                     * \brief Block until the NetworkThread stops running
                     * 
                     * The thread will not stop running until the queue of work for the NetworkThread to perform has
                     * become empty.
                     */
                    void join();

                    /**
                     * \brief Stop the NetworkThread before all work is complete
                     * 
                     * This method will block until the next "good" time in which the NetworkThread can be interrupted,
                     * then will stop the thread.  Once this method returns, the NetworkThread will have been stopped.
                     */
                    void stop();

                private:
                    enum State {
                        Starting,
                        Running,
                        Stopping
                    };

                    NetworkThread();
                    ~NetworkThread();

                    void run();

                    boost::asio::io_context ctx;
                    std::mutex mtx;
                    std::condition_variable cond;
                    enum State state;
                    std::thread thread;
            };
        }
    }
}

#endif
