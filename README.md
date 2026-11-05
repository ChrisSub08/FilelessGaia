# GAÏA — Orion Cybersecurity Training Project

> **FOR EDUCATIONAL AND AUTHORIZED CYBERSECURITY TRAINING PURPOSES ONLY**  
> **STRICTLY LIMITED TO CONTROLLED AND AUTHORIZED ENVIRONMENTS**

## 1\. Introduction

**Gaïa** is a cybersecurity research and training project developed as part of **Orion**, an educational military cybersecurity initiative.

Its name comes from Greek mythology. In the myth, Gaia sends a scorpion to kill Orion. This relationship inspired the project's naming and architecture: Gaïa represents the coordination component associated with the Orion training scenario.

The project aims to support cybersecurity training by studying the architecture and characteristics of PowerShell-based backdoor threats, particularly in the context of defending sensitive infrastructure such as healthcare institutions.

Gaïa is developed as a controlled simulation of a command-and-control (C2) architecture, allowing students and authorized security personnel to study potential threats and improve defensive detection and incident response capabilities.

## 2\. Project Objectives

The primary objectives of Gaïa are:

- Study PowerShell-based threats and their architectural characteristics.
- Understand the interaction between PowerShell and C# in security research.
- Examine how malicious software can be structured into independent components.
- Study the security implications of code transformation and obfuscation.
- Understand the architecture of command-and-control systems.
- Improve defensive monitoring, detection, and incident response capabilities.
- Support controlled cybersecurity exercises targeting critical infrastructure resilience.

## 3\. Technical Architecture

Gaïa is built around PowerShell and C#.

PowerShell serves as the main scripting and orchestration environment, while C# provides additional implementation flexibility through the .NET ecosystem.

This hybrid architecture allows students to study the interaction between scripting languages and compiled code in the context of cybersecurity research.

The project is organized into four principal components.

## 4\. Repository Structure and File Descriptions

### `gaia_backdoor.ps1`

**Core component — Backdoor simulation**

This file represents the original implementation of the Gaïa backdoor simulation.

It constitutes the foundational component of the project and serves as the primary reference implementation for the other components.

It demonstrates the architectural characteristics of a PowerShell-based backdoor, including the integration of C# code within a PowerShell execution environment.

Its primary educational purpose is to help students understand the structure and security implications of this class of threat.

### `gaia_minification.ps1`

**Code transformation — Minification**

This component is dedicated to the study of source-code minification.

It demonstrates how a PowerShell implementation can be transformed into a more compact representation, including a single-line format.

From a defensive perspective, this component provides an opportunity to examine how code formatting and structural transformations can affect static analysis and security monitoring.

### `gaia_obfuscation.ps1`

**Code transformation — Obfuscation research**

This component explores code obfuscation techniques in the context of PowerShell security research.

It is associated with the study of transformations applied to compact code representations.

Its educational purpose is to demonstrate why defenders should not rely exclusively on source-code readability or conventional signatures when analyzing suspicious scripts.

### `gaia_server.ps1`

**Server component — C2 architecture simulation**

This file implements the server-side component associated with the Gaïa training architecture.

It represents the coordination endpoint with which the backdoor simulation is designed to communicate.

Its purpose in the exercise is to illustrate the architectural relationship between a client-side implant simulation and a centralized command-and-control infrastructure.

The component is intended exclusively for isolated laboratory exercises and authorized demonstrations.

## 5\. Technology Stack

| Technology | Purpose |
| --- | --- |
| PowerShell | Main scripting and orchestration environment |
| C# | Additional implementation flexibility within the .NET ecosystem |
| .NET | Runtime and interoperability environment |
| PowerShell scripts (`.ps1`) | Project components and research utilities |

## 6\. Security and Ethical Considerations

Gaïa is a dual-use cybersecurity research project.

Its architecture studies concepts that can also be found in real-world malicious software.

For this reason, its use is subject to strict restrictions.

### Authorized environments

The project may only be used:

- In isolated cybersecurity laboratories.
- During formally authorized academic exercises.
- Within military cybersecurity training environments.
- On systems explicitly assigned to the exercise.
- With synthetic data and non-production infrastructure.

### Prohibited activities

The project must never be used to:

- Obtain unauthorized access to computer systems.
- Compromise third-party infrastructure.
- Conduct unauthorized surveillance.
- Disrupt healthcare or other critical infrastructure.
- Execute malicious operations against production systems.
- Circumvent security controls outside a formally authorized test.

**Healthcare infrastructure and real patient data must never be used as experimental targets.**

## 7\. Educational Disclaimer

> **FOR EDUCATIONAL PURPOSES ONLY — NOT FOR UNAUTHORIZED USE**

Gaïa is provided exclusively for educational, academic, research, and authorized cybersecurity training purposes.

The project is part of the Orion initiative and was developed in the context of a controlled cybersecurity training exercise.

The authors and contributors do not encourage or authorize malicious use of the software.

Any deployment, execution, modification, or distribution must comply with applicable laws, regulations, institutional policies, and explicit authorization requirements.

The authors and contributors disclaim responsibility for unauthorized or unlawful use of the project, to the extent permitted by applicable law.

This disclaimer does not provide immunity from legal responsibility and does not override applicable legislation.

## 8\. License

Gaïa is distributed under the **MIT License**.

Copyright (c) 2026 Christophe SUBLET, Grenoble INP - Esisar, UGA, CyberSkills@UGA

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY ARISING FROM THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW.

See the `LICENSE` file for the complete license text.

## 9\. Project Attribution

**Project:** Orion\
**Component:** Gaïa\
**Category:** Cybersecurity Research and Training\
**Language:** PowerShell / C#\
**License:** MIT

---

_Gaïa is a cybersecurity education project. Its purpose is to help defenders understand, identify, and prepare for threats against critical infrastructure._

**FOR EDUCATIONAL AND AUTHORIZED SECURITY TRAINING PURPOSES ONLY.**
