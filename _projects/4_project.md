---
layout: page
title: Feed Discovery on Bluesky
description: A "feed of feeds" — a custom Bluesky feed generator that uses a multi-armed bandit to recommend other people's feeds.
importance: 4
category: work
related_publications: false
---

Bluesky lets anyone publish a custom feed, and there are now thousands of them. Most people never find more than a handful. This project flips the usual feed generator around: instead of serving posts on a single topic, it serves a _feed of feeds_. Each page is a set of short chunks pulled live from other feed generators, so scrolling becomes a tour of the Bluesky feed ecosystem rather than a single timeline.

It's live as a custom feed on Bluesky (`did:web:feeds.barn.city`).

### How it works

Every request selects a slate of candidate feeds, fetches a chunk of posts from each in parallel under a hard two-second budget, filters harmful posts, and assembles the chunks into one response. Each post is tagged with the feed it came from, so likes, reposts, and other interactions can be attributed back to the feed that surfaced it.

Feed selection is a Thompson-sampling multi-armed bandit: each (user, feed) pair keeps a Beta posterior that's updated from those attributed interactions. That works well for cold-start exploration. The feeds are also clustered by theme (BERTopic / k-means), and early results suggest a hybrid content + collaborative-filtering approach tuned toward novelty is the more rewarding direction.

### Stack

FastAPI · PostgreSQL / SQLAlchemy · Airflow for feed liveness and layout refreshes · AT Protocol feed generator API

[View on GitHub](https://github.com/bartleyn/feed-discovery)
