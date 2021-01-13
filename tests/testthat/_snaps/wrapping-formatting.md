# Coefficient digits work correctly

    $$
    \operatorname{\widehat{mpg}} = 34.661 - 1.5873(\operatorname{cyl}) - 0.0206(\operatorname{disp})
    $$

---

    $$
    \operatorname{\widehat{mpg}} = 34.66 + -1.59(\operatorname{cyl}) + -0.02(\operatorname{disp})
    $$

# Wrapping works correctly

    $$
    \begin{aligned}
    \operatorname{mpg} &= \alpha + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{disp}) + \beta_{3}(\operatorname{hp})\ + \\
    &\quad \beta_{4}(\operatorname{drat}) + \beta_{5}(\operatorname{wt}) + \beta_{6}(\operatorname{qsec}) + \beta_{7}(\operatorname{vs})\ + \\
    &\quad \beta_{8}(\operatorname{am}) + \beta_{9}(\operatorname{gear}) + \beta_{10}(\operatorname{carb}) + \epsilon
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \operatorname{mpg} &= \alpha + \beta_{1}(\operatorname{cyl})\ + \\
    &\quad \beta_{2}(\operatorname{disp}) + \beta_{3}(\operatorname{hp})\ + \\
    &\quad \beta_{4}(\operatorname{drat}) + \beta_{5}(\operatorname{wt})\ + \\
    &\quad \beta_{6}(\operatorname{qsec}) + \beta_{7}(\operatorname{vs})\ + \\
    &\quad \beta_{8}(\operatorname{am}) + \beta_{9}(\operatorname{gear})\ + \\
    &\quad \beta_{10}(\operatorname{carb}) + \epsilon
    \end{aligned}
    $$

