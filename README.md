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









