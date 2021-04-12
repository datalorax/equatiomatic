# Simple lm models work

    $$
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{disp}) + \epsilon
    $$

---

    $$
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{gear}_{\operatorname{4}}) + \beta_{3}(\operatorname{gear}_{\operatorname{5}}) + \epsilon
    $$

---

    $$
    \operatorname{\widehat{mpg}} = 34.66 - 1.59(\operatorname{cyl}) - 0.02(\operatorname{disp})
    $$

# Interactions work

    $$
    \operatorname{body\_mass\_g} = \alpha + \beta_{1}(\operatorname{bill\_length\_mm}) + \beta_{2}(\operatorname{species}_{\operatorname{Chinstrap}}) + \beta_{3}(\operatorname{species}_{\operatorname{Gentoo}}) + \beta_{4}(\operatorname{bill\_length\_mm} \times \operatorname{species}_{\operatorname{Chinstrap}}) + \beta_{5}(\operatorname{bill\_length\_mm} \times \operatorname{species}_{\operatorname{Gentoo}}) + \epsilon
    $$

---

    $$
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{hp}) + \beta_{2}(\operatorname{wt}) + \beta_{3}(\operatorname{hp} \times \operatorname{wt}) + \epsilon
    $$

# Custom Greek works

    $$
    \operatorname{mpg} = \alpha + \hat{\beta}_{1}(\operatorname{cyl}) + \hat{\beta}_{2}(\operatorname{disp}) + \epsilon
    $$

---

    $$
    \operatorname{mpg} = \zeta + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{disp}) + \epsilon
    $$

# Hat is escaped correctly

    $$
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{carb}_{\operatorname{.L}}) + \beta_{2}(\operatorname{carb}_{\operatorname{.Q}}) + \beta_{3}(\operatorname{carb}_{\operatorname{.C}}) + \beta_{4}(\operatorname{carb}_{\operatorname{\texttt{\^{}}4}}) + \beta_{5}(\operatorname{carb}_{\operatorname{\texttt{\^{}}5}}) + \epsilon
    $$

