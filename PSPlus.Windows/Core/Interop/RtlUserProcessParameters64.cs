﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace PSPlus.Windows.Core.Interop
{
    [StructLayout(LayoutKind.Sequential)]
    public unsafe struct RtlUserProcessParameters64
    {
        public fixed byte Reserved1[16];
        public fixed long Reserved2[10];
        public UnicodeString ImagePathName;
        public UnicodeString CommandLine;
    }
}
