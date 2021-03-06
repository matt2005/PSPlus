﻿using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using PSPlus.Core.Windows.Interop.Ntdll;
using PSPlus.Windows.Core.Interop;
using PSPlus.Windows.Interop.Kernel32;

namespace PSPlus.Core.Windows.Diagnostics
{
    public static class ProcessExtensions
    {
        public static bool IsWow64Process(this Process process)
        {
            bool isWow64Process = false;
            unsafe
            {
                Kernel32APIs.IsWow64Process(process.Handle, &isWow64Process);
            }
            return isWow64Process;
        }

        public static bool Is64BitsProcess(this Process process)
        {
            if (!Environment.Is64BitOperatingSystem)
            {
                return false;
            }

            bool isWow64Process = process.IsWow64Process();
            return !isWow64Process;
        }

        public static byte[] ReadProcessMemory(this Process process, IntPtr address, int size)
        {
            unsafe
            {
                byte[] buffer = new byte[size];
                fixed (byte* bufferAddress = buffer)
                {
                    IntPtr numberOfBytesRead;
                    if (!Kernel32APIs.ReadProcessMemory(process.Handle, address, new IntPtr(bufferAddress), size, new IntPtr(&numberOfBytesRead)))
                    {
                        return null;
                    }

                    if (numberOfBytesRead.ToInt32() != size)
                    {
                        return null;
                    }
                }

                return buffer;
            }
        }

        public static string GetCommandLine(this Process process)
        {
            bool isProcess64Bit = process.Is64BitsProcess();

            string commandLine = string.Empty;
            unsafe
            {
                ProcessBasicInformation basicInfomation;
                int status = NtdllAPIs.NtQueryInformationProcess(process.Handle, (int)ProcessInfoClass.ProcessBasicInformation, new IntPtr(&basicInfomation), (ulong)Marshal.SizeOf(basicInfomation), null);
                if (status != 0)
                {
                    throw new InvalidOperationException(string.Format("Unable to query information from process: Id = {0}.", process.Id));
                }

                IntPtr processParameterAddress = new IntPtr();
                if (isProcess64Bit)
                {
                    PEB64 peb64;
                    IntPtr numberOfBytesRead;
                    if (!Kernel32APIs.ReadProcessMemory(process.Handle, basicInfomation.PebBaseAddress, new IntPtr(&peb64), sizeof(PEB64), new IntPtr(&numberOfBytesRead)) || sizeof(PEB64) != numberOfBytesRead.ToInt32())
                    {
                        throw new InvalidOperationException(string.Format("Unable to read PEB from process: Id = {0}.", process.Id));
                    }
                    processParameterAddress = (IntPtr)peb64.ProcessParameters;
                }
                else
                {
                    // It looks like Wow64 processes have 2 PEBs. And to get the right one is very tricky.
                    // https://stackoverflow.com/questions/34736009/get-32bit-peb-of-another-process-from-a-x64-process.
                    IntPtr pebAddress = basicInfomation.PebBaseAddress;
                    if (Environment.Is64BitOperatingSystem && Environment.Is64BitProcess)
                    {
                        pebAddress += 0x1000;
                    }

                    PEB32 peb32;
                    IntPtr numberOfBytesRead;
                    if (!Kernel32APIs.ReadProcessMemory(process.Handle, pebAddress, new IntPtr(&peb32), sizeof(PEB32), new IntPtr(&numberOfBytesRead)) || sizeof(PEB32) != numberOfBytesRead.ToInt32())
                    {
                        throw new InvalidOperationException(string.Format("Unable to read PEB from process: Id = {0}.", process.Id));
                    }
                    processParameterAddress = (IntPtr)peb32.ProcessParameters;
                }

                IntPtr commandLineBufferAddress;
                int commandLineLength;
                if (isProcess64Bit)
                {
                    RtlUserProcessParameters64 processParameters64;
                    IntPtr numberOfBytesRead;
                    if (!Kernel32APIs.ReadProcessMemory(process.Handle, processParameterAddress, new IntPtr(&processParameters64), sizeof(RtlUserProcessParameters64), new IntPtr(&numberOfBytesRead)) || sizeof(RtlUserProcessParameters64) != numberOfBytesRead.ToInt32())
                    {
                        throw new InvalidOperationException(string.Format("Unable to read process parameters from process: Id = {0}.", process.Id));
                    }
                    commandLineBufferAddress = (IntPtr)processParameters64.CommandLine.Buffer;
                    commandLineLength = processParameters64.CommandLine.Length;
                }
                else
                {
                    RtlUserProcessParameters32 processParameters32;
                    IntPtr numberOfBytesRead;
                    if (!Kernel32APIs.ReadProcessMemory(process.Handle, processParameterAddress, new IntPtr(&processParameters32), sizeof(RtlUserProcessParameters32), new IntPtr(&numberOfBytesRead)) || sizeof(RtlUserProcessParameters32) != numberOfBytesRead.ToInt32())
                    {
                        throw new InvalidOperationException(string.Format("Unable to read process parameters from process: Id = {0}.", process.Id));
                    }
                    commandLineBufferAddress = (IntPtr)processParameters32.CommandLine.Buffer;
                    commandLineLength = processParameters32.CommandLine.Length;
                }

                byte[] commandLineBuffer = process.ReadProcessMemory(commandLineBufferAddress, commandLineLength);
                if (commandLineBuffer == null)
                {
                    throw new InvalidOperationException(string.Format("Unable to reach command line buffer from process: Id = {0}.", process.Id));
                }

                commandLine = Encoding.Unicode.GetString(commandLineBuffer, 0, commandLineLength);
            }

            return commandLine;
        }
    }
}
