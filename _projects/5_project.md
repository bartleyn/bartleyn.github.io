---
layout: page
title: Toxicity Model CI/CD
description: Practicing the full lifecycle of a text toxicity model, from training and evaluation to deploying it behind an API that other projects can use.
importance: 5
category: work
related_publications: false
---

A lot of toxicity detection work stops at the notebook stage. I wanted to practice building a service end-to-end: training a model, checking it against some explicit criteria before it goes out, deploying it, and keeping it updated as an API that my other tools can actually call.

To keep things simple at first the model is just TF-IDF features with logistic regression. Each training run is versioned and saves the model along with a held-out eval set, and the evaluation step reports AUC, precision, recall, F1, and specificity. A promotion script then checks those metrics against thresholds in a config file, and only if the model passes does it become the `latest` version. That version gets served through a FastAPI service that returns toxicity, sentiment, and hate speech scores for each text (with PII detection along the way). GitHub Actions runs CI on every change and handles deploying the promoted model.

This is what does the scoring for the [Bluesky Feed Toxicity Analysis](/projects/3_project/) project. Here's what a request looks like:

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
