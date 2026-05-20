## 🏗 CI/CD Infrastructure Schema

Ця схема демонструє повний шлях вашого коду: від натискання `git push` до працюючого бота в кластері Kubernetes.

```mermaid
graph LR
    subgraph "Local Environment"
        Dev[👨‍💻 Developer] -- "git push" --> Repo
    end

    subgraph "GitHub (CI)"
        Repo(GitHub Repository) --> GHA{GitHub Actions}
        GHA --> Tests[🧪 Unit Tests]
        Tests --> Build[📦 Docker Build]
        Build --> GHCR[(GitHub Container Registry)]
    end

    subgraph "GitOps (CD)"
        GHCR --> UpdateTag[📝 Update Helm Tag]
        UpdateTag -- "commit" --> Repo
        Repo -- "monitor" --> ArgoCD{ArgoCD}
    end

    subgraph "Infrastructure (K8s)"
        ArgoCD -- "Sync State" --> K8s[Cloud/Local Cluster]
        K8s --> Pod[🤖 Telegram Bot Pod]
    end

    %% Стилізація вузлів
    style GHA fill:#f9f,stroke:#333,stroke-width:2px
    style GHCR fill:#4169e1,stroke:#fff,stroke-width:2px,color:#fff
    style ArgoCD fill:#f96,stroke:#333,stroke-width:2px
    style K8s fill:#32cd32,stroke:#333,stroke-width:2px
