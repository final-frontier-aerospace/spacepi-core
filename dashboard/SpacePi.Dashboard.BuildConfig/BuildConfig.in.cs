using System;

namespace SpacePi.Dashboard {
    public static class BuildConfig {
        public static readonly string CMAKE_BINARY_DIR = "${CMAKE_BINARY_DIR}";
        public static readonly string CMAKE_COMMAND = "${CMAKE_COMMAND}";
        public static readonly string CMAKE_SOURCE_DIR = "${CMAKE_SOURCE_DIR}";
        public static readonly string Protobuf_PROTOC_EXECUTABLE = "${Protobuf_PROTOC_EXECUTABLE}";

        public static class protoc_gen_spacepi_csharp {
            public static readonly string TARGET_FILE = "$<TARGET_FILE:protoc-gen-spacepi-csharp>";
            public static readonly string TARGET_NAME_IF_EXISTS = "$<TARGET_NAME_IF_EXISTS:protoc-gen-spacepi-csharp>";
        }
    }
}