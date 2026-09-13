---
layout: page
title: Toxicity Model CI/CD
description: An end-to-end pipeline for training, evaluating, promoting, and serving a text toxicity model behind a live scoring API.
importance: 5
category: work
related_publications: false
---

Most toxicity-detection work stops at a notebook. This project is about everything that comes after: getting a model trained, evaluated against explicit promotion criteria, deployed, and kept up to date as a service other tools can actually call.

The model is deliberately simple to start (TF-IDF features with logistic regression), so the focus stays on the pipeline around it:

- **Train & evaluate** — versioned training runs save model artifacts alongside a held-out eval set, and evaluation reports AUC, precision, recall, F1, and specificity.
- **Promote** — a rule-based promotion step checks those metrics against configured thresholds before a version becomes `latest`.
- **Serve** — a FastAPI service returns toxicity, sentiment, and hate-speech scores per text, with PII detection in the loop.
- **Ship** — GitHub Actions runs CI on every change and continuously deploys the promoted model.

It powers the scoring in the [Bluesky Feed Toxicity Analysis](/projects/3_project/) project.

```bash
curl -X POST <api-host>/score \
  -H "Content-Type: application/json" \
  -d '{"texts": ["go screw yourself"], "thresholds": [0.50]}'
```

```json
{
  "model_version": "1.1.0",
  "threshold": 0.5,
  "results": [
    {
      "label": 1,
      "scores": { "toxicity": 0.73, "sentiment": -0.10, "hatespeech": 0.01 }
    }
  ]
}
```

[View on GitHub](https://github.com/bartleyn/toxic-cicd)
