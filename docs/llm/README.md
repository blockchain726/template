# Private & Domain-Specific LLMs â Reference Library

Documents for teams building **private, self-hosted or domain-adapted language
models** inside an organisation: governance and risk frameworks, application
security, and peer-reviewed research across industry verticals.

Every file here is **cleared for redistribution, commercial use included** â US
Government public-domain publications, CC-BY-SA, and arXiv papers under CC-BY,
CC-BY-SA or CC0. Papers under more restrictive licences are listed as links, not
mirrored. See [Licensing](#licensing) for how this was determined.

Retrieved 2026-10-21. Verify integrity with:

```bash
cd docs/llm && sha256sum -c SHA256SUMS
```

---

## Start here

| Document | Why it matters |
|---|---|
| [NIST AI RMF 1.0](governance/NIST.AI.100-1-AI-Risk-Management-Framework.pdf) | The reference framework for governing an AI deployment: Govern / Map / Measure / Manage |
| [NIST Generative AI Profile](governance/NIST.AI.600-1-Generative-AI-Profile.pdf) | AI RMF applied specifically to generative AI â the 12 GenAI risk categories |
| [OWASP Top 10 for LLM Applications 2025](security/OWASP-Top-10-for-LLM-Applications-v2025.pdf) | The practical security checklist: prompt injection, supply chain, data leakage, excessive agency |
| [NIST Adversarial ML Taxonomy](governance/NIST.AI.100-2e2025-Adversarial-ML-Taxonomy.pdf) | Attack taxonomy and terminology for ML and generative systems |

If you read one document before starting a private-LLM project, read the
**Generative AI Profile** â it turns abstract risk language into concrete
questions you can answer about your own deployment.

---

## Governance & frameworks

US Government works â public domain in the US (17 U.S.C. Â§105), unrestricted
redistribution. Source: <https://www.nist.gov/itl/ai-risk-management-framework>

| File | Topic |
|---|---|
| `NIST.AI.100-1` | AI Risk Management Framework 1.0 |
| `NIST.AI.600-1` | Generative AI Profile (companion to the AI RMF) |
| `NIST.AI.100-2e2025` | Adversarial Machine Learning: taxonomy and terminology |

## Application security

OWASP GenAI Security Project, licensed **CC-BY-SA 4.0**, which explicitly permits
copying and redistribution in any medium. Source: <https://genai.owasp.org/>

| File | Topic |
|---|---|
| `OWASP-Top-10-for-LLM-Applications-v2025.pdf` | The 2025 Top 10 for LLM applications (45 pp) |
| `OWASP-Top-10-LLM-Applications-Architecture-2025.pdf` | Reference architecture diagram |

---

## Research papers by field

115 arXiv papers, all under CC-BY 4.0, CC-BY-SA 4.0 or CC0 â redistributable
including commercially. Grouped by the topic that surfaced them; many span
several areas.

### Agents & tool use

| Paper | arXiv | Licence |
|---|---|---|
| [LLM Agents for Education: Advances and Applications](papers/arXiv-2503.11733-LLM-Agents-for-Education-Advances-and-Applications.pdf) | [2503.11733](https://arxiv.org/abs/2503.11733) | CC BY 4.0 |
| [Large Language Model Agent: A Survey on Methodology, Applications and Challenges](papers/arXiv-2503.21460-Large-Language-Model-Agent-A-Survey-on-Methodology-Applications-and-Chal.pdf) | [2503.21460](https://arxiv.org/abs/2503.21460) | CC BY 4.0 |

### Distillation & model compression

| Paper | arXiv | Licence |
|---|---|---|
| [Sparse Logit Sampling: Accelerating Knowledge Distillation in LLMs](papers/arXiv-2503.16870-Sparse-Logit-Sampling-Accelerating-Knowledge-Distillation-in-LLMs.pdf) | [2503.16870](https://arxiv.org/abs/2503.16870) | CC BY-SA 4.0 |
| [How Is Uncertainty Propagated in Knowledge Distillation?](papers/arXiv-2601.18909-How-Is-Uncertainty-Propagated-in-Knowledge-Distillation.pdf) | [2601.18909](https://arxiv.org/abs/2601.18909) | CC BY 4.0 |

### Education

| Paper | arXiv | Licence |
|---|---|---|
| [Elucidating STEM Concepts through Generative AI: A Multi-modal Exploration of Analogical Reasoning](papers/arXiv-2308.10454-Elucidating-STEM-Concepts-through-Generative-AI-A-Multi-modal-Exploratio.pdf) | [2308.10454](https://arxiv.org/abs/2308.10454) | CC BY 4.0 |
| [Future-proofing Education: A Prototype for Simulating Oral Examinations Using Large Language Models](papers/arXiv-2401.06160-Future-proofing-Education-A-Prototype-for-Simulating-Oral-Examinations-U.pdf) | [2401.06160](https://arxiv.org/abs/2401.06160) | CC BY 4.0 |
| [Tailoring Chatbots for Higher Education: Some Insights and Experiences](papers/arXiv-2409.06717-Tailoring-Chatbots-for-Higher-Education-Some-Insights-and-Experiences.pdf) | [2409.06717](https://arxiv.org/abs/2409.06717) | CC BY 4.0 |

### Efficient inference & serving

| Paper | arXiv | Licence |
|---|---|---|
| [Closer Look at Efficient Inference Methods: A Survey of Speculative Decoding](papers/arXiv-2411.13157-Closer-Look-at-Efficient-Inference-Methods-A-Survey-of-Speculative-Decod.pdf) | [2411.13157](https://arxiv.org/abs/2411.13157) | CC BY 4.0 |
| [Optimizing LLMs for Resource-Constrained Environments: A Survey of Model Compression Techniques](papers/arXiv-2505.02309-Optimizing-LLMs-for-Resource-Constrained-Environments-A-Survey-of-Model.pdf) | [2505.02309](https://arxiv.org/abs/2505.02309) | CC BY 4.0 |
| [DeepSeek in Healthcare: A Survey of Capabilities, Risks, and Clinical Applications of Open-Source Large Language Models](papers/arXiv-2506.01257-DeepSeek-in-Healthcare-A-Survey-of-Capabilities-Risks-and-Clinical-Appli.pdf) | [2506.01257](https://arxiv.org/abs/2506.01257) | CC BY 4.0 |

### Evaluation & benchmarking

| Paper | arXiv | Licence |
|---|---|---|
| [Large Language Models Meet NL2Code: A Survey](papers/arXiv-2212.09420-Large-Language-Models-Meet-NL2Code-A-Survey.pdf) | [2212.09420](https://arxiv.org/abs/2212.09420) | CC BY 4.0 |
| [Improving LLM Leaderboards with Psychometrical Methodology](papers/arXiv-2501.17200-Improving-LLM-Leaderboards-with-Psychometrical-Methodology.pdf) | [2501.17200](https://arxiv.org/abs/2501.17200) | CC BY 4.0 |
| [VideoLLM Benchmarks and Evaluation: A Survey](papers/arXiv-2505.03829-VideoLLM-Benchmarks-and-Evaluation-A-Survey.pdf) | [2505.03829](https://arxiv.org/abs/2505.03829) | CC BY 4.0 |
| [Evaluating LLM-Generated Code: A Benchmark and Developer Study](papers/arXiv-2605.09059-Evaluating-LLM-Generated-Code-A-Benchmark-and-Developer-Study.pdf) | [2605.09059](https://arxiv.org/abs/2605.09059) | CC BY 4.0 |

### Federated & distributed training

| Paper | arXiv | Licence |
|---|---|---|
| [Blockchain-based Framework for Scalable and Incentivized Federated Learning](papers/arXiv-2502.14170-Blockchain-based-Framework-for-Scalable-and-Incentivized-Federated-Learn.pdf) | [2502.14170](https://arxiv.org/abs/2502.14170) | CC BY 4.0 |
| [Performance Analysis of Decentralized Federated Learning Deployments](papers/arXiv-2503.11828-Performance-Analysis-of-Decentralized-Federated-Learning-Deployments.pdf) | [2503.11828](https://arxiv.org/abs/2503.11828) | CC BY 4.0 |
| [Enhancing Model Privacy in Federated Learning with Random Masking and Quantization](papers/arXiv-2508.18911-Enhancing-Model-Privacy-in-Federated-Learning-with-Random-Masking-and-Qu.pdf) | [2508.18911](https://arxiv.org/abs/2508.18911) | CC BY 4.0 |
| [Scaling Law Analysis in Federated Learning: How to Select the Optimal Model Size?](papers/arXiv-2511.12188-Scaling-Law-Analysis-in-Federated-Learning-How-to-Select-the-Optimal-Mod.pdf) | [2511.12188](https://arxiv.org/abs/2511.12188) | CC BY 4.0 |
| [Automating aggregation strategy selection in federated learning](papers/arXiv-2604.08056-Automating-aggregation-strategy-selection-in-federated-learning.pdf) | [2604.08056](https://arxiv.org/abs/2604.08056) | CC BY 4.0 |
| [GuidaPA: Privacy-Preserving Chatbot for Public Administration via Federated Learning](papers/arXiv-2606.01386-GuidaPA-Privacy-Preserving-Chatbot-for-Public-Administration-via-Federat.pdf) | [2606.01386](https://arxiv.org/abs/2606.01386) | CC BY 4.0 |

### Finance

| Paper | arXiv | Licence |
|---|---|---|
| [WeaverBird: Empowering Financial Decision-Making with Large Language Model, Knowledge Base, and Search Engine](papers/arXiv-2308.05361-WeaverBird-Empowering-Financial-Decision-Making-with-Large-Language-Mode.pdf) | [2308.05361](https://arxiv.org/abs/2308.05361) | CC BY 4.0 |
| [Retrieval Augmented Generation for Domain-specific Question Answering](papers/arXiv-2404.14760-Retrieval-Augmented-Generation-for-Domain-specific-Question-Answering.pdf) | [2404.14760](https://arxiv.org/abs/2404.14760) | CC BY 4.0 |
| [A Scoping Review of ChatGPT Research in Accounting and Finance](papers/arXiv-2412.05731-A-Scoping-Review-of-ChatGPT-Research-in-Accounting-and-Finance.pdf) | [2412.05731](https://arxiv.org/abs/2412.05731) | CC BY 4.0 |
| [Sovereign Large Language Models: Advantages, Strategy and Regulations](papers/arXiv-2503.04745-Sovereign-Large-Language-Models-Advantages-Strategy-and-Regulations.pdf) | [2503.04745](https://arxiv.org/abs/2503.04745) | CC BY-SA 4.0 |
| [Finance Agent Benchmark: Benchmarking LLMs on Real-world Financial Research Tasks](papers/arXiv-2508.00828-Finance-Agent-Benchmark-Benchmarking-LLMs-on-Real-world-Financial-Resear.pdf) | [2508.00828](https://arxiv.org/abs/2508.00828) | CC BY 4.0 |
| [Comparing LLMs for Sentiment Analysis in Financial Market News](papers/arXiv-2510.15929-Comparing-LLMs-for-Sentiment-Analysis-in-Financial-Market-News.pdf) | [2510.15929](https://arxiv.org/abs/2510.15929) | CC BY 4.0 |
| [Evaluating Financial Sentiment in the Age of AI](papers/arXiv-2609.20198-Evaluating-Financial-Sentiment-in-the-Age-of-AI.pdf) | [2609.20198](https://arxiv.org/abs/2609.20198) | CC BY 4.0 |

### Fine-tuning (parameter-efficient)

| Paper | arXiv | Licence |
|---|---|---|
| [NoRA: Nested Low-Rank Adaptation for Efficient Fine-Tuning Large Models](papers/arXiv-2408.10280-NoRA-Nested-Low-Rank-Adaptation-for-Efficient-Fine-Tuning-Large-Models.pdf) | [2408.10280](https://arxiv.org/abs/2408.10280) | CC BY-SA 4.0 |
| [Prompt Compression for Large Language Models: A Survey](papers/arXiv-2410.12388-Prompt-Compression-for-Large-Language-Models-A-Survey.pdf) | [2410.12388](https://arxiv.org/abs/2410.12388) | CC BY 4.0 |
| [Variational Low-Rank Adaptation Using IVON](papers/arXiv-2411.04421-Variational-Low-Rank-Adaptation-Using-IVON.pdf) | [2411.04421](https://arxiv.org/abs/2411.04421) | CC BY 4.0 |
| [Parameter-Efficient Fine-Tuning for Foundation Models](papers/arXiv-2501.13787-Parameter-Efficient-Fine-Tuning-for-Foundation-Models.pdf) | [2501.13787](https://arxiv.org/abs/2501.13787) | CC BY 4.0 |
| [Parameter-Efficient Continual Fine-Tuning: A Survey](papers/arXiv-2504.13822-Parameter-Efficient-Continual-Fine-Tuning-A-Survey.pdf) | [2504.13822](https://arxiv.org/abs/2504.13822) | CC BY 4.0 |
| [PEFT A2Z: Parameter-Efficient Fine-Tuning Survey for Large Language and Vision Models](papers/arXiv-2504.14117-PEFT-A2Z-Parameter-Efficient-Fine-Tuning-Survey-for-Large-Language-and-V.pdf) | [2504.14117](https://arxiv.org/abs/2504.14117) | CC BY 4.0 |
| [A Survey on Parameter-Efficient Fine-Tuning for Foundation Models in Federated Learning](papers/arXiv-2504.21099-A-Survey-on-Parameter-Efficient-Fine-Tuning-for-Foundation-Models-in-Fed.pdf) | [2504.21099](https://arxiv.org/abs/2504.21099) | CC BY 4.0 |
| [RefLoRA: Refactored Low-Rank Adaptation for Efficient Fine-Tuning of Large Models](papers/arXiv-2505.18877-RefLoRA-Refactored-Low-Rank-Adaptation-for-Efficient-Fine-Tuning-of-Larg.pdf) | [2505.18877](https://arxiv.org/abs/2505.18877) | CC BY 4.0 |
| [LLMs for energy and macronutrients estimation using only text data from 24-hour dietary recalls: a parameter-efficient fine-tuning experiment using a 10-shot prompt](papers/arXiv-2509.13268-LLMs-for-energy-and-macronutrients-estimation-using-only-text-data-from.pdf) | [2509.13268](https://arxiv.org/abs/2509.13268) | CC BY 4.0 |
| [How Can Quantum Deep Learning Improve Large Language Models?](papers/arXiv-2509.16244-How-Can-Quantum-Deep-Learning-Improve-Large-Language-Models.pdf) | [2509.16244](https://arxiv.org/abs/2509.16244) | CC BY 4.0 |
| [Evolution of meta&#39;s llama models and parameter-efficient fine-tuning of large language models: a survey](papers/arXiv-2510.12178-Evolution-of-meta39s-llama-models-and-parameter-efficient-fine-tuning-of.pdf) | [2510.12178](https://arxiv.org/abs/2510.12178) | CC BY 4.0 |
| [Less is More: Resource-Efficient Low-Rank Adaptation](papers/arXiv-2512.00878-Less-is-More-Resource-Efficient-Low-Rank-Adaptation.pdf) | [2512.00878](https://arxiv.org/abs/2512.00878) | CC BY 4.0 |
| [Hybrid-LoRA: Bridging Full Fine-Tuning and Low-Rank Adaptation for Post-Training](papers/arXiv-2605.18822-Hybrid-LoRA-Bridging-Full-Fine-Tuning-and-Low-Rank-Adaptation-for-Post-T.pdf) | [2605.18822](https://arxiv.org/abs/2605.18822) | CC BY 4.0 |
| [Geometry-Preserving Orthonormal Initialization for Low-Rank Adaptation in RLVR](papers/arXiv-2606.31813-Geometry-Preserving-Orthonormal-Initialization-for-Low-Rank-Adaptation-i.pdf) | [2606.31813](https://arxiv.org/abs/2606.31813) | CC BY 4.0 |
| [Efficient Task Adaptation in Large Language Models: A Survey of Weight-Based, Prompt-Based, and Embedding-Based Adaptations](papers/arXiv-2610.00928-Efficient-Task-Adaptation-in-Large-Language-Models-A-Survey-of-Weight-Ba.pdf) | [2610.00928](https://arxiv.org/abs/2610.00928) | CC BY 4.0 |

### Guardrails & safety controls

| Paper | arXiv | Licence |
|---|---|---|
| [Deactivating Refusal Triggers: Understanding and Mitigating Overrefusal in Safety Alignment](papers/arXiv-2603.11388-Deactivating-Refusal-Triggers-Understanding-and-Mitigating-Overrefusal-i.pdf) | [2603.11388](https://arxiv.org/abs/2603.11388) | CC BY 4.0 |
| [When Autoregressive Consistency Hurts Safety Alignment](papers/arXiv-2606.04168-When-Autoregressive-Consistency-Hurts-Safety-Alignment.pdf) | [2606.04168](https://arxiv.org/abs/2606.04168) | CC BY 4.0 |

### Healthcare & clinical

| Paper | arXiv | Licence |
|---|---|---|
| [Creating Trustworthy LLMs: Dealing with Hallucinations in Healthcare AI](papers/arXiv-2311.01463-Creating-Trustworthy-LLMs-Dealing-with-Hallucinations-in-Healthcare-AI.pdf) | [2311.01463](https://arxiv.org/abs/2311.01463) | CC BY 4.0 |
| [LLMs-Healthcare : Current Applications and Challenges of Large Language Models in various Medical Specialties](papers/arXiv-2311.12882-LLMs-Healthcare-Current-Applications-and-Challenges-of-Large-Language-Mo.pdf) | [2311.12882](https://arxiv.org/abs/2311.12882) | CC BY 4.0 |
| [Large language models in healthcare and medical domain: A review](papers/arXiv-2401.06775-Large-language-models-in-healthcare-and-medical-domain-A-review.pdf) | [2401.06775](https://arxiv.org/abs/2401.06775) | CC BY 4.0 |
| [A Proposed S.C.O.R.E. Evaluation Framework for Large Language Models : Safety, Consensus, Objectivity, Reproducibility and Explainability](papers/arXiv-2407.07666-A-Proposed-SCORE-Evaluation-Framework-for-Large-Language-Models-Safety-C.pdf) | [2407.07666](https://arxiv.org/abs/2407.07666) | CC0 1.0 |
| [RiskAgent: Synergizing Language Models with Validated Tools for Evidence-Based Risk Prediction](papers/arXiv-2503.03802-RiskAgent-Synergizing-Language-Models-with-Validated-Tools-for-Evidence.pdf) | [2503.03802](https://arxiv.org/abs/2503.03802) | CC BY 4.0 |
| [Beyond MedQA: Towards Real-world Clinical Decision Making in the Era of LLMs](papers/arXiv-2510.20001-Beyond-MedQA-Towards-Real-world-Clinical-Decision-Making-in-the-Era-of-L.pdf) | [2510.20001](https://arxiv.org/abs/2510.20001) | CC BY 4.0 |
| [MediRec: Enhancing Chinese Medication Recommendation with Explainable Clinical Reasoning](papers/arXiv-2510.21084-MediRec-Enhancing-Chinese-Medication-Recommendation-with-Explainable-Cli.pdf) | [2510.21084](https://arxiv.org/abs/2510.21084) | CC BY 4.0 |
| [DIASENTINEL: An Auditable Multi-Agent System for Guideline-Grounded Diabetes Risk Screening](papers/arXiv-2608.31128-DIASENTINEL-An-Auditable-Multi-Agent-System-for-Guideline-Grounded-Diabe.pdf) | [2608.31128](https://arxiv.org/abs/2608.31128) | CC BY 4.0 |

### Industrial applications

| Paper | arXiv | Licence |
|---|---|---|
| [FATE-LLM: A Industrial Grade Federated Learning Framework for Large Language Models](papers/arXiv-2310.10049-FATE-LLM-A-Industrial-Grade-Federated-Learning-Framework-for-Large-Langu.pdf) | [2310.10049](https://arxiv.org/abs/2310.10049) | CC BY 4.0 |
| [Software Model Evolution with Large Language Models: Experiments on Simulated, Public, and Industrial Datasets](papers/arXiv-2406.17651-Software-Model-Evolution-with-Large-Language-Models-Experiments-on-Simul.pdf) | [2406.17651](https://arxiv.org/abs/2406.17651) | CC BY 4.0 |
| [BMW Agents -- A Framework For Task Automation Through Multi-Agent Collaboration](papers/arXiv-2406.20041-BMW-Agents-A-Framework-For-Task-Automation-Through-Multi-Agent-Collabora.pdf) | [2406.20041](https://arxiv.org/abs/2406.20041) | CC BY 4.0 |
| [AAD-LLM: Adaptive Anomaly Detection Using Large Language Models](papers/arXiv-2411.00914-AAD-LLM-Adaptive-Anomaly-Detection-Using-Large-Language-Models.pdf) | [2411.00914](https://arxiv.org/abs/2411.00914) | CC BY 4.0 |
| [Applying Large Language Models in Knowledge Graph-based Enterprise Modeling: Challenges and Opportunities](papers/arXiv-2501.03566-Applying-Large-Language-Models-in-Knowledge-Graph-based-Enterprise-Model.pdf) | [2501.03566](https://arxiv.org/abs/2501.03566) | CC BY 4.0 |
| [REALM: A Dataset of Real-World LLM Use Cases](papers/arXiv-2503.18792-REALM-A-Dataset-of-Real-World-LLM-Use-Cases.pdf) | [2503.18792](https://arxiv.org/abs/2503.18792) | CC BY 4.0 |
| [Accelerating the drive towards energy-efficient generative AI with quantum computing algorithms](papers/arXiv-2508.20720-Accelerating-the-drive-towards-energy-efficient-generative-AI-with-quant.pdf) | [2508.20720](https://arxiv.org/abs/2508.20720) | CC BY-SA 4.0 |
| [Pursuing Best Industrial Practices for Retrieval-Augmented Generation in the Medical Domain](papers/arXiv-2602.03368-Pursuing-Best-Industrial-Practices-for-Retrieval-Augmented-Generation-in.pdf) | [2602.03368](https://arxiv.org/abs/2602.03368) | CC BY 4.0 |

### Legal

| Paper | arXiv | Licence |
|---|---|---|
| [Large Language Models are legal but they are not: Making the case for a powerful LegalLLM](papers/arXiv-2311.08890-Large-Language-Models-are-legal-but-they-are-not-Making-the-case-for-a-p.pdf) | [2311.08890](https://arxiv.org/abs/2311.08890) | CC BY 4.0 |
| [Evaluation Ethics of LLMs in Legal Domain](papers/arXiv-2403.11152-Evaluation-Ethics-of-LLMs-in-Legal-Domain.pdf) | [2403.11152](https://arxiv.org/abs/2403.11152) | CC BY 4.0 |
| [Large Language Models Meet Legal Artificial Intelligence: A Survey](papers/arXiv-2509.09969-Large-Language-Models-Meet-Legal-Artificial-Intelligence-A-Survey.pdf) | [2509.09969](https://arxiv.org/abs/2509.09969) | CC BY 4.0 |
| [Data Augmented Pipeline for Legal Information Extraction and Reasoning](papers/arXiv-2601.05609-Data-Augmented-Pipeline-for-Legal-Information-Extraction-and-Reasoning.pdf) | [2601.05609](https://arxiv.org/abs/2601.05609) | CC BY 4.0 |
| [Supporting Humans in Evaluating AI Summaries of Legal Depositions](papers/arXiv-2601.15182-Supporting-Humans-in-Evaluating-AI-Summaries-of-Legal-Depositions.pdf) | [2601.15182](https://arxiv.org/abs/2601.15182) | CC BY-SA 4.0 |
| [LegalMidm: Use-Case-Driven Legal Domain Specialization for Korean Large Language Model](papers/arXiv-2604.25297-LegalMidm-Use-Case-Driven-Legal-Domain-Specialization-for-Korean-Large-L.pdf) | [2604.25297](https://arxiv.org/abs/2604.25297) | CC BY 4.0 |
| [Investigating Multi-Agent Deliberation in Law](papers/arXiv-2606.30906-Investigating-Multi-Agent-Deliberation-in-Law.pdf) | [2606.30906](https://arxiv.org/abs/2606.30906) | CC BY 4.0 |

### Manufacturing

| Paper | arXiv | Licence |
|---|---|---|
| [Large Language Model-Enabled Multi-Agent Manufacturing Systems](papers/arXiv-2406.01893-Large-Language-Model-Enabled-Multi-Agent-Manufacturing-Systems.pdf) | [2406.01893](https://arxiv.org/abs/2406.01893) | CC BY 4.0 |
| [Enhancing Human-Robot Collaborative Assembly in Manufacturing Systems Using Large Language Models](papers/arXiv-2406.01915-Enhancing-Human-Robot-Collaborative-Assembly-in-Manufacturing-Systems-Us.pdf) | [2406.01915](https://arxiv.org/abs/2406.01915) | CC BY 4.0 |
| [Entity Linking using LLMs for Automated Product Carbon Footprint Estimation](papers/arXiv-2502.07418-Entity-Linking-using-LLMs-for-Automated-Product-Carbon-Footprint-Estimat.pdf) | [2502.07418](https://arxiv.org/abs/2502.07418) | CC BY 4.0 |
| [Dynamic Task Adaptation for Multi-Robot Manufacturing Systems with Large Language Models](papers/arXiv-2505.22804-Dynamic-Task-Adaptation-for-Multi-Robot-Manufacturing-Systems-with-Large.pdf) | [2505.22804](https://arxiv.org/abs/2505.22804) | CC BY 4.0 |
| [Domain Adapted Large Language Models for Additive Manufacturing](papers/arXiv-2603.22017-Domain-Adapted-Large-Language-Models-for-Additive-Manufacturing.pdf) | [2603.22017](https://arxiv.org/abs/2603.22017) | CC BY 4.0 |
| [Logic-Based Verification of Task Allocation for LLM-Enabled Multi-Agent Manufacturing Systems](papers/arXiv-2604.17142-Logic-Based-Verification-of-Task-Allocation-for-LLM-Enabled-Multi-Agent.pdf) | [2604.17142](https://arxiv.org/abs/2604.17142) | CC BY 4.0 |

### Open-source & self-hosted models

| Paper | arXiv | Licence |
|---|---|---|
| [Comparative Analysis of Named Entity Recognition in the Dungeons and Dragons Domain](papers/arXiv-2309.17171-Comparative-Analysis-of-Named-Entity-Recognition-in-the-Dungeons-and-Dra.pdf) | [2309.17171](https://arxiv.org/abs/2309.17171) | CC BY 4.0 |

### Privacy

| Paper | arXiv | Licence |
|---|---|---|
| [Privacy Issues in Large Language Models: A Survey](papers/arXiv-2312.06717-Privacy-Issues-in-Large-Language-Models-A-Survey.pdf) | [2312.06717](https://arxiv.org/abs/2312.06717) | CC BY 4.0 |
| [Text-Based Personas for Simulating User Privacy Decisions](papers/arXiv-2603.19791-Text-Based-Personas-for-Simulating-User-Privacy-Decisions.pdf) | [2603.19791](https://arxiv.org/abs/2603.19791) | CC BY 4.0 |
| [LLM-Based Schema-Aware Split Learning for Privacy-Preserving Mental Distress Prediction Across Heterogeneous Surveys](papers/arXiv-2609.15871-LLM-Based-Schema-Aware-Split-Learning-for-Privacy-Preserving-Mental-Dist.pdf) | [2609.15871](https://arxiv.org/abs/2609.15871) | CC BY 4.0 |

### Prompting

| Paper | arXiv | Licence |
|---|---|---|
| [A Systematic Survey of Prompt Engineering in Large Language Models: Techniques and Applications](papers/arXiv-2402.07927-A-Systematic-Survey-of-Prompt-Engineering-in-Large-Language-Models-Techn.pdf) | [2402.07927](https://arxiv.org/abs/2402.07927) | CC BY 4.0 |
| [The Prompt Report: A Systematic Survey of Prompt Engineering Techniques](papers/arXiv-2406.06608-The-Prompt-Report-A-Systematic-Survey-of-Prompt-Engineering-Techniques.pdf) | [2406.06608](https://arxiv.org/abs/2406.06608) | CC BY 4.0 |
| [A Survey of Automatic Prompt Engineering: An Optimization Perspective](papers/arXiv-2502.11560-A-Survey-of-Automatic-Prompt-Engineering-An-Optimization-Perspective.pdf) | [2502.11560](https://arxiv.org/abs/2502.11560) | CC BY 4.0 |
| [Prompt Engineering for Responsible Generative AI Use in African Education: A Report from a Three-Day Training Series](papers/arXiv-2601.06121-Prompt-Engineering-for-Responsible-Generative-AI-Use-in-African-Educatio.pdf) | [2601.06121](https://arxiv.org/abs/2601.06121) | CC BY 4.0 |
| [From Instruction to Output: The Role of Prompting in Modern NLG](papers/arXiv-2602.11179-From-Instruction-to-Output-The-Role-of-Prompting-in-Modern-NLG.pdf) | [2602.11179](https://arxiv.org/abs/2602.11179) | CC BY 4.0 |

### Quantization & low-bit inference

| Paper | arXiv | Licence |
|---|---|---|
| [Large Language Models for Time Series: A Survey](papers/arXiv-2402.01801-Large-Language-Models-for-Time-Series-A-Survey.pdf) | [2402.01801](https://arxiv.org/abs/2402.01801) | CC BY 4.0 |
| [Vector Quantization for Recommender Systems: A Review and Outlook](papers/arXiv-2405.03110-Vector-Quantization-for-Recommender-Systems-A-Review-and-Outlook.pdf) | [2405.03110](https://arxiv.org/abs/2405.03110) | CC BY 4.0 |
| [A Survey of Low-bit Large Language Models: Basics, Systems, and Algorithms](papers/arXiv-2409.16694-A-Survey-of-Low-bit-Large-Language-Models-Basics-Systems-and-Algorithms.pdf) | [2409.16694](https://arxiv.org/abs/2409.16694) | CC BY 4.0 |
| [Vision-Language Models for Edge Networks: A Comprehensive Survey](papers/arXiv-2502.07855-Vision-Language-Models-for-Edge-Networks-A-Comprehensive-Survey.pdf) | [2502.07855](https://arxiv.org/abs/2502.07855) | CC BY 4.0 |
| [Large Language Models in the Loop: A Stability- and Network-Aware Survey in Networked Control, Cyber-Physical, and Multi-Agent Systems](papers/arXiv-2609.16599-Large-Language-Models-in-the-Loop-A-Stability-and-Network-Aware-Survey-i.pdf) | [2609.16599](https://arxiv.org/abs/2609.16599) | CC BY 4.0 |

### Retrieval-augmented generation

| Paper | arXiv | Licence |
|---|---|---|
| [A Survey of Graph Retrieval-Augmented Generation for Customized Large Language Models](papers/arXiv-2501.13958-A-Survey-of-Graph-Retrieval-Augmented-Generation-for-Customized-Large-La.pdf) | [2501.13958](https://arxiv.org/abs/2501.13958) | CC BY 4.0 |
| [A Survey of Multimodal Retrieval-Augmented Generation](papers/arXiv-2504.08748-A-Survey-of-Multimodal-Retrieval-Augmented-Generation.pdf) | [2504.08748](https://arxiv.org/abs/2504.08748) | CC BY 4.0 |
| [Graph-based Approaches and Functionalities in Retrieval-Augmented Generation: A Comprehensive Survey](papers/arXiv-2504.10499-Graph-based-Approaches-and-Functionalities-in-Retrieval-Augmented-Genera.pdf) | [2504.10499](https://arxiv.org/abs/2504.10499) | CC BY 4.0 |
| [Retrieval-Augmented Generation in Biomedicine: A Survey of Technologies, Datasets, and Clinical Applications](papers/arXiv-2505.01146-Retrieval-Augmented-Generation-in-Biomedicine-A-Survey-of-Technologies-D.pdf) | [2505.01146](https://arxiv.org/abs/2505.01146) | CC BY 4.0 |
| [A survey: Information search time optimization based on RAG (Retrieval Augmentation Generation) chatbot](papers/arXiv-2601.07838-A-survey-Information-search-time-optimization-based-on-RAG-Retrieval-Aug.pdf) | [2601.07838](https://arxiv.org/abs/2601.07838) | CC BY 4.0 |

### Robotics & embodied agents

| Paper | arXiv | Licence |
|---|---|---|
| [Can Large Language Models design a Robot?](papers/arXiv-2303.15324-Can-Large-Language-Models-design-a-Robot.pdf) | [2303.15324](https://arxiv.org/abs/2303.15324) | CC BY 4.0 |
| [Statler: State-Maintaining Language Models for Embodied Reasoning](papers/arXiv-2306.17840-Statler-State-Maintaining-Language-Models-for-Embodied-Reasoning.pdf) | [2306.17840](https://arxiv.org/abs/2306.17840) | CC BY 4.0 |
| [Robots with Attitudes: Influence of LLM-Driven Robot Personalities on Motivation and Performance](papers/arXiv-2512.06910-Robots-with-Attitudes-Influence-of-LLM-Driven-Robot-Personalities-on-Mot.pdf) | [2512.06910](https://arxiv.org/abs/2512.06910) | CC BY 4.0 |

### Scientific research

| Paper | arXiv | Licence |
|---|---|---|
| [Detecting Reference Errors in Scientific Literature with Large Language Models](papers/arXiv-2411.06101-Detecting-Reference-Errors-in-Scientific-Literature-with-Large-Language.pdf) | [2411.06101](https://arxiv.org/abs/2411.06101) | CC BY 4.0 |
| [AI-Reporter: A Path to a New Genre of Scientific Communication](papers/arXiv-2507.05903-AI-Reporter-A-Path-to-a-New-Genre-of-Scientific-Communication.pdf) | [2507.05903](https://arxiv.org/abs/2507.05903) | CC BY 4.0 |
| [Agentic research is oxymoronic](papers/arXiv-2608.31161-Agentic-research-is-oxymoronic.pdf) | [2608.31161](https://arxiv.org/abs/2608.31161) | CC BY 4.0 |

### Security

| Paper | arXiv | Licence |
|---|---|---|
| [SECURE: Benchmarking Large Language Models for Cybersecurity](papers/arXiv-2405.20441-SECURE-Benchmarking-Large-Language-Models-for-Cybersecurity.pdf) | [2405.20441](https://arxiv.org/abs/2405.20441) | CC BY 4.0 |
| [Psychological Profiling in Cybersecurity: A Look at LLMs and Psycholinguistic Features](papers/arXiv-2406.18783-Psychological-Profiling-in-Cybersecurity-A-Look-at-LLMs-and-Psycholingui.pdf) | [2406.18783](https://arxiv.org/abs/2406.18783) | CC BY 4.0 |
| [CVE-LLM : Ontology-Assisted Automatic Vulnerability Evaluation Using Large Language Models](papers/arXiv-2502.15932-CVE-LLM-Ontology-Assisted-Automatic-Vulnerability-Evaluation-Using-Large.pdf) | [2502.15932](https://arxiv.org/abs/2502.15932) | CC BY-SA 4.0 |
| [Investigating cybersecurity incidents using large language models in latest-generation wireless networks](papers/arXiv-2504.13196-Investigating-cybersecurity-incidents-using-large-language-models-in-lat.pdf) | [2504.13196](https://arxiv.org/abs/2504.13196) | CC BY 4.0 |
| [Llama-3.1-FoundationAI-SecurityLLM-Base-8B Technical Report](papers/arXiv-2504.21039-Llama-31-FoundationAI-SecurityLLM-Base-8B-Technical-Report.pdf) | [2504.21039](https://arxiv.org/abs/2504.21039) | CC BY 4.0 |

### Small language models

| Paper | arXiv | Licence |
|---|---|---|
| [Small Language Models: Survey, Measurements, and Insights](papers/arXiv-2409.15790-Small-Language-Models-Survey-Measurements-and-Insights.pdf) | [2409.15790](https://arxiv.org/abs/2409.15790) | CC BY 4.0 |
| [A Survey of Small Language Models](papers/arXiv-2410.20011-A-Survey-of-Small-Language-Models.pdf) | [2410.20011](https://arxiv.org/abs/2410.20011) | CC BY 4.0 |
| [Stop Overthinking: A Survey on Efficient Reasoning for Large Language Models](papers/arXiv-2503.16419-Stop-Overthinking-A-Survey-on-Efficient-Reasoning-for-Large-Language-Mod.pdf) | [2503.16419](https://arxiv.org/abs/2503.16419) | CC BY 4.0 |
| [A Survey on Collaborative Mechanisms Between Large and Small Language Models](papers/arXiv-2505.07460-A-Survey-on-Collaborative-Mechanisms-Between-Large-and-Small-Language-Mo.pdf) | [2505.07460](https://arxiv.org/abs/2505.07460) | CC BY 4.0 |
| [Towards a Small Language Model Lifecycle Framework](papers/arXiv-2506.07695-Towards-a-Small-Language-Model-Lifecycle-Framework.pdf) | [2506.07695](https://arxiv.org/abs/2506.07695) | CC BY 4.0 |
| [Polypersona: Persona-Grounded LLM for Synthetic Survey Responses](papers/arXiv-2512.14562-Polypersona-Persona-Grounded-LLM-for-Synthetic-Survey-Responses.pdf) | [2512.14562](https://arxiv.org/abs/2512.14562) | CC BY 4.0 |
| [The Unsampled Truth: Quantifying Prompt Artifacts in LM Psychometrics](papers/arXiv-2606.03357-The-Unsampled-Truth-Quantifying-Prompt-Artifacts-in-LM-Psychometrics.pdf) | [2606.03357](https://arxiv.org/abs/2606.03357) | CC BY 4.0 |
| [Small Language Models for Smart Data Model Classification at the Edge: A Cost-Aware Hybrid Approach](papers/arXiv-2610.07093-Small-Language-Models-for-Smart-Data-Model-Classification-at-the-Edge-A.pdf) | [2610.07093](https://arxiv.org/abs/2610.07093) | CC BY 4.0 |

### Software engineering

| Paper | arXiv | Licence |
|---|---|---|
| [Towards Automatic Support of Software Model Evolution with Large Language~Models](papers/arXiv-2312.12404-Towards-Automatic-Support-of-Software-Model-Evolution-with-Large-Languag.pdf) | [2312.12404](https://arxiv.org/abs/2312.12404) | CC BY-SA 4.0 |
| [Efficient and Green Large Language Models for Software Engineering: Literature Review, Vision, and the Road Ahead](papers/arXiv-2404.04566-Efficient-and-Green-Large-Language-Models-for-Software-Engineering-Liter.pdf) | [2404.04566](https://arxiv.org/abs/2404.04566) | CC BY 4.0 |
| [Will AI replace Software Engineers? Do not hold your breath](papers/arXiv-2502.20429-Will-AI-replace-Software-Engineers-Do-not-hold-your-breath.pdf) | [2502.20429](https://arxiv.org/abs/2502.20429) | CC BY 4.0 |

### Telecommunications

| Paper | arXiv | Licence |
|---|---|---|
| [Ubiquitous Intelligence Via Wireless Network-Driven LLMs Evolution](papers/arXiv-2509.08400-Ubiquitous-Intelligence-Via-Wireless-Network-Driven-LLMs-Evolution.pdf) | [2509.08400](https://arxiv.org/abs/2509.08400) | CC BY 4.0 |

---

## Licensing

### How this was filtered

arXiv's **default licence** (`nonexclusive-distrib/1.0`) grants arXiv the right to
distribute a paper. It grants *third parties* no redistribution right at all, so a
paper under it **cannot lawfully be mirrored here** â regardless of being free to
read on arXiv. Bulk-downloading arXiv PDFs into a repository is a licence breach
for a large fraction of them.

Each candidate's licence was therefore read from arXiv's OAI-PMH metadata before
download:

```
http://export.arxiv.org/oai2?verb=GetRecord&identifier=oai:arXiv.org:<id>&metadataPrefix=arXiv
```

### What was found

| Licence | Papers | Mirrored here |
|---|---|---|
| CC BY 4.0 | 107 | Yes |
| arXiv non-exclusive | 90 | No |
| CC BY-NC-ND 4.0 | 18 | No |
| CC BY-NC-SA 4.0 | 15 | No |
| CC BY-SA 4.0 | 7 | Yes |
| CC0 1.0 | 1 | Yes |

**238 candidates screened, 115 mirrored.**

### Excluded: no redistribution right

123 screened papers are under arXiv's default licence or record no licence.
Links only.

| Paper | arXiv |
|---|---|
| Robosourcing Educational Resources -- Leveraging Large Language Models for Learnersourcing | [2211.04715](https://arxiv.org/abs/2211.04715) |
| ChatGPT Prompt Patterns for Improving Code Quality, Refactoring, Requirements Elicitation, and Software Design | [2303.07839](https://arxiv.org/abs/2303.07839) |
| Emergent autonomous scientific research capabilities of large language models | [2304.05332](https://arxiv.org/abs/2304.05332) |
| Prompt Engineering for Healthcare: Methodologies and Applications | [2304.14670](https://arxiv.org/abs/2304.14670) |
| Panda LLM: Training Data and Evaluation for Open-Sourced Chinese Instruction-Following Large Language Models | [2305.03025](https://arxiv.org/abs/2305.03025) |
| Simulating H.P. Lovecraft horror literature with the ChatGPT large language model | [2305.03429](https://arxiv.org/abs/2305.03429) |
| FinGPT: Open-Source Financial Large Language Models | [2306.06031](https://arxiv.org/abs/2306.06031) |
| A Systematic Survey of Prompt Engineering on Vision-Language Foundation Models | [2307.12980](https://arxiv.org/abs/2307.12980) |
| A Survey on Model Compression for Large Language Models | [2308.07633](https://arxiv.org/abs/2308.07633) |
| Emerging Frontiers: Exploring the Impact of Generative AI Platforms on University Quantitative Finance Examinations | [2308.07979](https://arxiv.org/abs/2308.07979) |
| Large Language Models for Scientific Synthesis, Inference and Explanation | [2310.07984](https://arxiv.org/abs/2310.07984) |
| Watermarking LLMs with Weight Quantization | [2310.11237](https://arxiv.org/abs/2310.11237) |
| pFedLoRA: Model-Heterogeneous Personalized Federated Learning with LoRA Tuning | [2310.13283](https://arxiv.org/abs/2310.13283) |
| MedEval: A Multi-Level, Multi-Task, and Multi-Domain Medical Benchmark for Language Model Evaluation | [2310.14088](https://arxiv.org/abs/2310.14088) |
| The Expressive Power of Low-Rank Adaptation | [2310.17513](https://arxiv.org/abs/2310.17513) |
| EHRTutor: Enhancing Patient Understanding of Discharge Instructions | [2310.19212](https://arxiv.org/abs/2310.19212) |
| White Paper: The Generative Education (GenEd) Framework | [2311.10732](https://arxiv.org/abs/2311.10732) |
| Parameter-Efficient Fine-Tuning Methods for Pretrained Language Models: A Critical Review and Assessment | [2312.12148](https://arxiv.org/abs/2312.12148) |
| Differentially Private Low-Rank Adaptation of Large Language Model Using Federated Learning | [2312.17493](https://arxiv.org/abs/2312.17493) |
| A Comprehensive Survey of Compression Algorithms for Language Models | [2401.15347](https://arxiv.org/abs/2401.15347) |
| ChatGPT vs Gemini vs LLaMA on Multilingual Sentiment Analysis | [2402.01715](https://arxiv.org/abs/2402.01715) |
| Parameter-Efficient Fine-Tuning for Pre-Trained Vision Models: A Survey and Benchmark | [2402.02242](https://arxiv.org/abs/2402.02242) |
| LLMs for Coding and Robotics Education | [2402.06116](https://arxiv.org/abs/2402.06116) |
| QDyLoRA: Quantized Dynamic Low-Rank Adaptation for Efficient Large Language Model Tuning | [2402.10462](https://arxiv.org/abs/2402.10462) |
| Evaluating Biases in Context-Dependent Health Questions | [2403.04858](https://arxiv.org/abs/2403.04858) |
| GPT-4V(ision) Unsuitable for Clinical Care and Education: A Clinician-Evaluated Assessment | [2403.12046](https://arxiv.org/abs/2403.12046) |
| Towards a Wireless Physical-Layer Foundation Model: Challenges and Strategies | [2403.12065](https://arxiv.org/abs/2403.12065) |
| Facilitating Pornographic Text Detection for Open-Domain Dialogue Systems via Knowledge Distillation of Large Language Models | [2403.13250](https://arxiv.org/abs/2403.13250) |
| Dimensionality-Reduction Techniques for Approximate Nearest Neighbor Search: A Survey and Evaluation | [2403.13491](https://arxiv.org/abs/2403.13491) |
| Parameter-Efficient Fine-Tuning for Large Models: A Comprehensive Survey | [2403.14608](https://arxiv.org/abs/2403.14608) |
| ALoRA: Allocating Low-Rank Adaptation for Fine-tuning Large Language Models | [2403.16187](https://arxiv.org/abs/2403.16187) |
| Exploring the Nexus of Large Language Models and Legal Systems: A Short Survey | [2404.00990](https://arxiv.org/abs/2404.00990) |
| Modelling Language using Large Language Models | [2404.09579](https://arxiv.org/abs/2404.09579) |
| EnviroExam: Benchmarking Environmental Science Knowledge of Large Language Models | [2405.11265](https://arxiv.org/abs/2405.11265) |
| Uncovering Logit Suppression Vulnerabilities in LLM Safety Alignment | [2405.13068](https://arxiv.org/abs/2405.13068) |
| A Survey of Multimodal Large Language Model from A Data-centric Perspective | [2405.16640](https://arxiv.org/abs/2405.16640) |
| ChatSR: Multimodal Large Language Models for Scientific Formula Discovery | [2406.05410](https://arxiv.org/abs/2406.05410) |
| Safety Alignment Should Be Made More Than Just a Few Tokens Deep | [2406.05946](https://arxiv.org/abs/2406.05946) |
| Promoting Data and Model Privacy in Federated Learning through Quantized LoRA | [2406.10976](https://arxiv.org/abs/2406.10976) |
| Achieving Tool Calling Functionality in LLMs Using Only Prompt Engineering Without Fine-Tuning | [2407.04997](https://arxiv.org/abs/2407.04997) |
| CLIMB: A Benchmark of Clinical Bias in Large Language Models | [2407.05250](https://arxiv.org/abs/2407.05250) |
| A Survey of Prompt Engineering Methods in Large Language Models for Different NLP Tasks | [2407.12994](https://arxiv.org/abs/2407.12994) |
| The Emerged Security and Privacy of LLM Agent: A Survey with Case Studies | [2407.19354](https://arxiv.org/abs/2407.19354) |
| DeliLaw: A Chinese Legal Counselling System Based on a Large Language Model | [2408.00357](https://arxiv.org/abs/2408.00357) |
| Preserving Privacy in Large Language Models: A Survey on Current Threats and Solutions | [2408.05212](https://arxiv.org/abs/2408.05212) |
| Graph Retrieval-Augmented Generation: A Survey | [2408.08921](https://arxiv.org/abs/2408.08921) |
| Speaking the Same Language: Leveraging LLMs in Standardizing Clinical Data for AI | [2408.11861](https://arxiv.org/abs/2408.11861) |
| Debugging with Open-Source Large Language Models: An Evaluation | [2409.03031](https://arxiv.org/abs/2409.03031) |
| WirelessAgent: Large Language Model Agents for Intelligent Wireless Networks | [2409.07964](https://arxiv.org/abs/2409.07964) |
| Cracking the Code: Multi-domain LLM Evaluation on Real-World Professional Exams in Indonesia | [2409.08564](https://arxiv.org/abs/2409.08564) |
| LLMR: Knowledge Distillation with a Large Language Model-Induced Reward | [2409.12500](https://arxiv.org/abs/2409.12500) |
| A Comprehensive Survey of Retrieval-Augmented Generation (RAG): Evolution, Current Landscape and Future Directions | [2410.12837](https://arxiv.org/abs/2410.12837) |
| Adanonymizer: Interactively Navigating and Balancing the Duality of Privacy and Output Performance in Human-LLM Interaction | [2410.15044](https://arxiv.org/abs/2410.15044) |
| A Comprehensive Survey of Small Language Models in the Era of Large Language Models: Techniques, Enhancements, Applications, Collaboration with LLMs, and Trustworthiness | [2411.03350](https://arxiv.org/abs/2411.03350) |
| GUI Agents with Foundation Models: A Comprehensive Survey | [2411.04890](https://arxiv.org/abs/2411.04890) |
| LLM-NEO: Parameter Efficient Knowledge Distillation for Large Language Models | [2411.06839](https://arxiv.org/abs/2411.06839) |
| Towards Evaluation Guidelines for Empirical Studies involving LLMs | [2411.07668](https://arxiv.org/abs/2411.07668) |
| FASTNav: Fine-tuned Adaptive Small-language-models Trained for Multi-point Robot Navigation | [2411.13262](https://arxiv.org/abs/2411.13262) |
| Personalized Multimodal Large Language Models: A Survey | [2412.02142](https://arxiv.org/abs/2412.02142) |
| Privacy-Preserving Large Language Models: Mechanisms, Applications, and Future Directions | [2412.06113](https://arxiv.org/abs/2412.06113) |
| Sequential Compression Layers for Efficient Federated Learning in Foundational Models | [2412.07021](https://arxiv.org/abs/2412.07021) |
| Baichuan4-Finance Technical Report | [2412.15270](https://arxiv.org/abs/2412.15270) |
| Privacy in Fine-tuning Large Language Models: Attacks, Defenses, and Future Directions | [2412.16504](https://arxiv.org/abs/2412.16504) |
| Retrieval-Augmented Generation with Graphs (GraphRAG) | [2501.00309](https://arxiv.org/abs/2501.00309) |
| Low-Rank Adaptation for Foundation Models: A Comprehensive Review | [2501.00365](https://arxiv.org/abs/2501.00365) |
| Small Language Models (SLMs) Can Still Pack a Punch: A survey (updated 2026) | [2501.05465](https://arxiv.org/abs/2501.05465) |
| Agentic Retrieval-Augmented Generation: A Survey on Agentic RAG | [2501.09136](https://arxiv.org/abs/2501.09136) |
| PIKE-RAG: sPecIalized KnowledgE and Rationale Augmented Generation | [2501.11551](https://arxiv.org/abs/2501.11551) |
| MME-Industry: A Cross-Industry Multimodal Evaluation Benchmark | [2501.16688](https://arxiv.org/abs/2501.16688) |
| A Survey of Quantized Graph Representation Learning: Connecting Graph Structures with Large Language Models | [2502.00681](https://arxiv.org/abs/2502.00681) |
| Ask in Any Modality: A Comprehensive Survey on Multimodal Retrieval-Augmented Generation | [2502.08826](https://arxiv.org/abs/2502.08826) |
| One-shot Federated Learning Methods: A Practical Guide | [2502.09104](https://arxiv.org/abs/2502.09104) |
| A Survey on LLM-based News Recommender Systems | [2502.09797](https://arxiv.org/abs/2502.09797) |
| Why Safeguarded Ships Run Aground? Aligned Large Language Models&#39; Safety Mechanisms Tend to Be Anchored in The Template Region | [2502.13946](https://arxiv.org/abs/2502.13946) |
| A Systematic Survey of Automatic Prompt Optimization Techniques | [2502.16923](https://arxiv.org/abs/2502.16923) |
| LexRAG: Benchmarking Retrieval-Augmented Generation in Multi-Turn Legal Consultation Conversation | [2502.20640](https://arxiv.org/abs/2502.20640) |
| DeepSeek-Inspired Exploration of RL-based LLMs and Synergy with Wireless Networks: A Survey | [2503.09956](https://arxiv.org/abs/2503.09956) |
| A Survey on Knowledge-Oriented Retrieval-Augmented Generation | [2503.10677](https://arxiv.org/abs/2503.10677) |
| RaSA: Rank-Sharing Low-Rank Adaptation | [2503.12576](https://arxiv.org/abs/2503.12576) |
| Efficient Inference for Large Reasoning Models: A Survey | [2503.23077](https://arxiv.org/abs/2503.23077) |
| The Rise of Small Language Models in Healthcare: A Comprehensive Survey | [2504.17119](https://arxiv.org/abs/2504.17119) |
| A Survey on Privacy Risks and Protection in Large Language Models | [2505.01976](https://arxiv.org/abs/2505.01976) |
| Federated Large Language Models: Feasibility, Robustness, Security and Future Directions | [2505.08830](https://arxiv.org/abs/2505.08830) |
| Advancing the Scientific Method with Large Language Models: From Hypothesis to Discovery | [2505.16477](https://arxiv.org/abs/2505.16477) |
| MPO: Multilingual Safety Alignment via Reward Gap Optimization | [2505.16869](https://arxiv.org/abs/2505.16869) |
| Simulating Macroeconomic Expectations in Survey Experiments with LLM-based Economic Agents | [2505.17648](https://arxiv.org/abs/2505.17648) |
| Be.FM: Open Foundation Models for Human Behavior | [2505.23058](https://arxiv.org/abs/2505.23058) |
| DenseLoRA: Dense Low-Rank Adaptation of Large Language Models | [2505.23808](https://arxiv.org/abs/2505.23808) |
| Retrieval-Augmented Generation: A Comprehensive Survey of Architectures, Enhancements, and Robustness Frontiers | [2506.00054](https://arxiv.org/abs/2506.00054) |
| Integrating Quantized LLMs into Robotics Systems as Edge AI to Leverage their Natural Language Processing Capabilities | [2506.09581](https://arxiv.org/abs/2506.09581) |
| Large Language Models-Empowered Wireless Networks: Fundamentals, Architecture, and Challenges | [2506.10651](https://arxiv.org/abs/2506.10651) |
| SoK: The Privacy Paradox of Large Language Models: Advancements, Privacy Risks, and Mitigation | [2506.12699](https://arxiv.org/abs/2506.12699) |
| Language Agents for Hypothesis-driven Clinical Decision Making with Reinforcement Learning | [2506.13474](https://arxiv.org/abs/2506.13474) |
| Large Language Model Powered Intelligent Urban Agents: Concepts, Capabilities, and Applications | [2507.00914](https://arxiv.org/abs/2507.00914) |
| AI Agents and Agentic AI-Navigating a Plethora of Concepts for Future Manufacturing | [2507.01376](https://arxiv.org/abs/2507.01376) |
| Prompt Engineering in Segment Anything Model: Methodologies, Applications, and Emerging Challenges | [2507.09562](https://arxiv.org/abs/2507.09562) |
| From Privacy to Trust in the Agentic Era: A Taxonomy of Challenges in Trustworthy Federated Learning Through the Lens of Trust Report 2.0 | [2507.15796](https://arxiv.org/abs/2507.15796) |
| Discrete Tokenization for Multimodal LLMs: A Comprehensive Survey | [2507.22920](https://arxiv.org/abs/2507.22920) |
| Dialogue Systems Engineering: A Survey and Future Directions | [2508.02279](https://arxiv.org/abs/2508.02279) |
| Securing Educational LLMs: A Generalised Taxonomy of Attacks on LLMs and DREAD Risk Assessment | [2508.08629](https://arxiv.org/abs/2508.08629) |
| Survey of Specialized Large Language Model | [2508.19667](https://arxiv.org/abs/2508.19667) |
| Beyond Surface Alignment: Rebuilding LLMs Safety Mechanism via Probabilistically Ablating Refusal Direction | [2509.15202](https://arxiv.org/abs/2509.15202) |
| Coherence-driven inference for cybersecurity | [2509.18520](https://arxiv.org/abs/2509.18520) |
| SocioBench: Modeling Human Behavior in Sociological Surveys with Large Language Models | [2510.11131](https://arxiv.org/abs/2510.11131) |
| A Survey on Collaborating Small and Large Language Models for Performance, Cost-effectiveness, Cloud-edge Privacy, and Trustworthiness | [2510.13890](https://arxiv.org/abs/2510.13890) |
| Efficient Mathematical Reasoning Models via Dynamic Pruning and Knowledge Distillation | [2511.17577](https://arxiv.org/abs/2511.17577) |
| Tutorial on Large Language Model-Enhanced Reinforcement Learning for Wireless Networks | [2512.03722](https://arxiv.org/abs/2512.03722) |
| Augmenting Parameter-Efficient Pre-trained Language Models with Large Language Models | [2602.02501](https://arxiv.org/abs/2602.02501) |
| Large Language Models in Software Documentation and Modeling: A Literature Review and Findings | [2602.04938](https://arxiv.org/abs/2602.04938) |
| Large Language Model (LLM)-enabled Reinforcement Learning for Wireless Network Optimization | [2602.13210](https://arxiv.org/abs/2602.13210) |
| Decoder-based Sense Knowledge Distillation | [2602.22351](https://arxiv.org/abs/2602.22351) |
| GR-SAP: Generative Replay for Safety Alignment Preservation during Fine-Tuning | [2603.10243](https://arxiv.org/abs/2603.10243) |
| Knowledge Distillation for Large Language Models | [2603.13765](https://arxiv.org/abs/2603.13765) |
| A Human-Centred Architecture for Large Language Models-Cognitive Assistants in Manufacturing within Quality Management Systems | [2603.16325](https://arxiv.org/abs/2603.16325) |
| Exclusive Unlearning | [2604.06154](https://arxiv.org/abs/2604.06154) |
| LungCURE: Benchmarking Multimodal Real-World Clinical Reasoning for Precision Lung Cancer Diagnosis and Treatment | [2604.06925](https://arxiv.org/abs/2604.06925) |
| Evaluating the Reliability of Multiple Large Language Models in Risk Assessment: A CIS Controls Based Approach | [2605.05424](https://arxiv.org/abs/2605.05424) |
| From Demographics to Survey Anchors: Evaluating LLM Agents for Modeling Retirement Attitudes | [2605.16303](https://arxiv.org/abs/2605.16303) |
| Protocol for evaluating ChatGPT in biomedical association generation and verification using a RAG-enabled, cross-model majority voting workflow | [2605.30400](https://arxiv.org/abs/2605.30400) |
| Artificial Intelligence in Ship Finance: Applications, Opportunities, and a Case Study in AI-Augmented Loan Origination | [2606.11238](https://arxiv.org/abs/2606.11238) |
| LLM agents security duality: a comprehensive survey of self-security and empowered cybersecurity | [2606.28450](https://arxiv.org/abs/2606.28450) |
| Empirical Grounding Improves the Realism of LLM Agents Simulating Human Behavior During Disruptions | [2607.17437](https://arxiv.org/abs/2607.17437) |
| Multi-modal Interactive Control of Robotic Arm based on Offline Large Language Models | [2608.08183](https://arxiv.org/abs/2608.08183) |

### Attribution

Every document remains the work of its authors. Copyright and licence notices
inside each PDF are intact and unmodified; nothing here is adapted or excerpted.
CC-BY and CC-BY-SA require attribution â cite the original paper, not this
repository. No endorsement by NIST, OWASP or any author is implied.

### Wanted but not mirrorable

| Document | Status |
|---|---|
| NSA/CISA *Deploying AI Systems Securely* | Public domain, but media.defense.gov returns HTTP 403 to non-browser clients. Direct: <https://media.defense.gov/2024/Apr/15/2003439257/-1/-1/0/CSI-DEPLOYING-AI-SYSTEMS-SECURELY.PDF> |
| EU AI Act, Regulation (EU) 2024/1689 | EUR-Lex serves a bot-protection page to scripted clients. Note it was amended by Regulation (EU) 2026/1744, so cite the consolidated text: <https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689> |
| Model papers for Llama, GPT, Claude, Gemini | Under arXiv's default licence or not on arXiv. Links only. |

## Reproducing this harvest

`scripts/harvest-llm-papers.sh` re-runs the search, licence screen and download,
respecting arXiv's 3-second request interval. `meta/licenses.tsv` in that script's
output records the licence of every paper screened, so the filtering is auditable.
