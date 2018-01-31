# ```redis-py``` Docker Image for Redis & Redis Enterprise
Sample Docker image based on Python 3 with redis-py for testing simple python based Redis apps.

Simply run ```Redis-Python-Sample.py``` with hostname and port for a Redis database to test Redis's SET and GET operations:
```
# python Redis-Python-Sample.py 172.17.0.3 12000

Connecting to host=172.17.0.3 and port=12000
Set key 'key1' to value '123' on host=172.17.0.3 and port=12000
Get key 'key1' and validate value is '123' on host=172.17.0.3 and port=12000
DB TEST PASSED
```

For detailed instructions on how to run Redis Enterprise to test out python with Redis visit [Redis Enterprise Hub](https://hub.docker.com/r/redislabs/redis/) or [Redis Hub](https://hub.docker.com/_/redis/).
