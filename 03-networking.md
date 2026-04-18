![Cloud networks picture](https://img.freepik.com/premium-photo/laptop-connection-cloud-storage-collaboration-generative-ai_887552-7694.jpg)

# Networking, DNS & DHCP Configuration

## Overview
The network portion that was configured was making the Domain Controller's private IP address static and configuring the client machine's DNS server to the Domain Controller's IP address.

The Domain Controller must have a static IP address for the client machine to connect to.

## Network Architecture

| Component | Value |
|---|---|
| Virtual Network | 10.0.0.0/16 |
| Subnet | 10.0.0.0/24 |
| DC-01 Static IP | 10.0.0.4 |
| Client-01 IP | 10.0.0.5 (DHCP) |


## Static IP Assignment — Domain Controller
- **Rationale:** DCs must have static IPs — DNS and 
  AD rely on a consistent address

![DC NIC](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/dcnic.png)

## DNS Configuration
### DC as Primary DNS
- Client VMs configured to point to DC-01 (10.0.0.4) 
  as DNS server
- **Rationale:** Required for domain join and AD 
  authentication to function

![Client NIC DNS settings](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/clientnic.png)

### DNS Validation
- Forward lookup zone confirmed for yourdomain.com
- Verified A records for DC-01 exist

![Client NIC DNS settings](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/dnsmanager.png)

![Client NIC DNS settings](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/arecord.png)


## Client Domain Join
- Client-01 pointed to DC DNS → joined to yourdomain.com
- Verified machine account created in Computers OU

![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/domainjoin.png)

![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/domaincomputer.png)

## Connectivity Validation

| Test | Tool | Result |
|---|---|---|
| DC ping from client | ping 10.0.0.4 | Success |
| DNS resolution | nslookup yourdomain.com | Resolved |
| Domain join auth | System Properties | Joined |


![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/pingdomain.png)

![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/nslookupdomain.png)

![Resource Group Configuration ](https://github.com/lilhojicha/ActiveDirectory/blob/main/screenshots/03-network/sysprop.png)