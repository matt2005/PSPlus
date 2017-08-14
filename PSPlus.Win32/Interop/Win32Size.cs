﻿using System.Runtime.InteropServices;

namespace PSPlus.Win32.Interop
{
    [StructLayout(LayoutKind.Sequential)]
    public unsafe struct Win32Size
    {
        public int Cx;
        public int Cy;
    }
}