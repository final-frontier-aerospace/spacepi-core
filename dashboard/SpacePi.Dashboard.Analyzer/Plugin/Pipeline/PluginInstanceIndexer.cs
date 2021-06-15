﻿using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.CodeAnalysis;
using SpacePi.Dashboard.Analyzer.Plugin.Model;

namespace SpacePi.Dashboard.Analyzer.Plugin.Pipeline {
    class PluginInstanceIndexer : PluginPipeline {
        private int NextIndex;

        public override void Init(GeneratorExecutionContext ctx) {
            NextIndex = 0;
        }

        public override void Process(PluginClass plugin) {
            foreach (PluginInstance instance in plugin.Instance) {
                instance.Index = NextIndex++;
            }
        }
    }
}
