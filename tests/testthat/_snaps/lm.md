# colorizing works

    $$
    \begin{aligned}
    {\color{#0f70f7}{\operatorname{bill\_depth\_mm}}} &= {\color{#1B9E77}{\alpha}} + {\color{#D95F02}{\beta}}_{{\color{#E6AB02}{1}}}({\color{#b22222}{\operatorname{Flipper\ Length\ (MM)}}})\ + \\
    &\quad {\color{#7570B3}{\beta}}_{{\color{#66A61E}{2}}}({\color{green}{\operatorname{ISLAND}}}{\color{cyan}{_{\operatorname{super\ dreamy}}}}) + {\color{#E7298A}{\beta}}_{{\color{#E7298A}{3}}}({\color{green}{\operatorname{ISLAND}}}{\color{cyan}{_{\operatorname{Torgersen}}}})\ + \\
    &\quad {\color{#66A61E}{\beta}}_{{\color{#7570B3}{4}}}({\color{#b22222}{\operatorname{Flipper\ Length\ (MM)}}} \times {\color{green}{\operatorname{ISLAND}}}{\color{cyan}{_{\operatorname{super\ dreamy}}}}) + {\color{#E6AB02}{\beta}}_{{\color{#D95F02}{5}}}({\color{#b22222}{\operatorname{Flipper\ Length\ (MM)}}} \times {\color{green}{\operatorname{ISLAND}}}{\color{cyan}{_{\operatorname{Torgersen}}}})\ + \\
    &\quad {\color{#A6761D}{\epsilon}}
    \end{aligned}
    $$

# Renaming Variables works

    $$
    \operatorname{body\_mass\_g} = \alpha + \beta_{1}(\operatorname{Bill\ Length\ (MM)}) + \beta_{2}(\operatorname{species}_{\operatorname{chinny\ chin\ chin}}) + \beta_{3}(\operatorname{species}_{\operatorname{Gentoo}}) + \beta_{4}(\operatorname{Flipper\ Length\ (MM)}) + \beta_{5}(\operatorname{SEX}_{\operatorname{Male}}) + \beta_{6}(\operatorname{Bill\ Length\ (MM)} \times \operatorname{species}_{\operatorname{chinny\ chin\ chin}}) + \beta_{7}(\operatorname{Bill\ Length\ (MM)} \times \operatorname{species}_{\operatorname{Gentoo}}) + \beta_{8}(\operatorname{Flipper\ Length\ (MM)} \times \operatorname{SEX}_{\operatorname{Male}}) + \epsilon
    $$

# Math extraction works

    $$
    \operatorname{bill\_length\_mm} = \alpha + \beta_{1}(\operatorname{bill\_depth\_mm}) + \beta_{2}(\operatorname{bill\_depth\_mm^2}) + \beta_{3}(\operatorname{bill\_depth\_mm^3}) + \beta_{4}(\operatorname{bill\_depth\_mm^4}) + \beta_{5}(\operatorname{bill\_depth\_mm^5}) + \beta_{6}(\operatorname{\log(flipper\_length\_mm)}) + \beta_{7}(\operatorname{\exp(bill\_length\_mm)}) + \epsilon
    $$

---

    $$
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{hp\ >\ 150}) + \epsilon
    $$

---

    $$
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{hp\ <\ 250}) + \epsilon
    $$

# Collapsing lm factors works

    Code
      extract_eq(m)
    Output
      $$
      \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{gear}_{\operatorname{4}}) + \beta_{2}(\operatorname{gear}_{\operatorname{5}}) + \beta_{3}(\operatorname{carb}_{\operatorname{2}}) + \beta_{4}(\operatorname{carb}_{\operatorname{3}}) + \beta_{5}(\operatorname{carb}_{\operatorname{4}}) + \beta_{6}(\operatorname{carb}_{\operatorname{6}}) + \beta_{7}(\operatorname{carb}_{\operatorname{8}}) + \beta_{8}(\operatorname{disp}) + \beta_{9}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{2}}) + \beta_{10}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{2}}) + \beta_{11}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{3}}) + \beta_{12}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{3}}) + \beta_{13}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{4}}) + \beta_{14}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{4}}) + \beta_{15}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{6}}) + \beta_{16}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{6}}) + \beta_{17}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{8}}) + \beta_{18}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{8}}) + \beta_{19}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{disp}) + \beta_{20}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{disp}) + \beta_{21}(\operatorname{carb}_{\operatorname{2}} \times \operatorname{disp}) + \beta_{22}(\operatorname{carb}_{\operatorname{3}} \times \operatorname{disp}) + \beta_{23}(\operatorname{carb}_{\operatorname{4}} \times \operatorname{disp}) + \beta_{24}(\operatorname{carb}_{\operatorname{6}} \times \operatorname{disp}) + \beta_{25}(\operatorname{carb}_{\operatorname{8}} \times \operatorname{disp}) + \beta_{26}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{2}} \times \operatorname{disp}) + \beta_{27}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{2}} \times \operatorname{disp}) + \beta_{28}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{3}} \times \operatorname{disp}) + \beta_{29}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{3}} \times \operatorname{disp}) + \beta_{30}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{4}} \times \operatorname{disp}) + \beta_{31}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{4}} \times \operatorname{disp}) + \beta_{32}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{6}} \times \operatorname{disp}) + \beta_{33}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{6}} \times \operatorname{disp}) + \beta_{34}(\operatorname{gear}_{\operatorname{4}} \times \operatorname{carb}_{\operatorname{8}} \times \operatorname{disp}) + \beta_{35}(\operatorname{gear}_{\operatorname{5}} \times \operatorname{carb}_{\operatorname{8}} \times \operatorname{disp}) + \epsilon
      $$

---

    Code
      extract_eq(m, index_factors = TRUE)
    Output
      $$
      \operatorname{mpg} = \alpha + \operatorname{gear}_{\operatorname{i}} + \operatorname{carb}_{\operatorname{j}} + \operatorname{disp} + \left(\operatorname{gear}_{\operatorname{i}} \times \operatorname{carb}_{\operatorname{j}}\right) + \left(\operatorname{gear}_{\operatorname{i}} \times \operatorname{disp}\right) + \left(\operatorname{carb}_{\operatorname{j}} \times \operatorname{disp}\right) + \left(\operatorname{gear}_{\operatorname{i}} \times \operatorname{carb}_{\operatorname{j}} \times \operatorname{disp}\right) + \epsilon
      $$

# Labeling works

    $$
    \label{eq: mpg_mod}
    \operatorname{mpg} = \alpha + \beta_{1}(\operatorname{cyl}) + \beta_{2}(\operatorname{disp}) + \epsilon
    $$

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

