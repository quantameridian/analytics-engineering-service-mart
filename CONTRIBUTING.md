# Contributing

This repository is primarily a portfolio artifact, but contributions and review
comments are welcome if they improve clarity, correctness, or reproducibility.

## Before opening a pull request

1. Keep all data synthetic and non-client.
2. Keep `target/`, `logs/`, local profiles, and virtual environments out of Git.
3. Run:

   ```bash
   make seed
   make run
   make test
   ```

4. Update model documentation when model grain, tests, or metrics change.
5. Explain the business reason for the change, not only the SQL edit.

## Review standard

A change is not ready if it makes the project look more polished while reducing
truthfulness, reproducibility, lineage clarity, or metric confidence.
