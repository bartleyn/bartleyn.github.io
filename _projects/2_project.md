---
layout: page
title: AT Protocol Infrastructure Health
description: Analyzing the activity and geographic distribution of Personal Data Servers (PDSes) to assess how truly decentralized the Bluesky/AT Protocol ecosystem is.
img: assets/img/at_proto.png
importance: 2
category: work
related_publications: false
---

The [AT Protocol](https://atproto.com/) underpinning Bluesky promises a decentralized social media ecosystem where users can host their own data on Personal Data Servers (PDSes). But how decentralized is it in practice?

This project monitors PDS activity across the network, tracking where PDSes are hosted geographically and how actively they are being used. The goal is to provide a dynamic and empirical picture of the ecosystem's decentralization. If BlueSky PBC were to go offline tomorrow, how would the system fare?

The dashboard is organized around three questions:

- **Infrastructure** — Where are PDSes located, who hosts them, what software versions do they run, and how concentrated are users across them? A sample of the Jetstream firehose separates genuine cross-party federation from traffic between Bluesky's own internal shards.
- **Longevity** — How old is the independent PDS ecosystem? When servers launched, how account cohorts are distributed, and how account creation is trending week over week.
- **Migrations** — Using the PLC directory's operation log: how many accounts have moved, where they went, and the multi-hop paths they took to get there.

Collectors write append-only snapshots to SQLite on independent schedules, so history is preserved and the dashboard always shows the freshest data for each view. Built with Next.js, SQLite, and Recharts.

[Live Dashboard](https://atproto.barn.city) | [View on GitHub](https://github.com/bartleyn/atproto-health)
