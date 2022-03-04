# NFLBDB2022

# Introduction <a id="1"></a>

We present novel metrics for kicker and punter performance derived from statistical analysis of player tracking data. Many NFL fans attribute the outcome of a field goal attempt to factors within the kicker’s control. We apply ensemble modeling techniques to many variables to identify those that most affect play outcomes; examples include field conditions (such as temperature and wind speed) and the relative locations of the offensive and defensive players. Our probabilistic model of a player’s entire performance distribution provides a quantitative framework for evaluating special teams and those players that contribute to the outcomes of a play. This analysis can be used in real-time for game strategy and player evaluation.

New metrics measure performance relative to the average performance in the same play situation. Field goals over expected (**FGOE**), extra points (**XPOE**), and punt yards (**PYOE**) are key metrics. The player’s contribution averaged over a season (**Total Contribution**) weights field goals and extra points appropriately. **Clutch** identifies players who perform best when the game is on the line and under the most pressure. Performance consistency over a season (**Consistency**) and performance trajectory over multiple seasons (**Trend**) are quantified. This analysis highlights that kicker performance tends to be inconsistent over multiple seasons. NFL teams may want to reconsider the salary structure of kickers in favor of reducing guaranteed salaries for performance-based incentives.

A ranking of players is validated by player awards, such as Pro Bowl and All-Pro, and player salaries. This ranking identifies players for acquisition or contract extension and players that could be traded/released.

Our models provide real-time analysis of expected performance. They offer a decision-making tool for teams to assess the tradeoffs of certain plays (such as whether to kick the field goal or go for it on 4th down).


# Punter Analysis <a id="2"></a>

Punter performance metrics are developed using gradient boosting regression trees (XGBoost):  

**Expected Punt Yards (ePY):** Expected punt yardage on every punt play from machine learning model. **ePY** is based on the distance to the end zone, pressure from opposing defenders, weather conditions, kicker speed, acceleration, orientation, and direction of the kicker. This value indicates how an average punter would perform in the same situation. Predictions are made at every time frame from ball snap until the punt attempt. **ePY** is then aggregated over an entire season.

**Punt Yards Over Expected (PYOE):** Difference between the actual and expected punt yards on every play aggregated over a season. A positive **PYOE** indicates the punter outperformed expectations and vice versa. 

**Consistency:** Measure of performance consistency through the standard deviation of **PYOE** in a given season. A lower **Consistency** (low standard deviation) indicates the player has less variation his performance. Unsurprisingly, the best kickers tend to be more consistent in a season as well as over multiple seasons. The correlation between consistency and kicking performance is about -.8, meaning the best kickers tend to be more consistent and vice versa.

For example, Jake Bailey’s actual punt yards were 5 yards farther than expected in 2020. He was significantly more consistent than Matt Darr (**Figure 1**). 
<img width="906" alt="Jake DarrPYOE" src="https://user-images.githubusercontent.com/48921076/156674468-988cf32b-3ad1-4815-b9a5-054f02e12240.png">
