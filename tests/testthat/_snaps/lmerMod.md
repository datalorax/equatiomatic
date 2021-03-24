# Categorical variable level parsing works (from issue #140)

    $$
    \begin{aligned}
      \operatorname{error}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1}(\operatorname{brochure}_{\operatorname{standard}}) + \beta_{2}(\operatorname{disease}_{\operatorname{DS}}) + \beta_{3}(\operatorname{brochure}_{\operatorname{standard}} \times \operatorname{disease}_{\operatorname{DS}}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for ID j = 1,} \dots \text{,J}
    \end{aligned}
    $$

# Unconditional lmer models work

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for school k = 1,} \dots \text{,K}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for school k = 1,} \dots \text{,K} \\
        \alpha_{l}  &\sim N \left(\mu_{\alpha_{l}}, \sigma^2_{\alpha_{l}} \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

# Level 1 predictors work

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1}(\operatorname{female}) + \beta_{2}(\operatorname{ses}) + \beta_{3}(\operatorname{minority}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1}(\operatorname{wave}), \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for school k = 1,} \dots \text{,K} \\
        \alpha_{l}  &\sim N \left(\mu_{\alpha_{l}}, \sigma^2_{\alpha_{l}} \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

# Mean separate works as expected

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\alpha_{j[i]} + \beta_{1}(\operatorname{female}) + \beta_{2}(\operatorname{ses}) + \beta_{3}(\operatorname{minority}), \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i],k[i],l[i]} + \beta_{1}(\operatorname{wave}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for school k = 1,} \dots \text{,K} \\
        \alpha_{l}  &\sim N \left(\mu_{\alpha_{l}}, \sigma^2_{\alpha_{l}} \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

# Wrapping works as expected

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1}(\operatorname{female})\ + \\
    &\quad \beta_{2}(\operatorname{ses}) + \beta_{3}(\operatorname{minority}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

# Unstructured variance-covariances work as expected

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1}(\operatorname{female}) + \beta_{2}(\operatorname{ses}) + \beta_{3j[i]}(\operatorname{minority}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{3j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{3j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{3j}} \\ 
         \rho_{\beta_{3j}\alpha_{j}} & \sigma^2_{\beta_{3j}}
      \end{array}
    \right)
     \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{female}) + \beta_{2j[i]}(\operatorname{ses}) + \beta_{3}(\operatorname{minority}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}} \\
          &\mu_{\beta_{2j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} & \rho_{\alpha_{j}\beta_{2j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}} & \rho_{\beta_{1j}\beta_{2j}} \\ 
         \rho_{\beta_{2j}\alpha_{j}} & \rho_{\beta_{2j}\beta_{1j}} & \sigma^2_{\beta_{2j}}
      \end{array}
    \right)
     \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{female}) + \beta_{2j[i]}(\operatorname{ses}) + \beta_{3}(\operatorname{minority}) + \beta_{4j[i]}(\operatorname{female} \times \operatorname{ses}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j} \\
          &\beta_{4j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}} \\
          &\mu_{\beta_{2j}} \\
          &\mu_{\beta_{4j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cccc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} & \rho_{\alpha_{j}\beta_{2j}} & \rho_{\alpha_{j}\beta_{4j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}} & \rho_{\beta_{1j}\beta_{2j}} & \rho_{\beta_{1j}\beta_{4j}} \\ 
         \rho_{\beta_{2j}\alpha_{j}} & \rho_{\beta_{2j}\beta_{1j}} & \sigma^2_{\beta_{2j}} & \rho_{\beta_{2j}\beta_{4j}} \\ 
         \rho_{\beta_{4j}\alpha_{j}} & \rho_{\beta_{4j}\beta_{1j}} & \rho_{\beta_{4j}\beta_{2j}} & \sigma^2_{\beta_{4j}}
      \end{array}
    \right)
     \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{female}) + \beta_{2j[i]}(\operatorname{ses}) + \beta_{3j[i]}(\operatorname{minority}) + \beta_{4j[i]}(\operatorname{female} \times \operatorname{ses}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j} \\
          &\beta_{3j} \\
          &\beta_{4j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}} \\
          &\mu_{\beta_{2j}} \\
          &\mu_{\beta_{3j}} \\
          &\mu_{\beta_{4j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccccc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} & \rho_{\alpha_{j}\beta_{2j}} & \rho_{\alpha_{j}\beta_{3j}} & \rho_{\alpha_{j}\beta_{4j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}} & \rho_{\beta_{1j}\beta_{2j}} & \rho_{\beta_{1j}\beta_{3j}} & \rho_{\beta_{1j}\beta_{4j}} \\ 
         \rho_{\beta_{2j}\alpha_{j}} & \rho_{\beta_{2j}\beta_{1j}} & \sigma^2_{\beta_{2j}} & \rho_{\beta_{2j}\beta_{3j}} & \rho_{\beta_{2j}\beta_{4j}} \\ 
         \rho_{\beta_{3j}\alpha_{j}} & \rho_{\beta_{3j}\beta_{1j}} & \rho_{\beta_{3j}\beta_{2j}} & \sigma^2_{\beta_{3j}} & \rho_{\beta_{3j}\beta_{4j}} \\ 
         \rho_{\beta_{4j}\alpha_{j}} & \rho_{\beta_{4j}\beta_{1j}} & \rho_{\beta_{4j}\beta_{2j}} & \rho_{\beta_{4j}\beta_{3j}} & \sigma^2_{\beta_{4j}}
      \end{array}
    \right)
     \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1j[i],k[i],l[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{k}} \\
          &\mu_{\beta_{1k}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\beta_{1l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{l}} \\
          &\mu_{\beta_{1l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\beta_{1l}} \\ 
         \rho_{\beta_{1l}\alpha_{l}} & \sigma^2_{\beta_{1l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

# Group-level predictors work as expected

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1j[i],k[i],l[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1k[i]}^{\alpha}(\operatorname{group}_{\operatorname{low}}) + \gamma_{2k[i]}^{\alpha}(\operatorname{group}_{\operatorname{medium}}) + \gamma_{3k[i],l[i]}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) \\
          &\mu_{\beta_{1j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k} \\
          &\gamma_{1k} \\
          &\gamma_{2k} \\
          &\gamma_{3k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{k}} \\
          &\mu_{\beta_{1k}} \\
          &\mu_{\gamma_{1k}} \\
          &\mu_{\gamma_{2k}} \\
          &\mu_{\gamma_{3k}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccccc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} & \rho_{\alpha_{k}\gamma_{1k}} & \rho_{\alpha_{k}\gamma_{2k}} & \rho_{\alpha_{k}\gamma_{3k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}} & \rho_{\beta_{1k}\gamma_{1k}} & \rho_{\beta_{1k}\gamma_{2k}} & \rho_{\beta_{1k}\gamma_{3k}} \\ 
         \rho_{\gamma_{1k}\alpha_{k}} & \rho_{\gamma_{1k}\beta_{1k}} & \sigma^2_{\gamma_{1k}} & \rho_{\gamma_{1k}\gamma_{2k}} & \rho_{\gamma_{1k}\gamma_{3k}} \\ 
         \rho_{\gamma_{2k}\alpha_{k}} & \rho_{\gamma_{2k}\beta_{1k}} & \rho_{\gamma_{2k}\gamma_{1k}} & \sigma^2_{\gamma_{2k}} & \rho_{\gamma_{2k}\gamma_{3k}} \\ 
         \rho_{\gamma_{3k}\alpha_{k}} & \rho_{\gamma_{3k}\beta_{1k}} & \rho_{\gamma_{3k}\gamma_{1k}} & \rho_{\gamma_{3k}\gamma_{2k}} & \sigma^2_{\gamma_{3k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\beta_{1l} \\
          &\gamma_{3l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{l}} \\
          &\mu_{\beta_{1l}} \\
          &\mu_{\gamma_{3l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\beta_{1l}} & \rho_{\alpha_{l}\gamma_{3l}} \\ 
         \rho_{\beta_{1l}\alpha_{l}} & \sigma^2_{\beta_{1l}} & \rho_{\beta_{1l}\gamma_{3l}} \\ 
         \rho_{\gamma_{3l}\alpha_{l}} & \rho_{\gamma_{3l}\beta_{1l}} & \sigma^2_{\gamma_{3l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1j[i],k[i],l[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1k[i]}^{\alpha}(\operatorname{group}_{\operatorname{low}}) + \gamma_{2k[i]}^{\alpha}(\operatorname{group}_{\operatorname{medium}}) + \gamma_{3k[i],l[i]}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) \\
          &\mu_{\beta_{1j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k} \\
          &\gamma_{1k} \\
          &\gamma_{2k} \\
          &\gamma_{3k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1l[i]}^{\alpha}(\operatorname{prop\_low}) \\
          &\mu_{\beta_{1k}} \\
          &\mu_{\gamma_{1k}} \\
          &\mu_{\gamma_{2k}} \\
          &\mu_{\gamma_{3k}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccccc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} & \rho_{\alpha_{k}\gamma_{1k}} & \rho_{\alpha_{k}\gamma_{2k}} & \rho_{\alpha_{k}\gamma_{3k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}} & \rho_{\beta_{1k}\gamma_{1k}} & \rho_{\beta_{1k}\gamma_{2k}} & \rho_{\beta_{1k}\gamma_{3k}} \\ 
         \rho_{\gamma_{1k}\alpha_{k}} & \rho_{\gamma_{1k}\beta_{1k}} & \sigma^2_{\gamma_{1k}} & \rho_{\gamma_{1k}\gamma_{2k}} & \rho_{\gamma_{1k}\gamma_{3k}} \\ 
         \rho_{\gamma_{2k}\alpha_{k}} & \rho_{\gamma_{2k}\beta_{1k}} & \rho_{\gamma_{2k}\gamma_{1k}} & \sigma^2_{\gamma_{2k}} & \rho_{\gamma_{2k}\gamma_{3k}} \\ 
         \rho_{\gamma_{3k}\alpha_{k}} & \rho_{\gamma_{3k}\beta_{1k}} & \rho_{\gamma_{3k}\gamma_{1k}} & \rho_{\gamma_{3k}\gamma_{2k}} & \sigma^2_{\gamma_{3k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\beta_{1l} \\
          &\gamma_{3l} \\
          &\gamma_{1l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{l}} \\
          &\mu_{\beta_{1l}} \\
          &\mu_{\gamma_{3l}} \\
          &\mu_{\gamma_{1l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cccc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\beta_{1l}} & \rho_{\alpha_{l}\gamma_{3l}} & \rho_{\alpha_{l}\gamma_{1l}} \\ 
         \rho_{\beta_{1l}\alpha_{l}} & \sigma^2_{\beta_{1l}} & \rho_{\beta_{1l}\gamma_{3l}} & \rho_{\beta_{1l}\gamma_{1l}} \\ 
         \rho_{\gamma_{3l}\alpha_{l}} & \rho_{\gamma_{3l}\beta_{1l}} & \sigma^2_{\gamma_{3l}} & \rho_{\gamma_{3l}\gamma_{1l}} \\ 
         \rho_{\gamma_{1l}\alpha_{l}} & \rho_{\gamma_{1l}\beta_{1l}} & \rho_{\gamma_{1l}\gamma_{3l}} & \sigma^2_{\gamma_{1l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1j[i],k[i],l[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{group}_{\operatorname{low}}) + \gamma_{2}^{\alpha}(\operatorname{group}_{\operatorname{medium}}) + \gamma_{3k[i]}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) \\
          &\mu_{\beta_{1j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k} \\
          &\gamma_{3k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{prop\_low}) \\
          &\mu_{\beta_{1k}} \\
          &\mu_{\gamma_{3k}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} & \rho_{\alpha_{k}\gamma_{3k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}} & \rho_{\beta_{1k}\gamma_{3k}} \\ 
         \rho_{\gamma_{3k}\alpha_{k}} & \rho_{\gamma_{3k}\beta_{1k}} & \sigma^2_{\gamma_{3k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\beta_{1l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{dist\_mean}) \\
          &\mu_{\beta_{1l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\beta_{1l}} \\ 
         \rho_{\beta_{1l}\alpha_{l}} & \sigma^2_{\beta_{1l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

# Interactions work as expected

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1}(\operatorname{minority}) + \beta_{2}(\operatorname{female}) + \beta_{3}(\operatorname{female} \times \operatorname{minority}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\gamma_{0}^{\alpha} + \gamma_{1k[i],l[i]}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) + \gamma_{2l[i]}^{\alpha}(\operatorname{group}_{\operatorname{low}}) + \gamma_{3l[i]}^{\alpha}(\operatorname{group}_{\operatorname{medium}}) + \gamma_{4l[i]}^{\alpha}(\operatorname{group}_{\operatorname{low}} \times \operatorname{treatment}_{\operatorname{1}}) + \gamma_{5l[i]}^{\alpha}(\operatorname{group}_{\operatorname{medium}} \times \operatorname{treatment}_{\operatorname{1}}), \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J} \\
        
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\gamma_{1k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{k}} \\
          &\mu_{\gamma_{1k}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\gamma_{1k}} \\ 
         \rho_{\gamma_{1k}\alpha_{k}} & \sigma^2_{\gamma_{1k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\
        
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\gamma_{1l} \\
          &\gamma_{2l} \\
          &\gamma_{3l} \\
          &\gamma_{4l} \\
          &\gamma_{5l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{l}} \\
          &\mu_{\gamma_{1l}} \\
          &\mu_{\gamma_{2l}} \\
          &\mu_{\gamma_{3l}} \\
          &\mu_{\gamma_{4l}} \\
          &\mu_{\gamma_{5l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cccccc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\gamma_{1l}} & \rho_{\alpha_{l}\gamma_{2l}} & \rho_{\alpha_{l}\gamma_{3l}} & \rho_{\alpha_{l}\gamma_{4l}} & \rho_{\alpha_{l}\gamma_{5l}} \\ 
         \rho_{\gamma_{1l}\alpha_{l}} & \sigma^2_{\gamma_{1l}} & \rho_{\gamma_{1l}\gamma_{2l}} & \rho_{\gamma_{1l}\gamma_{3l}} & \rho_{\gamma_{1l}\gamma_{4l}} & \rho_{\gamma_{1l}\gamma_{5l}} \\ 
         \rho_{\gamma_{2l}\alpha_{l}} & \rho_{\gamma_{2l}\gamma_{1l}} & \sigma^2_{\gamma_{2l}} & \rho_{\gamma_{2l}\gamma_{3l}} & \rho_{\gamma_{2l}\gamma_{4l}} & \rho_{\gamma_{2l}\gamma_{5l}} \\ 
         \rho_{\gamma_{3l}\alpha_{l}} & \rho_{\gamma_{3l}\gamma_{1l}} & \rho_{\gamma_{3l}\gamma_{2l}} & \sigma^2_{\gamma_{3l}} & \rho_{\gamma_{3l}\gamma_{4l}} & \rho_{\gamma_{3l}\gamma_{5l}} \\ 
         \rho_{\gamma_{4l}\alpha_{l}} & \rho_{\gamma_{4l}\gamma_{1l}} & \rho_{\gamma_{4l}\gamma_{2l}} & \rho_{\gamma_{4l}\gamma_{3l}} & \sigma^2_{\gamma_{4l}} & \rho_{\gamma_{4l}\gamma_{5l}} \\ 
         \rho_{\gamma_{5l}\alpha_{l}} & \rho_{\gamma_{5l}\gamma_{1l}} & \rho_{\gamma_{5l}\gamma_{2l}} & \rho_{\gamma_{5l}\gamma_{3l}} & \rho_{\gamma_{5l}\gamma_{4l}} & \sigma^2_{\gamma_{5l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{0j[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{0j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) \\
          &\gamma^{\beta_{0}}_{0} + \gamma^{\beta_{0}}_{1}(\operatorname{treatment}_{\operatorname{1}})
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{0j}} \\ 
         \rho_{\beta_{0j}\alpha_{j}} & \sigma^2_{\beta_{0j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for school k = 1,} \dots \text{,K} \\    \alpha_{l}  &\sim N \left(\mu_{\alpha_{l}}, \sigma^2_{\alpha_{l}} \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{0}(\operatorname{wave}), \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) + \gamma_{2}^{\alpha}(\operatorname{treatment}_{\operatorname{1}} \times \operatorname{wave}), \sigma^2_{\alpha_{j}} \right)
        \text{, for sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for school k = 1,} \dots \text{,K} \\
        \alpha_{l}  &\sim N \left(\mu_{\alpha_{l}}, \sigma^2_{\alpha_{l}} \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1j[i],k[i],l[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{group}_{\operatorname{low}}) + \gamma_{2}^{\alpha}(\operatorname{group}_{\operatorname{medium}}) + \gamma_{3l[i]}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) + \gamma_{4}^{\alpha}(\operatorname{group}_{\operatorname{low}} \times \operatorname{treatment}_{\operatorname{1}}) + \gamma_{5}^{\alpha}(\operatorname{group}_{\operatorname{medium}} \times \operatorname{treatment}_{\operatorname{1}}) \\
          &\gamma^{\beta_{1}}_{0} + \gamma^{\beta_{1}}_{1}(\operatorname{group}_{\operatorname{low}}) + \gamma^{\beta_{1}}_{2}(\operatorname{group}_{\operatorname{medium}}) + \gamma^{\beta_{1}}_{3}(\operatorname{treatment}_{\operatorname{1}}) + \gamma^{\beta_{1}}_{4}(\operatorname{group}_{\operatorname{low}} \times \operatorname{treatment}_{\operatorname{1}}) + \gamma^{\beta_{1}}_{5}(\operatorname{group}_{\operatorname{medium}} \times \operatorname{treatment}_{\operatorname{1}})
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{prop\_low}) + \gamma_{2}^{\alpha}(\operatorname{prop\_low} \times \operatorname{treatment}_{\operatorname{1}}) \\
          &\gamma^{\beta_{1}}_{0} + \gamma^{\beta_{1}}_{2}(\operatorname{prop\_low}) + \gamma^{\beta_{1}}_{1}(\operatorname{prop\_low} \times \operatorname{treatment}_{\operatorname{1}})
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\beta_{1l} \\
          &\gamma_{3l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{l}} \\
          &\mu_{\beta_{1l}} \\
          &\mu_{\gamma_{3l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\beta_{1l}} & \rho_{\alpha_{l}\gamma_{3l}} \\ 
         \rho_{\beta_{1l}\alpha_{l}} & \sigma^2_{\beta_{1l}} & \rho_{\beta_{1l}\gamma_{3l}} \\ 
         \rho_{\gamma_{3l}\alpha_{l}} & \rho_{\gamma_{3l}\beta_{1l}} & \sigma^2_{\gamma_{3l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

# Alternate random effect VCV structures work

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{minority}) + \beta_{2j[i]}(\operatorname{female}) + \beta_{3j[i]}(\operatorname{female} \times \operatorname{minority}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j} \\
          &\beta_{3j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}} \\
          &\mu_{\beta_{2j}} \\
          &\mu_{\beta_{3j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cccc}
         \sigma^2_{\alpha_{j}} & 0 & 0 & 0 \\ 
         0 & \sigma^2_{\beta_{1j}} & 0 & 0 \\ 
         0 & 0 & \sigma^2_{\beta_{2j}} & 0 \\ 
         0 & 0 & 0 & \sigma^2_{\beta_{3j}}
      \end{array}
    \right)
     \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{math}_{i}  &\sim N \left(\mu, \sigma^2 \right) \\
        \mu &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{minority}) + \beta_{2j[i]}(\operatorname{female}) + \beta_{3j[i]}(\operatorname{female} \times \operatorname{minority}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j} \\
          &\beta_{3j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}} \\
          &\mu_{\beta_{2j}} \\
          &\mu_{\beta_{3j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cccc}
         \sigma^2_{\alpha_{j}} & 0 & 0 & 0 \\ 
         0 & \sigma^2_{\beta_{1j}} & 0 & 0 \\ 
         0 & 0 & \sigma^2_{\beta_{2j}} & 0 \\ 
         0 & 0 & 0 & \sigma^2_{\beta_{3j}}
      \end{array}
    \right)
     \right)
        \text{, for sch.id j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i],m[i]} + \beta_{1j[i],k[i],m[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{j}} \\
          &\mu_{\beta_{1j}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & 0 \\ 
         0 & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{k}} \\
          &\mu_{\beta_{1k}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    \alpha_{l}  &\sim N \left(\mu_{\alpha_{l}}, \sigma^2_{\alpha_{l}} \right)
        \text{, for school.1 l = 1,} \dots \text{,L} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{m} \\
          &\beta_{1m}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{m}} \\
          &\mu_{\beta_{1m}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{m}} & 0 \\ 
         0 & \sigma^2_{\beta_{1m}}
      \end{array}
    \right)
     \right)
        \text{, for district m = 1,} \dots \text{,M}
    \end{aligned}
    $$

# Nested model syntax works

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for school:sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for sid k = 1,} \dots \text{,K}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for school:sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for sid k = 1,} \dots \text{,K}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i]}, \sigma^2 \right) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for school:sid j = 1,} \dots \text{,J} \\
        \alpha_{k}  &\sim N \left(\mu_{\alpha_{k}}, \sigma^2_{\alpha_{k}} \right)
        \text{, for sid k = 1,} \dots \text{,K}
    \end{aligned}
    $$

# use_coef works

    $$
    \begin{aligned}
      \operatorname{score}_{i}  &\sim N \left(\alpha_{j[i],k[i],l[i]} + \beta_{1j[i],k[i],l[i]}(\operatorname{wave}), \sigma^2 \right) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{group}_{\operatorname{low}}) + \gamma_{2}^{\alpha}(\operatorname{group}_{\operatorname{medium}}) + \gamma_{3l[i]}^{\alpha}(\operatorname{treatment}_{\operatorname{1}}) + \gamma_{4}^{\alpha}(\operatorname{group}_{\operatorname{low}} \times \operatorname{treatment}_{\operatorname{1}}) + \gamma_{5}^{\alpha}(\operatorname{group}_{\operatorname{medium}} \times \operatorname{treatment}_{\operatorname{1}}) \\
          &\gamma^{\beta_{1}}_{0} + \gamma^{\beta_{1}}_{1}(\operatorname{group}_{\operatorname{low}}) + \gamma^{\beta_{1}}_{2}(\operatorname{group}_{\operatorname{medium}}) + \gamma^{\beta_{1}}_{3}(\operatorname{treatment}_{\operatorname{1}}) + \gamma^{\beta_{1}}_{4}(\operatorname{group}_{\operatorname{low}} \times \operatorname{treatment}_{\operatorname{1}}) + \gamma^{\beta_{1}}_{5}(\operatorname{group}_{\operatorname{medium}} \times \operatorname{treatment}_{\operatorname{1}})
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{j}} & \rho_{\alpha_{j}\beta_{1j}} \\ 
         \rho_{\beta_{1j}\alpha_{j}} & \sigma^2_{\beta_{1j}}
      \end{array}
    \right)
     \right)
        \text{, for sid j = 1,} \dots \text{,J} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{k} \\
          &\beta_{1k}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{prop\_low}) + \gamma_{2}^{\alpha}(\operatorname{prop\_low} \times \operatorname{treatment}_{\operatorname{1}}) \\
          &\gamma^{\beta_{1}}_{0} + \gamma^{\beta_{1}}_{1}(\operatorname{prop\_low}) + \gamma^{\beta_{1}}_{1}(\operatorname{prop\_low} \times \operatorname{treatment}_{\operatorname{1}})
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{cc}
         \sigma^2_{\alpha_{k}} & \rho_{\alpha_{k}\beta_{1k}} \\ 
         \rho_{\beta_{1k}\alpha_{k}} & \sigma^2_{\beta_{1k}}
      \end{array}
    \right)
     \right)
        \text{, for school k = 1,} \dots \text{,K} \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{l} \\
          &\beta_{1l} \\
          &\gamma_{3l}
        \end{aligned}
      \end{array}
    \right)
      &\sim MVN \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\mu_{\alpha_{l}} \\
          &\mu_{\beta_{1l}} \\
          &\mu_{\gamma_{3l}}
        \end{aligned}
      \end{array}
    \right)
    , 
    \left(
      \begin{array}{ccc}
         \sigma^2_{\alpha_{l}} & \rho_{\alpha_{l}\beta_{1l}} & \rho_{\alpha_{l}\gamma_{3l}} \\ 
         \rho_{\beta_{1l}\alpha_{l}} & \sigma^2_{\beta_{1l}} & \rho_{\beta_{1l}\gamma_{3l}} \\ 
         \rho_{\gamma_{3l}\alpha_{l}} & \rho_{\gamma_{3l}\beta_{1l}} & \sigma^2_{\gamma_{3l}}
      \end{array}
    \right)
     \right)
        \text{, for district l = 1,} \dots \text{,L}
    \end{aligned}
    $$

