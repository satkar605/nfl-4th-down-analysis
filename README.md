# NFL 4th Down Decision Modeling

## Project Overview
This project investigates 4th down decision-making behavior in the NFL using 2024 play-by-play data. The goal was to develop a predictive model that identifies when teams are likely to "go for it" instead of kicking. The analysis was conducted using SAS and applied logistic regression to evaluate how factors like score, time, and field position influence strategy. The final model achieved 88.3% classification accuracy and offers interpretable insights for coaches, analysts, and sports strategists.

## Business Challenge
NFL teams face critical choices on 4th down—decisions that can shift momentum and define outcomes. Historically driven by instinct, these decisions now demand data-backed approaches. This project explores what contextual features shape 4th down decisions and builds a framework to support more consistent and strategic play-calling.

## Data Summary
- **Source**: Publicly available 2024 NFL play-by-play dataset ( Thedata file has been downloaded from [https://github.com/nflverse/nflverse-pbp ](url)

- **Time Frame**: Full regular season
- **Scope**: Filtered to only include 4th down plays
- **Variables Used**:
  - *Continuous*: `ydstogo`, `yardline_100`, `game_seconds_remaining`, `score_differential`, `expected_points_added (epa)`
  - *Categorical*: `quarter (qtr)`, `timeouts remaining (offense & defense)`, `home/away team status`
- **Note**: Records such as no-plays and kneel-downs were excluded to retain only true go-for-it vs. kick decisions

## Key Business Questions
- Under what game conditions are teams more likely to attempt a 4th down conversion?
- How do timing, field position, and score margin influence aggressiveness?
- Are there quarter-specific behavioral patterns in decision-making?
- Can a model be built that accurately and simply predicts go-for-it behavior?

## Exploratory Analysis

### Frequency Distribution: Categorical Variables
Most 4th down plays result in punts or field goals, confirming a conservative league-wide trend. Quarter-wise analysis shows a noticeable rise in go-for-it attempts during the 4th quarter.

![eda_cats](https://github.com/user-attachments/assets/1ac6ed06-52ea-4178-a78a-37c94c832803)

### Boxplots: Continuous Variables
Boxplots reveal game context patterns:
- Shorter distances to first down (`ydstogo`) increase go-for-it attempts
- 4th down plays cluster around midfield (`yardline_100`)
- Trailing teams (`score_differential < 0`) show more aggressive play-calling

![eda_cont](https://github.com/user-attachments/assets/366e3b96-f3a4-4a45-9ddf-ae6b624342fc)

## Predictive Modeling

### Logistic Regression Framework
The model predicts `go_for_it` as a binary outcome using contextual variables. Both continuous and categorical predictors were included using SAS’s `PROC LOGISTIC`.

- Significant predictors: `ydstogo`, `yardline_100`, `game_seconds_remaining`, `score_differential`, `epa`, `quarter`, and timeouts
- Stepwise selection was applied to reduce complexity and improve interpretability

### Odds Ratio Interpretation (Stepwise Model)
Timeout-related variables and quarter effects had the strongest influence. For example, teams with **0 timeouts** were over **3 times more likely** to go for it compared to teams with 3 timeouts.

![odds_ratio](https://github.com/user-attachments/assets/46637b6d-21c3-4485-affe-1e20c20db557)

### Model Performance
- **Concordance**: 88.3%
- **AUC (Area Under Curve)**: 0.8827 — suggests strong classification performance
- Stepwise model achieved identical performance to the full model while dropping non-informative features

![roc_curve](https://github.com/user-attachments/assets/8ca953a9-d739-48d9-9cf0-49d4c6374b04)

## Business Recommendations
- **Game Planning**: Use a go-for-it probability threshold (e.g., >60%) as a trigger for aggressive play design
- **Late Game Strategy**: Prepare specific playbooks for 4th quarter situations where teams show highest aggressiveness
- **Analyst Tools**: Broadcast teams or coaching analysts can simulate "go" probabilities in real time using key inputs
- **Timeout Awareness**: Incorporate timeout count as a live metric in 4th down decision dashboards

## Assumptions and Limitations
- Team identity and coaching style were excluded to maintain general applicability
- Model only includes regular season 2024 games
- Analysis assumes consistent officiating and does not model play-specific tactics
- Overtime (Q5) had very low volume and was excluded from comparison testing

## Technical Appendix
- **Tool**: SAS (PROC LOGISTIC)
- **Feature Engineering**: Binary target variable (`go_for_it`), categorical encoding using `param=glm`
- **Model Validation**:
  - Stepwise selection reduced AIC from 2697.49 to 2695.55
  - ROC and concordance statistics used for evaluation
- **Performance Summary**:
  - AUC: 0.8827
  - Concordant Pairs: 88.3%
  - Variables retained: All except `posteam_type` (home/away), which was not statistically significant



