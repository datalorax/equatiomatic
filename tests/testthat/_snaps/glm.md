# Logistic regression works

    $$
    \log\left[ \frac { P( \operatorname{outcome} = \operatorname{1} ) }{ 1 - P( \operatorname{outcome} = \operatorname{1} ) } \right] = \alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2})
    $$

# Probit regression works

    $$
    P( \operatorname{outcome} = \operatorname{1} ) = \Phi[\alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2})]
    $$

---

    $$
    E( \operatorname{mpg} ) = \alpha + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{disp})
    $$

# Distribution-based equations work

    $$
    \begin{aligned}
    \operatorname{outcome} &\sim Bernoulli\left(\operatorname{prob}_{\operatorname{outcome} = \operatorname{1}}= \hat{P}\right) \\
     \log\left[ \frac { \hat{P} }{ 1 - \hat{P} } \right] 
     &= \alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2})
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \operatorname{outcome} &\sim Bernoulli\left(\operatorname{prob}_{\operatorname{outcome} = \operatorname{1}}= \hat{P}\right) \\
     \hat{P} 
     &= \Phi[\alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2})]
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    E( \operatorname{mpg} ) &= \alpha + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{disp})
    \end{aligned}
    $$

# non-binomial regression works

    $$
    \log ({ E( \operatorname{outcome} ) })  = \alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2})
    $$

---

    $$
    \log ({ E( \operatorname{outcome} ) })  = \alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2})
    $$

---

    $$
    \log ({ E( \operatorname{outcome} ) })  = \alpha + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{continuous\_1}) + \beta_{4}(\operatorname{continuous\_2}) + \operatorname{offset(rep(1, 300))}
    $$

