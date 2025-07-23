# equatiomatic - to do list

- Check the two last tests in test-lmerMod.R that produce different roundings
    on a silicon processor in macOS. For now these tests are skipped.
    
- Implement the Greek characters colorization for `lme4::lmer()` and
    `lme4::glmer()`.
    
- Refactor `extract_eq()` to ease development of the support of new models (one
    method per file, do not place all possible arguments in the generic, but use
    `...` instead).

- Write a vignette on how to contribute new models (after refactoring, see here
    above).
    
- Implement the piped version of  `extract_eq()` (`create_eq()` as proposed at
    the end of the colors vignette).

- Support Math functions (e.g., `log`, `exp`, `sqrt`) in equations.

- Support polynomial (e.g., `lm(y ~ poly(x, 3))`).

- Implement a range of other models, including multi-level (or mixed effects)
    models (all models supported by {broom}).

- In `lme4::lmer` models, implement `intercept=`, and `raw_tex=`.

- Allow replacing `\operatorname{}` by `\mathrm{}` in the equations for cases
    where `operatorname{}` is not supported (transformation into an expression),
    but there is a proposal to use ` \mathop{\textrm{}}` instead (see https://tex.stackexchange.com/questions/48459/whats-the-difference-between-mathrm-and-operatorname).

- A function that manages all the little problems when converting equations into
    expressions with {latex2exp} (`operatorname{}`, underscore in names, double
    $$, etc).
    
