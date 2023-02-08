# Open AI - Python Library

## Installing
```pip install openai```
* Might need to install python3-aiohttp from package manager

## Upgrading
to upgrade: 
```pip install --upgrade openai```

## Using Library

Once library is installed, can use bindings + secret key (API KEY) to run an example like the following:

### Programatically
```import os
import openai

# Load your API key from an environment variable or secret management service
openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.Completion.create(model="text-davinci-003", prompt="Say this is a test", temperature=0, max_tokens=7)
```

### CLI utility
```$ openai api completions.create -m text-davinci-003 -p "Say this is a test" -t 0 -M 7 --stream```
