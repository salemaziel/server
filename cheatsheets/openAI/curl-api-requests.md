
```
curl https://api.openai.com/v1/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $OPENAI_API_KEY" \
-d '{"model": "text-davinci-003", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 7}'
```


- List Models
Lists the currently available models, and provides basic information about each one such as the owner and availability.
```
GET https://api.openai.com/v1/models
```





- Retrieve Models
```
GET https://api.openai.com/v1/models/{model}
