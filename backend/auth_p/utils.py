
from rest_framework.response import Response as DRFResponse
from rest_framework.serializers import Serializer, ListSerializer


class Response(DRFResponse):
    def __init__(self, data=None, check_valid=True, *args, **kwargs):
        if isinstance(data, Serializer) or isinstance(data, ListSerializer):
            if check_valid:
                if data.is_valid():
                    data = data.validated_data
                else:
                    raise ValueError(data.errors)
            else:
                data = data.data
        super().__init__(data=data, *args, **kwargs)

