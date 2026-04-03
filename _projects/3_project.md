---
layout: page
title: Bluesky Feed Toxicity Analysis
description: Demonstrating the importance of context in assessing online toxicity, with an ML pipeline for scoring and analyzing posts from Bluesky curated feeds.
img: assets/img/bsky.png
importance: 3
category: work
related_publications: false
---

How toxic is a post, really? In Trust & Safety scenarios context is king: the thread it belongs to, the feed it appeared in, the author's recent history. Often ML models contribute toxicity scores that can be misleading because they're narrowly focused on the posts. This project builds tooling to demonstrate how important that context is when assessing the true "toxicity" of posts online.

The pipeline pulls posts from Bluesky's curated feeds, scores them for toxicity and sentiment, and surfaces per-feed statistics alongside the flagged posts themselves. The broader goal is to iterate on the ML pipeline and build better, more context-aware tooling for content analysis.

Built to work with the [toxic-cicd](https://github.com/bartleyn/toxic-cicd) project, which handles model training and deployment.

[View on GitHub](https://github.com/bartleyn/bsky-feed-analysis)
