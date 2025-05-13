# NFL Play-by-Play Dataset Dictionary

## Dataset Information
- **Dataset Name**: WORK.PLAY_DATA
- **Observations**: 49,492
- **Variables**: 372
- **Source**: nflverse play-by-play dataset

## Key Variables for 4th Down Analysis

### Game & Play Identification
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| game_id | Char | 15 | Unique game identifier |
| play_id | Num | 8 | Unique play identifier within a game |
| week | Num | 8 | NFL week number |
| season | Num | 8 | NFL season year |
| play_type | Char | 11 | Type of play (run, pass, punt, field_goal, etc.) |

### Game Situation
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| down | Num | 8 | Current down (should be 4 for our analysis) |
| ydstogo | Num | 8 | Yards needed for a first down |
| yardline_100 | Num | 8 | Distance from opponent's endzone (100 = own goalline) |
| qtr | Num | 8 | Game quarter (1-5, where 5 = overtime) |
| game_seconds_remaining | Num | 8 | Seconds remaining in the entire game |
| quarter_seconds_remaining | Num | 8 | Seconds remaining in the current quarter |
| goal_to_go | Num | 8 | Indicator if it's a goal-to-go situation (1=yes, 0=no) |

### Team Information
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| posteam | Char | 3 | Team with possession |
| defteam | Char | 3 | Defensive team |
| posteam_type | Char | 4 | Whether possession team is home or away |
| home_team | Char | 3 | Home team abbreviation |
| away_team | Char | 3 | Away team abbreviation |

### Score Information
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| score_differential | Num | 8 | Score difference (posteam - defteam) |
| posteam_score | Num | 8 | Current score of possession team |
| defteam_score | Num | 8 | Current score of defensive team |
| posteam_score_post | Num | 8 | Possession team score after the play |
| defteam_score_post | Num | 8 | Defensive team score after the play |

### Decision & Outcome Variables
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| play_type | Char | 11 | Type of play (run, pass, punt, field_goal, etc.) |
| fourth_down_converted | Num | 8 | Indicator if 4th down was converted (1=yes, 0=no) |
| fourth_down_failed | Num | 8 | Indicator if 4th down failed (1=yes, 0=no) |
| yards_gained | Num | 8 | Yards gained on the play |

### Advanced Metrics
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| epa | Num | 8 | Expected Points Added on the play |
| wp | Num | 8 | Win probability before the play |
| wpa | Num | 8 | Win probability added by the play |
| success | Num | 8 | Binary indicator if play was successful (1=yes, 0=no) |

### Timeout Information
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| posteam_timeouts_remaining | Num | 8 | Timeouts remaining for possession team |
| defteam_timeouts_remaining | Num | 8 | Timeouts remaining for defensive team |

### Play Description
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| desc | Char | 177 | Detailed text description of the play |

## Notes for Analysis
1. To filter for 4th down plays, use: `WHERE down = 4;`
2. To create the binary decision variable, use:
   ```sas
   IF play_type IN ('run', 'pass') THEN go_for_it = 1;
   ELSE IF play_type IN ('punt', 'field_goal') THEN go_for_it = 0;
   ELSE go_for_it = .;
   ```
3. Always verify variable names before use, as the dataset may have updates or variations

## Potentially Important Additional Variables
| Variable | Type | Length | Description |
|----------|------|--------|-------------|
| shotgun | Num | 8 | Indicator if play was from shotgun formation |
| no_huddle | Num | 8 | Indicator if play was run with no huddle |
| qb_dropback | Num | 8 | Indicator if the QB dropped back to pass |
| run_location | Char | 6 | Location of run play (left, middle, right) |
| run_gap | Char | 6 | Gap of run play (end, guard, tackle, etc.) |
| pass_location | Char | 6 | Location of pass (left, middle, right) |
| pass_length | Char | 5 | Length of pass (short, deep) |
| field_goal_result | Char | 1 | Result of field goal attempt |
| punt_blocked | Num | 8 | Indicator if punt was blocked |
| rush_attempt | Num | 8 | Indicator if play was a rush attempt |
| pass_attempt | Num | 8 | Indicator if play was a pass attempt | 