.PHONY: install audit validate-contract lint seed run test docs preview build-evidence verify-incremental qa build clean

PYTHON ?= python3
DBT ?= dbt
PROFILES_DIR ?= .

install:
	$(PYTHON) -m pip install --upgrade pip setuptools wheel
	$(PYTHON) -m pip install -e '.[dev]'

audit:
	$(PYTHON) -m pip_audit --skip-editable

validate-contract:
	$(PYTHON) scripts/validate_service_mart_contract.py

lint:
	$(PYTHON) -m ruff check scripts

seed:
	$(DBT) seed --profiles-dir $(PROFILES_DIR)

run:
	$(DBT) run --profiles-dir $(PROFILES_DIR)

test:
	$(DBT) test --profiles-dir $(PROFILES_DIR)

docs:
	$(DBT) docs generate --profiles-dir $(PROFILES_DIR)

preview:
	$(PYTHON) scripts/export_mart_preview.py

build-evidence:
	$(PYTHON) scripts/export_build_evidence.py

verify-incremental:
	$(PYTHON) scripts/verify_incremental_idempotency.py --dbt $(DBT) --profiles-dir $(PROFILES_DIR)

qa: validate-contract lint clean build docs preview build-evidence verify-incremental

build:
	$(DBT) build --profiles-dir $(PROFILES_DIR) --full-refresh

clean:
	$(DBT) clean --profiles-dir $(PROFILES_DIR)
