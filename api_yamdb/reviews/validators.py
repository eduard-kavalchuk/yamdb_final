import django.utils.timezone as tz
from rest_framework.exceptions import ValidationError


def year_validator(value):
    if value > tz.now().year:
        raise ValidationError(f'Incorrect year provided: {value}')
