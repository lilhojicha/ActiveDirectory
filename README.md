# Active Directory Home Lab

## Objective
I built a Windows Server 2022 domain controller and Windows 10 client in a virtual lab, created and organized OUs, provisioned users and security groups, applied password and drive-mapping policies, configured file share access with NTFS permissions, delegated password reset rights to a Helpdesk group, and validated domain logons and policy application from the client machine.

## Lab Architecture
![Network Topology](screenshots/01-setup/network.png)

| Machine | OS | Role | Private IP |
|---|---|---|---|
| DC-1 | Windows Server 2022 | Domain Controller | 10.0.0.4 |
| Client-1 | Windows 10 Pro | Domain-joined Workstation | 10.0.0.5 |

## Technologies Used
-	Microsoft Azure 
-	Windows Server 2022 (Domain Controller)
-	Windows 10 Pro (Domain-joined client)
-	Active Directory Domain Service (AD DS)
-	DNS (Domain Name Service)
-	DHCP (Dynamic Host Configuration Protocol)
-	PowerShell

## Lab Documentation
- [01 - Environment Setup](01-environment-setup.md)
- [02 - AD Installation & OU structure](02-ad-installation-and-config.md)
- [03 - Networking & DNS](03-networking-dns-dhcp.md)
- [04 - Real World AD Tasks](04-real-world-ad-tasks.md)
- [05 - Troubleshooting & Validation](05-troubleshooting.md)

## Key Skills Demonstrated
- Active Directory domain and DNS fundamentals
- Proper OU design based on policy and delegation
- Group-based access control (RBAC)
- User authentication and authorization flow
- Group Policy design and application
- Secure file sharing using NTFS permissions
- Delegation of administrative tasks
- PowerShell automation for identity management

## Outcomes
This lab developed hands-on familiarity with tasks commonly performed in Tier 1/2 IT support and junior sysadmin roles. Working through real configuration errors — including Share vs. NTFS permission conflicts, GPO enforcement behavior, and PowerShell account provisioning failures — required understanding the underlying behavior of Windows permissions and Group Policy enforcement, not just applying fixes.

Specific competencies developed and validated through this lab:

- Designing and deploying an enterprise-style OU structure scalable 
  across multiple branch locations
- Implementing RBAC through security groups rather than direct 
  permission assignment
- Automating user and group provisioning with PowerShell across 
  a 20+ location OU hierarchy
- Diagnosing and resolving permission conflicts between Share and 
  NTFS layers
- Applying and validating Group Policy at the domain level using 
  gpresult and gpupdate
- Delegating administrative tasks to Helpdesk staff following the 
  principle of least privilege

This lab has given me a foundation to support Active Directory environments, 
handle user provisioning and access issues, troubleshoot Group Policy 
and file share problems, and document resolutions in a format consistent 
with professional IT operations.