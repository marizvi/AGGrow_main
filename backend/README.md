# AGgrow Backend

## Documentation

Swagger UI is available at [swagger ui](https://itsrandom.cf/api/v1/schema/swagger-ui/)

## Description

It provides a well documented REST API for the AGgrow to perform all the necessary operations.

## Installation

For virtual environment:
> python3 -m venv venv

or
> python -m venv venv

Activate the virtual environment:
> source venv/bin/activate

Install dependencies:
> pip install -r requirements.txt

Migrate the database:
> python manage.py migrate

Collect static files:
> python manage.py collectstatic

## Usage

> gunicorn hackmeu.wsgi