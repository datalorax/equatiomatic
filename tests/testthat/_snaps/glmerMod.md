# colorizing works

    $$
    \begin{aligned}
      \operatorname{stops}_{i}  &\sim \operatorname{Poisson}(\lambda_i) \\
        \log(\lambda_i) &=\alpha_{j[i]} + \beta_{1}({\color{red}{\operatorname{Ethnicity}}}{\color{purple}{_{\operatorname{hispanic}}}}) + \beta_{2}({\color{red}{\operatorname{Ethnicity}}}{\color{purple}{_{\operatorname{white}}}}) \\
        \alpha_{j}  &\sim N \left(\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{Total\ Arrests}), \sigma^2_{\alpha_{j}} \right)
        \text{, for precinct j = 1,} \dots \text{,J}
    \end{aligned}
    $$

# Renaming Variables works

    $$
    \begin{aligned}
      \operatorname{stops}_{i}  &\sim \operatorname{Poisson}(\lambda_i) \\
        \log(\lambda_i) &=\alpha_{j[i]} + \beta_{1}(\operatorname{Ethnicity}_{\operatorname{Hispanic/Latino}}) + \beta_{2}(\operatorname{Ethnicity}_{\operatorname{White}}) \\
        \alpha_{j}  &\sim N \left(\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{Total\ Arrests}), \sigma^2_{\alpha_{j}} \right)
        \text{, for precinct j = 1,} \dots \text{,J}
    \end{aligned}
    $$

# Standard Poisson regression models work

    $$
    \begin{aligned}
      \operatorname{stops}_{i}  &\sim \operatorname{Poisson}(\lambda_i) \\
        \log(\lambda_i) &=\alpha_{j[i]} + \beta_{1}(\operatorname{eth}_{\operatorname{hispanic}}) + \beta_{2}(\operatorname{eth}_{\operatorname{white}}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for precinct j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{stops}_{i}  &\sim \operatorname{Poisson}(\lambda_i) \\
        \log(\lambda_i) &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{eth}_{\operatorname{hispanic}}) + \beta_{2j[i]}(\operatorname{eth}_{\operatorname{white}}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j}
        \end{aligned}
      \end{array}
    \right)
      &\sim N \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{total\_arrests}) \\
          &\gamma^{\beta_{1}}_{0} + \gamma^{\beta_{1}}_{1}(\operatorname{total\_arrests}) \\
          &\gamma^{\beta_{2}}_{0} + \gamma^{\beta_{2}}_{1}(\operatorname{total\_arrests})
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
        \text{, for precinct j = 1,} \dots \text{,J}
    \end{aligned}
    $$

# Poisson regression models with an offset work

    $$
    \begin{aligned}
      \operatorname{stops}_{i}  &\sim \operatorname{Poisson}(\lambda_i) \\
        \log(\lambda_i) &=\log(\operatorname{arrests}) + \alpha_{j[i]} + \beta_{1}(\operatorname{eth}_{\operatorname{hispanic}}) + \beta_{2}(\operatorname{eth}_{\operatorname{white}}) \\
        \alpha_{j}  &\sim N \left(\mu_{\alpha_{j}}, \sigma^2_{\alpha_{j}} \right)
        \text{, for precinct j = 1,} \dots \text{,J}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
      \operatorname{stops}_{i}  &\sim \operatorname{Poisson}(\lambda_i) \\
        \log(\lambda_i) &=\log(\operatorname{arrests}) + \alpha_{j[i]} + \beta_{1j[i]}(\operatorname{eth}_{\operatorname{hispanic}}) + \beta_{2j[i]}(\operatorname{eth}_{\operatorname{white}}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j} \\
          &\beta_{2j}
        \end{aligned}
      \end{array}
    \right)
      &\sim N \left(
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\gamma_{0}^{\alpha} + \gamma_{1}^{\alpha}(\operatorname{total\_arrests}) \\
          &\gamma^{\beta_{1}}_{0} + \gamma^{\beta_{1}}_{1}(\operatorname{total\_arrests}) \\
          &\gamma^{\beta_{2}}_{0} + \gamma^{\beta_{2}}_{1}(\operatorname{total\_arrests})
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
        \text{, for precinct j = 1,} \dots \text{,J}
    \end{aligned}
    $$

# Binomial Logistic Regression models work

    $$
    \begin{aligned}
      \operatorname{bush}_{i}  &\sim \operatorname{Binomial}(n = 1, \operatorname{prob}_{\operatorname{bush} = 1} = \widehat{P}) \\
        \log\left[\frac{\hat{P}}{1 - \hat{P}} \right] &=\alpha_{j[i]} + \beta_{1j[i]}(\operatorname{black}) + \beta_{2}(\operatorname{female}) + \beta_{3}(\operatorname{edu}) \\    
    \left(
      \begin{array}{c} 
        \begin{aligned}
          &\alpha_{j} \\
          &\beta_{1j}
        \end{aligned}
      \end{array}
    \right)
      &\sim N \left(
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
        \text{, for state j = 1,} \dots \text{,J}
    \end{aligned}
    $$

