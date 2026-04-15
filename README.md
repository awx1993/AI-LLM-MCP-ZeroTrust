# AI-LLM-MCP-ZeroTrust

Root cause: This is a critical problem as LLMs move from passive chatbots to agentic systems with API access, filesystem interactions, and autonomous tool use. Below is a complete architectural and engineering response tailored to your dual‑role requirement.

1. Reference Architecture Diagram (Logical + Security Layers)

   <img width="261" height="290" alt="image" src="https://github.com/user-attachments/assets/6279800e-1e87-42f1-a6cd-cf0ac5b54925" />



Key design principle: The AI never holds long‑lived credentials. It receives per‑request, short‑lived, narrowly scoped tokens from a policy sidecar.


2. Security Controls Mapped to MITRE ATT&CK (Relevant TTPs)

   <img width="332" height="272" alt="image" src="https://github.com/user-attachments/assets/8139d781-b40c-488c-8f29-93e4953de22e" />

3. Implementation Examples
3.1 Docker (Rootless + seccomp + AppArmor)
   Dockerfile snippet:
         
<img width="237" height="81" alt="image" src="https://github.com/user-attachments/assets/95dde294-2457-4c60-8aea-ecd6a6bda63f" />

         
   Run command:

 <img width="218" height="113" alt="image" src="https://github.com/user-attachments/assets/94a670ed-d128-406d-b193-5b77659003a4" />

seccomp example (allowlist syscalls): json

<img width="323" height="86" alt="image" src="https://github.com/user-attachments/assets/60bb95ea-f32c-40c3-8ed3-dbeab8c0f607" />


3.2 Kubernetes (Pod Security Standards + OPA)

Pod spec with restrictive profile:

<img width="269" height="257" alt="image" src="https://github.com/user-attachments/assets/53c8cd72-74fa-4d09-bcf1-82d8beccb967" />


OPA rule (deny dangerous commands):

<img width="199" height="138" alt="image" src="https://github.com/user-attachments/assets/0d10f0a0-8831-4e0a-8d24-1f35d053c379" />


3.3 VM Isolation (Kata Containers + Firecracker)

Kata runtime class:

<img width="98" height="109" alt="image" src="https://github.com/user-attachments/assets/8a4ce661-687f-4106-b9cb-043ed3015dbb" />


Firecracker VM config (jailer):

<img width="151" height="53" alt="image" src="https://github.com/user-attachments/assets/357dd40a-16da-4eab-b527-e177fad2d750" />

VM config disables virtio-fs for host passthrough, uses virtio-block (read-only for data).



4. Sample IAM Policies and Enforcement Rules
   
4.1 SPIFFE Identity & Vault Policy4.1 SPIFFE Identity & Vault Policy
SPIRE registration entry:

<img width="182" height="80" alt="image" src="https://github.com/user-attachments/assets/5475469b-91f2-46c2-b455-628926e0c767" />


Vault policy (per‑identity, not per‑AI code):

<img width="119" height="80" alt="image" src="https://github.com/user-attachments/assets/d73c20d8-5f7d-42ec-8795-6fe5a0e5c580" />

4.2 Allowlist for AI‑invoked commands
Tool shim (Python example):

<img width="275" height="147" alt="image" src="https://github.com/user-attachments/assets/358ab864-d0a9-4301-8832-2993040c22c8" />


5. Failure Scenarios and Mitigation Strategies


<img width="306" height="320" alt="image" src="https://github.com/user-attachments/assets/3a620d5f-32f3-4b96-91d1-fee8d5a95f97" />
<img width="306" height="320" alt="image" src="https://github.com/user-attachments/assets/6cdef870-9d94-47bd-adc4-39a6935dd77a" />
<img width="306" height="320" alt="image" src="https://github.com/user-attachments/assets/6637343a-f656-4efb-bcf5-6ac7678540eb" />
<img width="306" height="320" alt="image" src="https://github.com/user-attachments/assets/15a86407-fb17-4dd1-bcdb-b70aa4fa0bb4" />

6. Compliance & Zero Trust Alignment

Zero Trust principle: Every action re‑authenticates and re‑authorizes. No implicit trust inside the enclave.

CIS Docker Benchmark – 1.7 (audit), 2.2 (seccomp), 4.1 (capabilities drop), 5.24 (rootless).

NIST SP 800-207 (ZT): Micro‑perimeter around each AI session; session keys destroyed after each inference + action round.

FedRAMP High / HIPAA: HSM‑backed secrets, FIPS 140‑2 validated crypto for VM disk encryption.


Final Takeaway (GEMINI 3.0 + EC2)
The only way to prevent AI privilege escalation is not to trust the AI at all.
Treat the LLM as an untrusted network client. All its actions must pass through a policy shim that has no logical path to elevate its own permissions. No capabilities, no privileged syscalls, no metadata endpoints, and credentials that expire faster than the AI’s typical tool‑use loop.

Combine rootless containers + VM isolation + per‑call token exchange – then even a compromised model can’t move laterally.
