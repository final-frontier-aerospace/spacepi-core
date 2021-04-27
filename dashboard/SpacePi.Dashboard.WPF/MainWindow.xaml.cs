﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using SpacePi.Dashboard.API;

namespace SpacePi.Dashboard.WPF {
    public partial class MainWindow : Window {
        private readonly PluginContext Context;

        public MainWindow() {
            InitializeComponent();
            Context = new(null);
            Closed += (_, _) => Context.Dispose();
        }
    }
}