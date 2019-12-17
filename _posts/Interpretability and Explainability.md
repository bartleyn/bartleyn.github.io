# Interpretability and Explainability
--

AI, in all its hyped-up beauty, is surprisingly difficult to explain We're building more and more complex systems and using them in more diverse ways. Medical professionals are using computer vision tools to assist in diagnosis. Police departments are adopting smarter early intervention systems. Soon we may have more autonomous cars let loose on the world. But how do we make sure that these systems are trustworthy? 

Well before we can figure out whether or not systems are trustworthy, we should lay out some of the ground rules about trust. If we're to rely on these tools to make decisions for us, there are two immediate weak links: either the **model** that is making the decisions is faulty and unreliable, or the **decisions** themselves are the problem. Imagine you're getting a checkup by a doctor; everything is going well and good until you mention a crink in your neck. You slept poorly last night, so were it any other day you would not have mentioned it. But when you tell the doctor this, without skipping a beat, you get informed that it's very likely you broke your foot. Just based on this one fact alone. Suspicious, right? 

The difference between trusting the model and trusting the decision, in our example, comes down to whether or not you think the doctor made a one-off bad decision, or if the doctor is just not very good at what they do. Maybe you've seen this doctor for years, and you think that if he or she had more information about your symptoms right now, that a more reasonable diagnosis would be made. But maybe this is the first time you've seen this doctor, let alone anyone else in the office. Maybe the doctor really is just that bad. 

To a scientist, the doctor is an example of a **model**: scientists (and engineers) like to understand the world around us, but because science is hard, we can only get their best guesses as to how things work. These guesses take the form of models: some are generally very reliable and have been proven and refined over many years. Some less so -- it's not to say that these models are *not* reliable, but rather that they are reliable *under certain conditions*. We can model the physics of how apples drop from trees and how fast planes need to go to be able to take off really well. But we also try to cooking up models for understanding how quickly a prescription drug goes through your system. Not to mention models used for predicting how likely a person is to see a movie they saw in an advertisement. To get to these models, we have to ask a few questions about who or what we're trying to model. Who is the person taking the drug? What kind of drug have they been prescribed? What about the person who saw the ad? How much do you know about their preferences? What about their emotional state when they saw the ad? As you can imagine, trying to get all the right data and ask the right questions for these models is pretty much impossible. That's why scientists make assumptions. It becomes easier to make assumptions about how people behave, or about the biology involved in the drug processing. And for the most part these assumptions help simplify the situation enough to solve these problems, and let us actually **do** something rather than get caught up being perfectionist. 

Just to be clear, I'm not saying that there isn't any perfect science. There are a series of studies and experiments in every discipline that are just so elegant and well-executed that they've come to be really impactful in their respective fields. Clear and reproducible experiments, combined with robust statistical analysis, can make for a convincing and reliable take on any problem. 

Before moving on, there are a couple of related topics I just want to bring up: bias in data, and automation. 




There is a long lineage of work that has been done in the "explanability" space. 
* Expert Systems & Bayesian Networks
    * You can think of these as decision support systems for physicians, etc
    * rule-based systems 
    * bayesian networks
* Recommender Systems
    * neighbor information
    * per-user history information
    * general feature-information
* Causal inference
* Natural Language Generation
* Agent-based approaches

* Machine learning literature relying on producing visualizations of the predictions 
	* neural networks and activation patterns, etc
* prediction-interpretation and justification
    * LIME
* interpretable models 
    * decision trees

reconciling all of this with the culture of strident empiricism with
expanding this into the realm of NLP and vector space work

NLP maybe more traditionally comes from the statistical realm of looking for model sparsity as their quantifiable proxy for interpretability

But there's a softer side to the question of interpretability in the CS (and perhaps Data Science) space. 

Given that a lot of these systems are novel applications of machine learning, I think that they carry with them a lot of the conventions from their related scientific sub-discplines in software engineering & machine learning. Within both of these disciplines, given how empirical the research that happens within them, there's a sort of accuracy fetish that pushes researchers to optimize for performance and THEN grapple with the workings of the code, rather than the other way around.

* Replication being an issue for understanding how these models work
    * Open-source code
    * Sharing data
* Balancing the strident empiricism with theoretical underpinnings
* Evaluations being biased as well
    * Difficult to trust things like word embeddings and their evaluation methods, since they often don't reliably predict usefulness for a particular downstream task. 
    * People often rely on intrinsic evaluation, but these are not particularly accurate predictors of utility in other task's either



Word Embeddings and stuff
* wide variety of applications and incomplete benchmarks
* Our goal is to be able to evaluate word embedding performance easily and quickly, so we can compare different models and strive towards better embeddings
* But an issue arises when evaluation methods don't always capture useful performance information about some other task you might want to test these embeddings on
* Something else we strive for is a little bit more interpretabliity of the actual embeddings themselves
     * what do the dimensions capture
     * should we actually be trying to fit the dimensions into our understanding, or meld our understanding with the embeddings

* QVEC is useful because it tries to both quickly evaluate a model against a gold standard, and do it in a way that is *marginally* more interpretable

* But who's to say that our understanding of linguistic features are discrete, and we are throwing away potentially valuable "continuous" semantic information when we compare against these discrete features

* Maybe the best thing to do in the meantime is to evaluate based on:
    * utility to our personal task
    *  use some standard downstream tasks benchmarks 
    *  not evaluate and just explore the characteristics


* Brown Clusters
* enforced sparsity as a means for understanding what the dimensions of a vector imply 
    * kind of the ideal end goal of a sparse mixture model like a topic model
    * structured sparsity in nlp


### Sparsity

Sparsity has at least four related meanings in NLP:
1) Data sparsity: N is too small to obtain a good estimate for the weights of your hypothesis (also curse of dimensionality)
2) "Probability" sparsity: A probability distribution over events might have many which receive **zero** probability (could be good or bad)
3) Sparsity in the dual: associated with SVMs/kernel based methods, where the predictor can be represented via kernel calculations involving just a few training instances
4) Model sparsity: Most dimensions of f are not needed for a good hypothesis: those dimensions of w can be zero, leading to a sparse w (model)


The bet on sparsity & Occam's Razor
Models with just a few features are
* easy to explain
* can yield attractive linguistic hypotheses
* "reminiscient of classical symbolic systems"
* etc
* 



  