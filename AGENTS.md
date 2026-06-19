This repository is a public technical portfolio project focused on analytics engineering, dbt modelling, service reporting marts, metric definitions, lineage, and tested SQL transformations.

## Working rules

- Keep changes narrow and intentional.
- Do not introduce delivery claims, sensitive data, employer-owned material, official data, or exaggerated outcomes.
- Use only realistic non-client sample data.
- Prefer simple, readable architecture over unnecessary complexity.
- Do not create generic tutorial-style content.
- Do not overuse buzzwords.
- Do not rewrite the whole repository unless explicitly requested.
- Keep documentation consistent with the actual code.
- Add tests for meaningful business rules.
- Maintain a clear run path for a reviewer cloning the repo.
- Keep model grains and metric definitions aligned with the implemented SQL.

## Code standards

- Use clear module boundaries.
- Prefer explicit names over clever abstractions.
- Avoid one large script.
- Avoid excessive comments explaining obvious code.
- Include type hints where helpful.
- Keep generated outputs reproducible.
- Prefer small, testable functions.
- Use meaningful test cases based on business rules.
- Keep staging, intermediate, and mart logic separated.
- Do not hide metric logic inside final dashboard assumptions.

## Documentation standards

This repo should explain:

- the business problem
- the data route
- the architecture
- how to run locally
- what outputs are produced
- what is tested
- what is not covered
- how this would translate to a real organisation
- model grain
- metric definitions
- lineage from sources to marts

## Verification

Before considering a task complete, check:

- formatting
- linting
- tests
- README accuracy
- sample output generation
- no protected or sensitive data
- no unsupported delivery claims
- no generic filler copy
- no dbt command is documented as working before it has been implemented and tested
