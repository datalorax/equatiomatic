# colorizing works

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{rating}  \leq  \operatorname{1} ) }{ 1 - P( \operatorname{rating}  \leq  \operatorname{1} ) } \right] &= {\color{#1B9E77}{\alpha}}_{{\color{#666666}{1}}} + {\color{#D95F02}{\beta}}_{{\color{#A6761D}{1}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}})\ + \\
    &\quad {\color{#7570B3}{\beta}}_{{\color{#E6AB02}{2}}}(\operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) + {\color{#E7298A}{\beta}}_{{\color{#66A61E}{3}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}} \times \operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) \\
    \log\left[ \frac { P( \operatorname{rating}  \leq  \operatorname{2} ) }{ 1 - P( \operatorname{rating}  \leq  \operatorname{2} ) } \right] &= {\color{#1B9E77}{\alpha}}_{{\color{#666666}{2}}} + {\color{#D95F02}{\beta}}_{{\color{#A6761D}{1}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}})\ + \\
    &\quad {\color{#7570B3}{\beta}}_{{\color{#E6AB02}{2}}}(\operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) + {\color{#E7298A}{\beta}}_{{\color{#66A61E}{3}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}} \times \operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) \\
    \log\left[ \frac { P( \operatorname{rating}  \leq  \operatorname{3} ) }{ 1 - P( \operatorname{rating}  \leq  \operatorname{3} ) } \right] &= {\color{#1B9E77}{\alpha}}_{{\color{#666666}{3}}} + {\color{#D95F02}{\beta}}_{{\color{#A6761D}{1}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}})\ + \\
    &\quad {\color{#7570B3}{\beta}}_{{\color{#E6AB02}{2}}}(\operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) + {\color{#E7298A}{\beta}}_{{\color{#66A61E}{3}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}} \times \operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) \\
    \log\left[ \frac { P( \operatorname{rating}  \leq  \operatorname{4} ) }{ 1 - P( \operatorname{rating}  \leq  \operatorname{4} ) } \right] &= {\color{#1B9E77}{\alpha}}_{{\color{#666666}{4}}} + {\color{#D95F02}{\beta}}_{{\color{#A6761D}{1}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}})\ + \\
    &\quad {\color{#7570B3}{\beta}}_{{\color{#E6AB02}{2}}}(\operatorname{contact}{\color{orange}{_{\operatorname{yes}}}}) + {\color{#E7298A}{\beta}}_{{\color{#66A61E}{3}}}({\color{blue}{\operatorname{temp}}}_{\operatorname{warm}} \times \operatorname{contact}{\color{orange}{_{\operatorname{yes}}}})
    \end{aligned}
    $$

# Renaming Variables works

    $$
    \begin{aligned}
    P( \operatorname{outcome}  \leq  \operatorname{A} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{catty}_{\operatorname{b}})\ + \\
    &\qquad\ \beta_{2}(\operatorname{catty}_{\operatorname{c}}) + \beta_{3}(\operatorname{catty}_{\operatorname{do\ do\ do}})\ + \\
    &\qquad\ \beta_{4}(\operatorname{catty}_{\operatorname{e}}) + \beta_{5}(\operatorname{Cont\ Var})\ + \\
    &\qquad\ \beta_{6}(\operatorname{catty}_{\operatorname{b}} \times \operatorname{Cont\ Var}) + \beta_{7}(\operatorname{catty}_{\operatorname{c}} \times \operatorname{Cont\ Var})\ + \\
    &\qquad\ \beta_{8}(\operatorname{catty}_{\operatorname{do\ do\ do}} \times \operatorname{Cont\ Var}) + \beta_{9}(\operatorname{catty}_{\operatorname{e}} \times \operatorname{Cont\ Var})] \\
    P( \operatorname{outcome}  \leq  \operatorname{B} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{catty}_{\operatorname{b}})\ + \\
    &\qquad\ \beta_{2}(\operatorname{catty}_{\operatorname{c}}) + \beta_{3}(\operatorname{catty}_{\operatorname{do\ do\ do}})\ + \\
    &\qquad\ \beta_{4}(\operatorname{catty}_{\operatorname{e}}) + \beta_{5}(\operatorname{Cont\ Var})\ + \\
    &\qquad\ \beta_{6}(\operatorname{catty}_{\operatorname{b}} \times \operatorname{Cont\ Var}) + \beta_{7}(\operatorname{catty}_{\operatorname{c}} \times \operatorname{Cont\ Var})\ + \\
    &\qquad\ \beta_{8}(\operatorname{catty}_{\operatorname{do\ do\ do}} \times \operatorname{Cont\ Var}) + \beta_{9}(\operatorname{catty}_{\operatorname{e}} \times \operatorname{Cont\ Var})]
    \end{aligned}
    $$

# Math extraction works

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{A} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{A} ) } \right] &= \alpha_{1} + \beta_{1}(\operatorname{continuous}) + \beta_{2}(\operatorname{continuous^2}) + \beta_{3}(\operatorname{continuous^3}) + \beta_{4}(\operatorname{\log(continuous)}) \\
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{B} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{B} ) } \right] &= \alpha_{2} + \beta_{1}(\operatorname{continuous}) + \beta_{2}(\operatorname{continuous^2}) + \beta_{3}(\operatorname{continuous^3}) + \beta_{4}(\operatorname{\log(continuous)})
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    P( \operatorname{outcome}  \leq  \operatorname{A} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{continuous}) + \beta_{2}(\operatorname{continuous^2}) + \beta_{3}(\operatorname{continuous^3}) + \beta_{4}(\operatorname{\log(continuous)})] \\
    P( \operatorname{outcome}  \leq  \operatorname{B} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{continuous}) + \beta_{2}(\operatorname{continuous^2}) + \beta_{3}(\operatorname{continuous^3}) + \beta_{4}(\operatorname{\log(continuous)})]
    \end{aligned}
    $$

# Collapsing polr factors works

    Code
      extract_eq(model_logit)
    Output
      $$
      \begin{aligned}
      \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{A} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{A} ) } \right] &= \alpha_{1} + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{categorical}_{\operatorname{d}}) + \beta_{4}(\operatorname{categorical}_{\operatorname{e}}) + \beta_{5}(\operatorname{continuous}) + \beta_{6}(\operatorname{categorical}_{\operatorname{b}} \times \operatorname{continuous}) + \beta_{7}(\operatorname{categorical}_{\operatorname{c}} \times \operatorname{continuous}) + \beta_{8}(\operatorname{categorical}_{\operatorname{d}} \times \operatorname{continuous}) + \beta_{9}(\operatorname{categorical}_{\operatorname{e}} \times \operatorname{continuous}) \\
      \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{B} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{B} ) } \right] &= \alpha_{2} + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{categorical}_{\operatorname{d}}) + \beta_{4}(\operatorname{categorical}_{\operatorname{e}}) + \beta_{5}(\operatorname{continuous}) + \beta_{6}(\operatorname{categorical}_{\operatorname{b}} \times \operatorname{continuous}) + \beta_{7}(\operatorname{categorical}_{\operatorname{c}} \times \operatorname{continuous}) + \beta_{8}(\operatorname{categorical}_{\operatorname{d}} \times \operatorname{continuous}) + \beta_{9}(\operatorname{categorical}_{\operatorname{e}} \times \operatorname{continuous})
      \end{aligned}
      $$

---

    Code
      extract_eq(model_probit)
    Output
      $$
      \begin{aligned}
      P( \operatorname{outcome}  \leq  \operatorname{A} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{categorical}_{\operatorname{d}}) + \beta_{4}(\operatorname{categorical}_{\operatorname{e}}) + \beta_{5}(\operatorname{continuous}) + \beta_{6}(\operatorname{categorical}_{\operatorname{b}} \times \operatorname{continuous}) + \beta_{7}(\operatorname{categorical}_{\operatorname{c}} \times \operatorname{continuous}) + \beta_{8}(\operatorname{categorical}_{\operatorname{d}} \times \operatorname{continuous}) + \beta_{9}(\operatorname{categorical}_{\operatorname{e}} \times \operatorname{continuous})] \\
      P( \operatorname{outcome}  \leq  \operatorname{B} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{categorical}_{\operatorname{b}}) + \beta_{2}(\operatorname{categorical}_{\operatorname{c}}) + \beta_{3}(\operatorname{categorical}_{\operatorname{d}}) + \beta_{4}(\operatorname{categorical}_{\operatorname{e}}) + \beta_{5}(\operatorname{continuous}) + \beta_{6}(\operatorname{categorical}_{\operatorname{b}} \times \operatorname{continuous}) + \beta_{7}(\operatorname{categorical}_{\operatorname{c}} \times \operatorname{continuous}) + \beta_{8}(\operatorname{categorical}_{\operatorname{d}} \times \operatorname{continuous}) + \beta_{9}(\operatorname{categorical}_{\operatorname{e}} \times \operatorname{continuous})]
      \end{aligned}
      $$

---

    Code
      extract_eq(model_logit, index_factors = TRUE)
    Output
      $$
      \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{A} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{A} ) } \right] = \alpha + \operatorname{categorical}_{\operatorname{i}} + \operatorname{continuous} + \left(\operatorname{categorical}_{\operatorname{i}} \times \operatorname{continuous}\right) \\
      \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{B} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{B} ) } \right] = \alpha + \operatorname{categorical}_{\operatorname{i}} + \operatorname{continuous} + \left(\operatorname{categorical}_{\operatorname{i}} \times \operatorname{continuous}\right)
      $$

---

    Code
      extract_eq(model_probit, index_factors = TRUE)
    Output
      $$
      P( \operatorname{outcome}  \leq  \operatorname{A} ) = \Phi[\alpha + \operatorname{categorical}_{\operatorname{i}} + \operatorname{continuous} + \left(\operatorname{categorical}_{\operatorname{i}} \times \operatorname{continuous}\right)] \\
      P( \operatorname{outcome}  \leq  \operatorname{B} ) = \Phi[\alpha + \operatorname{categorical}_{\operatorname{i}} + \operatorname{continuous} + \left(\operatorname{categorical}_{\operatorname{i}} \times \operatorname{continuous}\right)]
      $$

# Ordered logistic regression works

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{A} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{A} ) } \right] &= \alpha_{1} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2}) \\
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{B} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{B} ) } \right] &= \alpha_{2} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2})
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{A} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{A} ) } \right] &= \alpha_{1} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\quad \beta_{2}(\operatorname{continuous\_2}) \\
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{B} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{B} ) } \right] &= \alpha_{2} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\quad \beta_{2}(\operatorname{continuous\_2})
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    P( \operatorname{outcome}  \leq  \operatorname{A} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2})] \\
    P( \operatorname{outcome}  \leq  \operatorname{B} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{continuous\_1}) + \beta_{2}(\operatorname{continuous\_2})]
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    P( \operatorname{outcome}  \leq  \operatorname{A} ) &= \Phi[\alpha_{1} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\qquad\ \beta_{2}(\operatorname{continuous\_2})] \\
    P( \operatorname{outcome}  \leq  \operatorname{B} ) &= \Phi[\alpha_{2} + \beta_{1}(\operatorname{continuous\_1})\ + \\
    &\qquad\ \beta_{2}(\operatorname{continuous\_2})]
    \end{aligned}
    $$

---

    $$
    \begin{aligned}
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{A} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{A} ) } \right] &= 1.09 + 0.03(\operatorname{continuous\_1}) - 0.03(\operatorname{continuous\_2}) \\
    \log\left[ \frac { P( \operatorname{outcome}  \leq  \operatorname{B} ) }{ 1 - P( \operatorname{outcome}  \leq  \operatorname{B} ) } \right] &= 2.48 + 0.03(\operatorname{continuous\_1}) - 0.03(\operatorname{continuous\_2})
    \end{aligned}
    $$

