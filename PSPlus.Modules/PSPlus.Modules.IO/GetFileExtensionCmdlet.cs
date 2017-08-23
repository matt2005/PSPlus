﻿using PSPlus.Core;
using System;
using System.IO;
using System.Management.Automation;

namespace PSPlus.Modules.IO
{
    [Cmdlet(VerbsCommon.Get, "FileExtension")]
    [OutputType(typeof(string))]
    public class GetFileExtensionCmdlet : CmdletBaseWithInputObject<string>
    {
        protected override void ProcessRecord()
        {
            if (string.IsNullOrWhiteSpace(InputObject))
            {
                throw new ArgumentException("InputObject cannot be null or empty.");
            }

            string extension = Path.GetExtension(InputObject);
            WriteObject(extension);
        }
    }
}
