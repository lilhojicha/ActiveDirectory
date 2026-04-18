# Troubleshooting & Validation

## Overview
[Brief note that this documents real issues encountered 
during the lab — shows authentic hands-on experience]

---

## Issue #1: [Name the actual error you hit]

### Symptom
[What you saw — error message, screenshot if you have it]

### Investigation
[What you checked first and why]

- Checked Event Viewer → [what you found]
- Ran [command] → [what it returned]

### Root Cause
[What was actually wrong]

### Resolution
[Exactly what you did to fix it]

### Lesson Learned
[One sentence — what this taught you / what to watch 
for in production]

---

## Issue #2: [Repeat this format for each issue]

---

## Final Lab Validation

### Checklist

| Validation Point | Method | Status |
|---|---|---|
| AD DS role running | Server Manager | ✅ |
| Domain users can log in | RDP to Client-01 | ✅ |
| GPO password policy applied | gpresult /r | ✅ |
| DNS resolving correctly | nslookup | ✅ |
| Client in correct OU | ADUC | ✅ |
| DHCP leases issuing | DHCP Manager | ✅ |

[Screenshot of each validation passing]

## Reflection
[3-5 sentences: what this lab taught you, how it maps 
to real helpdesk/sysadmin work, what you'd expand next]