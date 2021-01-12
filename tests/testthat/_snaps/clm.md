# Ordered models with clm work

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{A} \geq \operatorname{B} ) }{ 1 - P( \operatorname{A} \geq \operatorname{B} ) } \right] &= \alpha_{1} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2}) \\
    \log\left[ \frac { P( \operatorname{B} \geq \operatorname{C} ) }{ 1 - P( \operatorname{B} \geq \operatorname{C} ) } \right] &= \alpha_{2} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2})
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{A} \geq \operatorname{B} ) }{ 1 - P( \operatorname{A} \geq \operatorname{B} ) } \right] &= \alpha_{1} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\quad \beta_{2}(\operatorname{continuous\_2}) \\
    \log\left[ \frac { P( \operatorname{B} \geq \operatorname{C} ) }{ 1 - P( \operatorname{B} \geq \operatorname{C} ) } \right] &= \alpha_{2} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\quad \beta_{2}(\operatorname{continuous\_2})
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    P( \operatorname{A} \geq \operatorname{B} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2})] \\
    P( \operatorname{B} \geq \operatorname{C} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2})]
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    P( \operatorname{A} \geq \operatorname{B} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\qquad\ \beta_{2}(\operatorname{continuous\_2})] \\
    P( \operatorname{B} \geq \operatorname{C} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\qquad\ \beta_{2}(\operatorname{continuous\_2})]
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{A} \geq \operatorname{B} ) }{ 1 - P( \operatorname{A} \geq \operatorname{B} ) } \right] &= -0.81 + 0.03(\operatorname{continuous\_1}) - 0.03(\operatorname{continuous\_2}) \\
    \log\left[ \frac { P( \operatorname{B} \geq \operatorname{C} ) }{ 1 - P( \operatorname{B} \geq \operatorname{C} ) } \right] &= 0.59 + 0.03(\operatorname{continuous\_1}) - 0.03(\operatorname{continuous\_2})
    \end{aligned}
    $$

