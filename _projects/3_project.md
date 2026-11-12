---
layout: page
title: Bluesky Feed Toxicity Analysis
description: Demonstrating the importance of context in assessing online toxicity, with an ML pipeline for scoring and analyzing posts from Bluesky curated feeds.
img: assets/img/bsky.png
importance: 3
category: work
related_publications: false
---

How toxic is a post, really? In Trust & Safety scenarios context is king: when you consider the thread a post appears in and all the actors involved the meaning often changes. Imagine a user uses an identity-specific slur against another user. By itself it seems inappropriate and perhaps toxic; why would someone use a slur like that unless to harass the other user? Here the context is important -- it could very well be the case that both users are friends with each other and perhaps belong to the same identity group, using the slur in a joking reclamatory manner. Now this still might very well be inappropriate, or toxic according to platform policies. But off-the-shelf ML models (including LLMs without tuning) won't be able to account for that.

 Off-the-shelf models (including LLMs) often bring the biases and contexts in which they were trained to the new data it's labeling. Consider a model trained exclusively on horror movies, where the model is trained to score lines of dialogue for toxicity. The data it has gathered will probably give lines with "blood" a higher score of being toxic. Let's say that the model, associating "blood" with a higher toxic score, then gets downloaded and used by someone to score data in another area like healthcare discussions. Suddenly normal conversations about blood could be scored as toxic. This is what I mean by models bringing the biases and contexts from the data on which they're trained. This project builds tooling to demonstrate how important that context is when assessing the true "toxicity" of posts online.

The pipeline pulls posts from Bluesky's curated feeds, scores them for toxicity and sentiment, and surfaces per-feed statistics alongside the flagged posts themselves. The broader goal is to iterate on the ML pipeline and build better, more context-aware tooling for content analysis.

Built to work with the [toxic-cicd](https://github.com/bartleyn/toxic-cicd) project, which handles model training and deployment.

[View on GitHub](https://github.com/bartleyn/bsky-feed-analysis)
