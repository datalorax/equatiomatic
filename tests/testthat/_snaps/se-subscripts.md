# se_subscripts argument works with numeric coefficients

    $$
    \operatorname{\widehat{disp}} = \underset{(116.748)}{67.8}  + \underset{(9.962)}{45.56(\operatorname{cyl})} - \underset{(2.952)}{5.92(\operatorname{mpg})}
    $$

---

    $$
    E( \operatorname{disp} ) = \underset{(116.748)}{\alpha} + \underset{(9.962)}{\beta_{1}(\operatorname{cyl})} + \underset{(2.952)}{\beta_{2}(\operatorname{mpg})}
    $$

---

    $$
    \log\left[ \frac { P( \operatorname{am} = \operatorname{1} ) }{ 1 - P( \operatorname{am} = \operatorname{1} ) } \right] = \underset{(12.194)}{\alpha} + \underset{(0.239)}{\beta_{1}(\operatorname{mpg})} + \underset{(2.547)}{\beta_{2}(\operatorname{wt})}
    $$

# se_subscripts argument works with wrapping

    $$
    \begin{aligned}
    \operatorname{\widehat{disp}} &= \underset{(119.073)}{60.8}\  + \\
    &\quad \underset{(11.801)}{42.46(\operatorname{cyl})}\ - \\
    &\quad \underset{(3.073)}{5.56(\operatorname{mpg})}\ + \\
    &\quad \underset{(0.255)}{0.13(\operatorname{hp})}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \widehat{E( \operatorname{disp} )} &= \underset{(116.748)}{67.8}\  + \\
    &\quad \underset{(9.962)}{45.56(\operatorname{cyl})}\ - \\
    &\quad \underset{(2.952)}{5.92(\operatorname{mpg})}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \widehat{E( \operatorname{disp} )} &= \underset{(116.748)}{67.8}\  + \\
    &\quad \underset{(9.962)}{45.56(\operatorname{cyl})}\ - \\
    &\quad \underset{(2.952)}{5.92(\operatorname{mpg})}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \log\left[ \frac { \widehat{P( \operatorname{am} = \operatorname{1} )} }{ 1 - \widehat{P( \operatorname{am} = \operatorname{1} )} } \right] &= \underset{(12.194)}{25.89}\  - \\
    &\quad \underset{(0.239)}{0.32(\operatorname{mpg})}\ - \\
    &\quad \underset{(2.547)}{6.42(\operatorname{wt})}
    \end{aligned}
    $$

# se_subscripts argument works with Greek letter terms

    $$
    \operatorname{disp} = \underset{(119.073)}{\alpha} + \underset{(11.801)}{\beta_{1}(\operatorname{cyl})} + \underset{(3.073)}{\beta_{2}(\operatorname{mpg})} + \underset{(0.255)}{\beta_{3}(\operatorname{hp})} + \epsilon
    $$

---

    $$
    \begin{aligned}
    \operatorname{disp} &= \underset{(119.073)}{\alpha}\ + \\
    &\quad \underset{(11.801)}{\beta_{1}(\operatorname{cyl})}\ + \\
    &\quad \underset{(3.073)}{\beta_{2}(\operatorname{mpg})}\ + \\
    &\quad \underset{(0.255)}{\beta_{3}(\operatorname{hp})}\ + \\
    &\quad \epsilon
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    E( \operatorname{disp} ) &= \underset{(116.748)}{\alpha}\ + \\
    &\quad \underset{(9.962)}{\beta_{1}(\operatorname{cyl})}\ + \\
    &\quad \underset{(2.952)}{\beta_{2}(\operatorname{mpg})}
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{am} = \operatorname{1} ) }{ 1 - P( \operatorname{am} = \operatorname{1} ) } \right] &= \underset{(12.194)}{\alpha}\ + \\
    &\quad \underset{(0.239)}{\beta_{1}(\operatorname{mpg})}\ + \\
    &\quad \underset{(2.547)}{\beta_{2}(\operatorname{wt})}
    \end{aligned}
    $$

# se_subscripts argument works with transformed variables

    $$
    \operatorname{\widehat{disp}} = \underset{(226.662)}{481.42}  + \underset{(10.942)}{37.32(\operatorname{cyl})} - \underset{(59.243)}{165.48(\operatorname{\log(mpg)})} + \underset{(0.241)}{0.05(\operatorname{hp})}
    $$

---

    $$
    \begin{aligned}
    \operatorname{\widehat{disp}} &= \underset{(226.662)}{481.42}\  + \\
    &\quad \underset{(10.942)}{37.32(\operatorname{cyl})}\ - \\
    &\quad \underset{(59.243)}{165.48(\operatorname{\log(mpg)})}\ + \\
    &\quad \underset{(0.241)}{0.05(\operatorname{hp})}
    \end{aligned}
    $$

---

    $$
    \widehat{E( \operatorname{disp} )} = \underset{(226.662)}{481.42}  + \underset{(10.942)}{37.32(\operatorname{cyl})} - \underset{(59.243)}{165.48(\operatorname{\log(mpg)})} + \underset{(0.241)}{0.05(\operatorname{hp})}
    $$

---

    $$
    \begin{aligned}
    \widehat{E( \operatorname{disp} )} &= \underset{(226.662)}{481.42}\  + \\
    &\quad \underset{(10.942)}{37.32(\operatorname{cyl})}\ - \\
    &\quad \underset{(59.243)}{165.48(\operatorname{\log(mpg)})}\ + \\
    &\quad \underset{(0.241)}{0.05(\operatorname{hp})}
    \end{aligned}
    $$

# se_arguments works with factor variable

    $$
    \widehat{E( \operatorname{disp} )} = \underset{(224.642)}{427.66}  + \underset{(12.253)}{21.95(\operatorname{cyl})} - \underset{(61.235)}{120.45(\operatorname{\log(mpg)})} + \underset{(0.32)}{0.38(\operatorname{hp})} - \underset{(26.627)}{58.06(\operatorname{factor(gear)}_{\operatorname{4}})} - \underset{(35.762)}{66.88(\operatorname{factor(gear)}_{\operatorname{5}})}
    $$

---

    $$
    E( \operatorname{disp} ) = \underset{(224.642)}{\alpha} + \underset{(12.253)}{\beta_{1}(\operatorname{cyl})} + \underset{(61.235)}{\beta_{2}(\operatorname{\log(mpg)})} + \underset{(0.32)}{\beta_{3}(\operatorname{hp})} + \underset{(26.627)}{\beta_{4}(\operatorname{factor(gear)}_{\operatorname{4}})} + \underset{(35.762)}{\beta_{5}(\operatorname{factor(gear)}_{\operatorname{5}})}
    $$

