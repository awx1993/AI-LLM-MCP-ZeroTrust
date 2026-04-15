# AI-LLM-MCP-ZeroTrust

Root cause: This is a critical problem as LLMs move from passive chatbots to agentic systems with API access, filesystem interactions, and autonomous tool use. Below is a complete architectural and engineering response tailored to your dual‑role requirement.

1. Reference Architecture Diagram (Logical + Security Layers)

                                                        <img width="261" height="290" alt="image" src="https://github.com/user-attachments/assets/6279800e-1e87-42f1-a6cd-cf0ac5b54925" />



Key design principle: The AI never holds long‑lived credentials. It receives per‑request, short‑lived, narrowly scoped tokens from a policy sidecar.


2. Security Controls Mapped to MITRE ATT&CK (Relevant TTPs)

                                                       <img width="332" height="272" alt="image" src="https://github.com/user-attachments/assets/8139d781-b40c-488c-8f29-93e4953de22e" />
