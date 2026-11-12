---
layout: page
title: Feed Discovery on Bluesky
description: A custom Bluesky feed that recommends other people's feeds, using a multi-armed bandit to decide which ones to show you.
importance: 4
category: work
related_publications: false
---

Anyone can publish a custom feed on Bluesky, and there are at least 100,000 of them on record at this point. But how many does the average person actually find? Probably just a handful. So instead of building another feed that serves posts on one topic, I wanted to build a *feed of feeds*: each time you load it you get a few short chunks of posts pulled live from other feed generators, so as you scroll you get a sample of what's out there.

You can find it live on Bluesky as a custom feed (`did:web:feeds.barn.city`).

### How it works

When a request comes in, the service picks a slate of candidate feeds, grabs a chunk of posts from each of them in parallel, filters out harmful posts, and stitches the chunks together into one response. If a feed is too slow it just gets dropped for that request. Each post is tagged with the feed it came from, which means when someone likes or reposts something we can attribute that interaction back to the right feed.

Right now the feed selection is a Thompson sampling multi-armed bandit, where each (user, feed) pair has a Beta posterior that gets updated from those interactions. This works pretty well for exploring when we don't know anything about a user yet. I've also clustered the feeds by theme (BERTopic and k-means), and what I've seen so far suggests that a hybrid content + collaborative filtering approach that leans toward **novelty** is the more rewarding direction to take this.

The service is written with FastAPI and PostgreSQL, with Airflow jobs that check whether feeds are still alive and refresh the layout.

[View on GitHub](https://github.com/bartleyn/feed-discovery)
