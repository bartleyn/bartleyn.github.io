---
layout: page
title: Auditing Algorithmic Bias on Twitter
description: Description of Twitter Audits in 2021-2022
img: assets/img/algo_audit/X_bias_post.png
importance: 1
category: work
related_publications: true
giscus_comments: true
---

<div class="row">
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/algo_audit/timeline.png" title="timeline" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Example timeline on Twitter from 2020, with the option shown to switch timeline "algorithms".
</div>

Remember what X used to look like when it was still Twitter? Remember the introduction of the "For You" Timeline back in 2016? An inspiration for this project was the question how much is ''the algorithm'' responsible for what we experience on these platforms, and just **how** different is it from the old chronological based timeline?

To study this we rolled out eight sock puppet accounts that could log-in to the Twitter website and just **scroll**, while occassionally sitting on any particular tweet for a few seconds. Four of these accounts would log-in and use the default "For You" personalized timeline, and the other four would use the Chronological timeline (based on just who you were following). 

These accounts would log-in all around the same time every day and scroll for about 30 tweets, gathering relevant meta-data about what tweets and who they were observing. After running for ~3 weeks, we noticed that we were getting significant differences between the personalized and chronological timelines in some dimensions, but no differences in others. For instance we found that personalized timelines on average were serving older tweets to users; similarly we found that personalized timelines were serving tweets that *ultimately* gathered more likes (i.e., they were more popular according to likes). 


<div class="row justify-content-sm-center">
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/algo_audit/age_tweets.png" title="Age of Tweets Seen" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.liquid path="assets/img/algo_audit/final_likes.png" title="# of Final Likes" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Figures from the paper. Personalized timelines served older and more popular tweets.
</div>

Ultimately, because of the limitations of this study, we figured that the methodology was worth extending -- both in terms of scale and duration -- but that the results of this audit did not really reveal anything substantial besides the differences mentioned above. 
This study is written up in {% cite bartley2021auditing %}.

We also wanted to know more about the *fraction* of people that made up your feed: how often do personalized timelines observe people with category A and how often do they observe people with category B? Because social media is fundamentally **social** we decided to study how these platforms might shape your perception of your social environment online. 


### Larger-Scale Audit

 We built on top of this study by running approx. 30 sock puppet accounts for ten months between 2021-2022. This gave us the ability to assess with some stronger degree of certainty the effects of recommender systems on **who** users get exposed to in their timelines, even when controlling for user behavior (as best as one can in a production online ecosystem). 

 We made each of these accounts follow the same set of users, half of whom were identified/labelled with previous research methods as pro-science and half who were labelled as anti-science. The goal was to have the following breakdown between accounts:

- Some would behave randomly on the platform, ocassionally liking tweets with no preference as to their label
    - Half of these would be assigned to the personalized timeline
    - The other half would be assigned to the chronological timeline

- Some would behave biased towards anti-science users
    - Half of these would be assigned to the personalized timeline
    - The other half would be assigned to the chronological timeline

- Some would behave biased towards pro-science users
    - Half of these would be assigned to the personalized timeline
    - The other half would be assigned to the chronological timeline

This allowed us to analyze structural differences between timelines while trying to account for the differences in user behavior. You can read more of the results in the paper {% cite bartley2024auditing %}.
