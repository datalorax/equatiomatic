# Basic ARIMA model functions

    $$
    (1 -\phi_{1}\operatorname{B} )\ (1 -\Phi_{1}\operatorname{B}^{\operatorname{4}} )\ (1 - \operatorname{B}) (y_{t} -\delta\operatorname{t}) = (1 +\theta_{1}\operatorname{B} )\ (1 +\Theta_{1}\operatorname{B}^{\operatorname{4}} )\ \varepsilon_{t}
    $$

---

    $$
    (1 +0.03\operatorname{B} )\ (1 +0.16\operatorname{B}^{\operatorname{4}} )\ (1 - \operatorname{B}) (y_{t} -1e-04\operatorname{t}) = (1 -1\operatorname{B} )\ (1 +0.2\operatorname{B}^{\operatorname{4}} )\ \varepsilon_{t}
    $$

# Regression w/ ARIMA Errors functions

    $$
    \begin{alignat}{2}
    &\text{let}\quad &&y_{t} = \operatorname{y}_{\operatorname{0}} +\delta\operatorname{t} +\beta_{1}\operatorname{x1}_{\operatorname{t}} +\beta_{2}\operatorname{x2}_{\operatorname{t}} +\eta_{t} \\
    &\text{where}\quad  &&(1 -\phi_{1}\operatorname{B} )\ (1 -\Phi_{1}\operatorname{B}^{\operatorname{4}} )\ (1 - \operatorname{B}) \eta_{t}  \\
    & &&= (1 +\theta_{1}\operatorname{B} )\ (1 +\Theta_{1}\operatorname{B}^{\operatorname{4}} )\ \varepsilon_{t} \\
    &\text{where}\quad &&\varepsilon_{t} \sim{WN(0, \sigma^{2})}
    \end{alignat}
    $$

---

    $$
    \begin{alignat}{2}
    &\text{let}\quad &&y_{t} = \operatorname{y}_{\operatorname{0}} +8e-05\operatorname{t} +0.04\operatorname{x1}_{\operatorname{t}} +0.003\operatorname{x2}_{\operatorname{t}} +\eta_{t} \\
    &\text{where}\quad  &&(1 +0.03\operatorname{B} )\ (1 -0.15\operatorname{B}^{\operatorname{4}} )\ (1 - \operatorname{B}) \eta_{t}  \\
    & &&= (1 -1\operatorname{B} )\ (1 -0.18\operatorname{B}^{\operatorname{4}} )\ \varepsilon_{t} \\
    &\text{where}\quad &&\varepsilon_{t} \sim{WN(0, \sigma^{2})}
    \end{alignat}
    $$

