.PHONY: install seed run test build clean

PYTHON ?= python3
DBT ?= dbt
PROFILES_DIR ?= .

install:
	$(PYTHON) -m pip install --upgrade pip setuptools wheel
	$(PYTHON) -m pip install -e '.[dev]'

seed:
	$(DBT) seed --profiles-dir $(PROFILES_DIR)

run:
	$(DBT) run --profiles-dir $(PROFILES_DIR)

test:
	$(DBT) test --profiles-dir $(PROFILES_DIR)

build:
	$(DBT) build --profiles-dir $(PROFILES_DIR)

clean:
	$(DBT) clean --profiles-dir $(PROFILES_DIR)

