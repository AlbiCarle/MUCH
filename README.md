# MUCH
MUlti Counterfactual Halton sampling

Counterfactual eXplanations (CEX) are spreading rapidly in the literature on explainable AI due to their ability to be easily understood and highly adaptable to data. 
In this repository you will found an original method for the extraction of  multiple CEX from numerical data based on Halton sampling and Support Vector Data Description.

Examples may help to better understand the motivation
behind this study and the importance of counterfactual
reasoning in multiclass problems. In the field of health,
several diseases present with different stages of severity
(e.g., cancer, chronic obstructive pulmonary disease...) that
can worsen drastically in a short time if not properly treated.
In this case, multiclass counterfactuals can be a crucial
instrument to monitor the stage of disease progression in
order to detect minimal changes in the patient’s condition
and apply appropriate countermeasures before the disease
progresses to the next stage. Another example may instead
involve the study of the transition of a phenomenon that
develops over several stages (e.g., A, B, C, D). A counterfactual analysis can be useful to check for differences between
different transitions (e.g., direct paths skipping intermediate
transitions or progressive sequential paths).

The concept paper behind this algorithm is published in IEEE Transactions on Artificial Intelligence:

A. Carlevaro, M. Lenatti, A. Paglialonga and M. Mongelli, "Multiclass Counterfactual Explanations Using Support Vector Data Description," in IEEE Transactions on Artificial Intelligence, vol. 5, no. 6, pp. 3046-3056, June 2024, doi: 10.1109/TAI.2023.3337053.
keywords: {Artificial intelligence;Kernel;Controllability;Complexity theory;Classification algorithms;Training;Support vector machine classification;Counterfactual explanations;multiclass classification;support vector data description},

Enjoy !

## Applications

-) FIFA dataset: Counterfactual explanations to create different training plans to help specializing a football player in a different role based on the FIFA dataset main attributes. The referenced code is available at the subfolder [MultiFIFA](MultiFIFA).

-) CVD_risk: Counterfactual explanations for creating personalized risk reduction strategies to reduce the risk of developing cardiovascular diseases (CVDs) in patients diagnosed with Chronic Obstructive Pulmonary Disease (COPD). The referenced code is available at the subfolder [CVD_risk](CVD_risk/)


## Requirements 

For the evaluation and visualization of the counterfactual explanations we used the following github repository: 

Moses (2023). spider_plot (https://github.com/NewGuy012/spider_plot/releases/tag/19.4), GitHub. Retrieved January 17, 2023.

The datasets can be directly retrieved from Kaggle_

-) FIFA 2023: https://www.kaggle.com/datasets/cashncarry/fifa-23-complete-player-dataset

-) Stellar Classification: https://www.kaggle.com/fedesoriano/stellar-classification-dataset-sdss17
