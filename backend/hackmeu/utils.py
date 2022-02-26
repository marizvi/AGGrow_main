import threading

from rest_framework.exceptions import NotAuthenticated
from rest_framework.response import Response
from rest_framework.views import exception_handler

from auth_p.serializers import ErrorSerializer

_unauthenticated_serializer = ErrorSerializer(data={'error_message': 'UnAuthenticated'})
assert _unauthenticated_serializer.is_valid()
_unauthenticated_response = Response(_unauthenticated_serializer.validated_data, 401)


def custom_exception_handler(exc, context):
    if isinstance(exc, NotAuthenticated):
        return _unauthenticated_response

    return exception_handler(exc, context)


def run_in_thread(fn):
    def run(*k, **kw):
        t = threading.Thread(target=fn, args=k, kwargs=kw)
        t.start()
        return t

    return run
