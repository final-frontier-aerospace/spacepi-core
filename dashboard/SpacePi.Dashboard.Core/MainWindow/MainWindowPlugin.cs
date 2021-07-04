﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SpacePi.Dashboard.API;

namespace SpacePi.Dashboard.Core.MainWindow {
    [Plugin(1000000)]
    public class MainWindowPlugin : CorePlugin<MainWindowContext> {
        protected override string PluginName => nameof(MainWindowPlugin);
    }
}
